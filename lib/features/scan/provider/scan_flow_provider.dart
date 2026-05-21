import 'dart:typed_data';

import 'package:bitirme_mobile/core/enums/duration_enum.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/core/services/image_crop_service.dart';
import 'package:bitirme_mobile/core/services/inference_api_service.dart';
import 'package:bitirme_mobile/models/scan_region_analysis_model.dart';
import 'package:bitirme_mobile/models/plant_region_model.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// Tarama adımları.
enum ScanStep {
  pickImage,
  selectRegions,
  analyzingSpecies,
  speciesDone,
  analyzingDisease,
  summary,
}

/// Tarama akışı durumu.
class ScanFlowState {
  const ScanFlowState({
    required this.step,
    this.imageBytes,
    this.regions = const <PlantRegionModel>[],
    this.selectedRegionIndex = 0,
    this.regionAnalyses = const <ScanRegionAnalysis>[],
    this.analyzingRegionIndex = 0,
    this.errorMessage,
  });

  final ScanStep step;
  final Uint8List? imageBytes;
  final List<PlantRegionModel> regions;
  final int selectedRegionIndex;
  final List<ScanRegionAnalysis> regionAnalyses;
  final int analyzingRegionIndex;
  final String? errorMessage;

  ScanRegionAnalysis? get firstSavableAnalysis {
    for (final ScanRegionAnalysis a in regionAnalyses) {
      if (a.canSaveToHistory) {
        return a;
      }
    }
    return null;
  }

  int get savableRegionCount =>
      regionAnalyses.where((ScanRegionAnalysis a) => a.canSaveToHistory).length;

  ScanFlowState copyWith({
    ScanStep? step,
    Uint8List? imageBytes,
    List<PlantRegionModel>? regions,
    int? selectedRegionIndex,
    List<ScanRegionAnalysis>? regionAnalyses,
    int? analyzingRegionIndex,
    String? errorMessage,
    bool clearAnalyses = false,
    bool clearError = false,
  }) {
    return ScanFlowState(
      step: step ?? this.step,
      imageBytes: imageBytes ?? this.imageBytes,
      regions: regions ?? this.regions,
      selectedRegionIndex: selectedRegionIndex ?? this.selectedRegionIndex,
      regionAnalyses: clearAnalyses
          ? const <ScanRegionAnalysis>[]
          : (regionAnalyses ?? this.regionAnalyses),
      analyzingRegionIndex: analyzingRegionIndex ?? this.analyzingRegionIndex,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Çoklu bölge: önce tüm bölgelerde tür, sonra Devam ile hastalık.
class ScanFlowNotifier extends Notifier<ScanFlowState> {
  final Uuid _uuid = const Uuid();

  @override
  ScanFlowState build() {
    return const ScanFlowState(step: ScanStep.pickImage);
  }

  void reset() {
    state = const ScanFlowState(step: ScanStep.pickImage);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void setImage(Uint8List bytes) {
    state = ScanFlowState(
      step: ScanStep.selectRegions,
      imageBytes: bytes,
      regions: const <PlantRegionModel>[],
      selectedRegionIndex: 0,
    );
  }

  void addRegionAtNormalized(double nx, double ny) {
    final Uint8List? bytes = state.imageBytes;
    if (bytes == null) {
      return;
    }
    final ImageCropService crop = sl<ImageCropService>();
    final PlantRegionModel base = crop.regionAroundTap(nx: nx, ny: ny);
    final PlantRegionModel region = PlantRegionModel(
      id: _uuid.v4(),
      nx: base.nx,
      ny: base.ny,
      nw: base.nw,
      nh: base.nh,
    );
    final List<PlantRegionModel> next = List<PlantRegionModel>.from(state.regions)..add(region);
    state = state.copyWith(
      regions: next,
      selectedRegionIndex: next.length - 1,
      clearError: true,
    );
  }

  void addRegionFromDragRect({
    required double startNx,
    required double startNy,
    required double endNx,
    required double endNy,
  }) {
    final Uint8List? bytes = state.imageBytes;
    if (bytes == null) {
      return;
    }
    final ImageCropService crop = sl<ImageCropService>();
    final PlantRegionModel base = crop.regionFromDragRect(
      startNx: startNx,
      startNy: startNy,
      endNx: endNx,
      endNy: endNy,
    );
    final PlantRegionModel region = PlantRegionModel(
      id: _uuid.v4(),
      nx: base.nx,
      ny: base.ny,
      nw: base.nw,
      nh: base.nh,
    );
    final List<PlantRegionModel> next = List<PlantRegionModel>.from(state.regions)..add(region);
    state = state.copyWith(
      regions: next,
      selectedRegionIndex: next.length - 1,
      clearError: true,
    );
  }

  void selectRegion(int index) {
    if (index < 0 || index >= state.regions.length) {
      return;
    }
    state = state.copyWith(selectedRegionIndex: index);
  }

  void clearRegions() {
    state = state.copyWith(
      regions: <PlantRegionModel>[],
      selectedRegionIndex: 0,
      clearAnalyses: true,
      clearError: true,
    );
  }

  /// Yükleme adımının en az bir kare çizilmesini sağlar.
  Future<void> _ensureLoadingScreenVisible() async {
    await Future<void>.delayed(Duration.zero);
    await SchedulerBinding.instance.endOfFrame;
  }

  Future<void> _ensureMinLoadingDuration(Stopwatch elapsed) async {
    final int remaining =
        DurationEnum.scanLoadingMin.milliseconds - elapsed.elapsedMilliseconds;
    if (remaining > 0) {
      await Future<void>.delayed(Duration(milliseconds: remaining));
    }
  }

  Future<Uint8List?> _cropForRegion({
    required Uint8List imageBytes,
    required PlantRegionModel region,
    required int regionIndex,
    required List<PlantRegionModel> regions,
    required ScanStep backStep,
  }) async {
    final Uint8List? cropped = sl<ImageCropService>().cropRegion(
      imageBytes: imageBytes,
      region: region,
    );
    if (cropped == null) {
      state = ScanFlowState(
        step: backStep,
        imageBytes: imageBytes,
        regions: regions,
        selectedRegionIndex: regionIndex,
        regionAnalyses: state.regionAnalyses,
        errorMessage: '@@errorCrop',
      );
    }
    return cropped;
  }

  /// Her bölge için yalnızca tür analizi.
  Future<void> runAllRegionsSpecies() async {
    final List<PlantRegionModel> regions = state.regions;
    final Uint8List? imageBytes = state.imageBytes;
    if (imageBytes == null || regions.isEmpty) {
      state = state.copyWith(errorMessage: '@@scanRegionsSelectPrompt');
      return;
    }

    final InferenceApiService inference = sl<InferenceApiService>();

    state = ScanFlowState(
      step: ScanStep.analyzingSpecies,
      imageBytes: imageBytes,
      regions: regions,
      selectedRegionIndex: state.selectedRegionIndex,
      analyzingRegionIndex: 0,
      regionAnalyses: const <ScanRegionAnalysis>[],
    );
    final Stopwatch loadingTimer = Stopwatch()..start();
    await _ensureLoadingScreenVisible();

    final List<ScanRegionAnalysis> results = <ScanRegionAnalysis>[];

    try {
      for (int i = 0; i < regions.length; i++) {
        state = state.copyWith(analyzingRegionIndex: i);
        final PlantRegionModel region = regions[i];
        final Uint8List? cropped = await _cropForRegion(
          imageBytes: imageBytes,
          region: region,
          regionIndex: i,
          regions: regions,
          backStep: ScanStep.selectRegions,
        );
        if (cropped == null) {
          return;
        }
        final species = await inference.predictSpecies(cropped);
        results.add(
          ScanRegionAnalysis(
            regionIndex: i,
            region: region,
            species: species,
          ),
        );
      }

      await _ensureMinLoadingDuration(loadingTimer);
      state = ScanFlowState(
        step: ScanStep.speciesDone,
        imageBytes: imageBytes,
        regions: regions,
        selectedRegionIndex: state.selectedRegionIndex,
        regionAnalyses: results,
      );
    } catch (e, st) {
      sl<AppLogger>().e('inference_species_regions', e, st);
      state = ScanFlowState(
        step: ScanStep.selectRegions,
        imageBytes: imageBytes,
        regions: regions,
        selectedRegionIndex: state.analyzingRegionIndex,
        errorMessage: '@@errorInference',
      );
    }
  }

  /// Tür sonrası: her bölge için hastalık analizi, ardından özet.
  Future<void> runAllRegionsDisease() async {
    final List<PlantRegionModel> regions = state.regions;
    final Uint8List? imageBytes = state.imageBytes;
    final List<ScanRegionAnalysis> prior = state.regionAnalyses;
    if (imageBytes == null || regions.isEmpty || prior.isEmpty) {
      return;
    }

    final InferenceApiService inference = sl<InferenceApiService>();

    state = ScanFlowState(
      step: ScanStep.analyzingDisease,
      imageBytes: imageBytes,
      regions: regions,
      selectedRegionIndex: state.selectedRegionIndex,
      analyzingRegionIndex: 0,
      regionAnalyses: prior,
    );
    final Stopwatch loadingTimer = Stopwatch()..start();
    await _ensureLoadingScreenVisible();

    final List<ScanRegionAnalysis> results = <ScanRegionAnalysis>[];

    try {
      for (int i = 0; i < prior.length; i++) {
        state = state.copyWith(analyzingRegionIndex: i);
        final ScanRegionAnalysis entry = prior[i];
        final Uint8List? cropped = await _cropForRegion(
          imageBytes: imageBytes,
          region: entry.region,
          regionIndex: entry.regionIndex,
          regions: regions,
          backStep: ScanStep.speciesDone,
        );
        if (cropped == null) {
          return;
        }
        final disease = await inference.predictDisease(cropped);
        results.add(entry.copyWithDisease(disease));
      }

      await _ensureMinLoadingDuration(loadingTimer);
      state = ScanFlowState(
        step: ScanStep.summary,
        imageBytes: imageBytes,
        regions: regions,
        selectedRegionIndex: state.selectedRegionIndex,
        regionAnalyses: results,
      );
    } catch (e, st) {
      sl<AppLogger>().e('inference_disease_regions', e, st);
      state = ScanFlowState(
        step: ScanStep.speciesDone,
        imageBytes: imageBytes,
        regions: regions,
        selectedRegionIndex: state.analyzingRegionIndex,
        regionAnalyses: prior,
        errorMessage: '@@errorInference',
      );
    }
  }
}

final NotifierProvider<ScanFlowNotifier, ScanFlowState> scanFlowProvider =
    NotifierProvider<ScanFlowNotifier, ScanFlowState>(ScanFlowNotifier.new);
