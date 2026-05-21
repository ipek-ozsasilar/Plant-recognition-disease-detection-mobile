import 'dart:typed_data';

import 'package:bitirme_mobile/core/enums/notification_follow_up_enum.dart';
import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/locale/species_class_display.dart';
import 'package:bitirme_mobile/core/locale/scan_flow_localized_error.dart';
import 'package:bitirme_mobile/core/mixins/scaffold_message_mixin.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/core/services/catalog_firestore_service.dart';
import 'package:bitirme_mobile/core/services/disease_label_display.dart';
import 'package:bitirme_mobile/core/services/firebase_storage_service.dart';
import 'package:bitirme_mobile/core/services/health_score_service.dart';
import 'package:bitirme_mobile/core/services/pdf_file_save_service.dart';
import 'package:bitirme_mobile/core/services/pdf_report_service.dart';
import 'package:bitirme_mobile/core/locale/scan_follow_up_notification_text.dart';
import 'package:bitirme_mobile/core/services/notification_service.dart';
import 'package:bitirme_mobile/core/services/image_crop_service.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/utils/confidence_format.dart';
import 'package:bitirme_mobile/core/widgets/animation/scan_loading_widget.dart';
import 'package:bitirme_mobile/core/widgets/button/app_primary_button.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/features/history/provider/history_firestore_provider.dart';
import 'package:bitirme_mobile/features/settings/home_stats_provider.dart';
import 'package:bitirme_mobile/features/plants/provider/plants_provider.dart';
import 'package:bitirme_mobile/features/scan/provider/scan_flow_provider.dart';
import 'package:bitirme_mobile/features/scan/sub_view/plant_region_picker_widget.dart';
import 'package:bitirme_mobile/l10n/app_localizations.dart';
import 'package:bitirme_mobile/models/inference_result_model.dart';
import 'package:bitirme_mobile/models/plant_model.dart';
import 'package:bitirme_mobile/models/plant_region_model.dart';
import 'package:bitirme_mobile/models/plant_scan_model.dart';
import 'package:bitirme_mobile/models/scan_region_analysis_model.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:bitirme_mobile/core/services/plant_scans_firestore_service.dart';
import 'package:bitirme_mobile/core/services/plants_firestore_service.dart';
import 'package:printing/printing.dart';

/// Tarama sihirbazı: görüntü → bölge → tür → hastalık → özet.
class ScanFlowView extends ConsumerStatefulWidget {
  const ScanFlowView({super.key});

  @override
  ConsumerState<ScanFlowView> createState() => _ScanFlowViewState();
}

class _ScanFlowViewState extends ConsumerState<ScanFlowView>
    with ScaffoldMessageMixin {
  final ImagePicker _picker = ImagePicker();
  bool _savingScan = false;
  bool _exportingPdf = false;
  bool _downloadingPdf = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(scanFlowProvider.notifier).reset();
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final double maxPx = ImageSizesEnum.galleryPickMax.value;
      final XFile? file = await _picker.pickImage(
        source: source,
        imageQuality: 88,
        maxWidth: maxPx,
        maxHeight: maxPx,
      );
      if (file == null) {
        return;
      }
      final Uint8List bytes = await file.readAsBytes();
      ref.read(scanFlowProvider.notifier).setImage(bytes);
    } catch (e, st) {
      sl<AppLogger>().e('image_pick', e, st);
      if (mounted) {
        showAppSnackBar(
          context,
          message: context.l10n.errorImagePick,
          isError: true,
        );
      }
    }
  }

  /// Kayıt sonrası bildirim: hastalık net değilse tür/bakım; netse risk + takip.
  Future<void> _notifyAfterSave({
    required PlantScanModel scan,
    required PlantModel plant,
    required String speciesDisplayName,
    required bool diseaseUnrecognized,
  }) async {
    if (!mounted) {
      return;
    }
    final AppLocalizations l10n = context.l10n;
    final NotificationService notifications = sl<NotificationService>();

    if (diseaseUnrecognized) {
      await notifications.showSpeciesCareTip(
        title: l10n.notificationSpeciesTipTitle,
        body: l10n.notificationSpeciesTipBody(plant.name, speciesDisplayName),
      );
      await notifications.scheduleScanFollowUp(
        plantId: scan.plantId,
        title: l10n.notificationFollowUpTitle,
        body: l10n.notificationFollowUpSpeciesOnly(plant.name, speciesDisplayName),
        healthScore: NotificationFollowUpEnum.healthy.minHealthScore,
      );
      return;
    }

    await notifications.scheduleScanFollowUp(
      plantId: scan.plantId,
      title: l10n.notificationFollowUpTitle,
      body: scanFollowUpBody(
        l10n: l10n,
        plantName: plant.name,
        healthScore: scan.healthScore,
      ),
      healthScore: scan.healthScore,
    );

    if (scan.healthScore < NotificationFollowUpEnum.mediumRisk.minHealthScore) {
      await notifications.showRiskAlert(
        title: l10n.notificationRiskTitle,
        body: l10n.notificationRiskBodyFor(plant.name),
      );
    }
  }

  /// Tür etiketine göre bitki: yoksa oluşturur, varsa en son taramalı kaydı kullanır.
  Future<PlantModel> _resolvePlantForSave({
    required String ownerUid,
    required String speciesLabel,
    required String displayName,
    required Map<String, PlantModel> plantBySpecies,
  }) async {
    final PlantModel? cached = plantBySpecies[speciesLabel];
    if (cached != null) {
      return cached;
    }
    final PlantsFirestoreService plantsService = sl<PlantsFirestoreService>();
    final List<PlantModel> sameSpecies = await plantsService.listPlantsForSpecies(
      ownerUid: ownerUid,
      speciesLabel: speciesLabel,
    );

    final PlantModel resolved;
    if (sameSpecies.isEmpty) {
      resolved = await plantsService.createPlantForSpecies(
        ownerUid: ownerUid,
        speciesLabel: speciesLabel,
        displayName: displayName,
      );
    } else {
      resolved = _defaultPlantForSpecies(sameSpecies);
    }
    plantBySpecies[speciesLabel] = resolved;
    return resolved;
  }

  PlantModel _defaultPlantForSpecies(List<PlantModel> plants) {
    if (plants.length == 1) {
      return plants.first;
    }
    return plants.reduce((PlantModel best, PlantModel candidate) {
      final DateTime? bestScan = best.lastScanDate;
      final DateTime? candidateScan = candidate.lastScanDate;
      if (bestScan != null && candidateScan != null) {
        return candidateScan.isAfter(bestScan) ? candidate : best;
      }
      if (candidateScan != null) {
        return candidate;
      }
      if (bestScan != null) {
        return best;
      }
      return candidate.createdAt.isAfter(best.createdAt) ? candidate : best;
    });
  }

  Future<void> _onSaveScan() async {
    final ScanFlowState s = ref.read(scanFlowProvider);
    final List<ScanRegionAnalysis> analyses = s.regionAnalyses;
    if (analyses.isEmpty) {
      return;
    }

    final List<ScanRegionAnalysis> savable =
        analyses.where((ScanRegionAnalysis a) => a.canSaveToHistory).toList();
    if (savable.isEmpty) {
      showAppSnackBar(
        context,
        message: context.l10n.scanSaveMultiNone,
        isError: true,
      );
      return;
    }

    final String? uid = ref.read(authProvider).uid;
    if (uid == null || uid.isEmpty) {
      return;
    }

    setState(() => _savingScan = true);
    final AppLocalizations l10n = context.l10n;
    final Map<String, PlantModel> plantBySpecies = <String, PlantModel>{};
    int savedCount = 0;
    bool anyPhotoFailed = false;

    try {
      final bool multiRegion = s.regions.length > 1;

      for (final ScanRegionAnalysis analysis in savable) {
        final InferenceResultModel sp = analysis.species;
        final InferenceResultModel dis = analysis.disease!;
        final String speciesLabel = sp.top.rawKey ?? sp.top.label;
        final String displayName = speciesClassDisplayForExport(l10n, speciesLabel);
        final PlantModel plant = await _resolvePlantForSave(
          ownerUid: uid,
          speciesLabel: speciesLabel,
          displayName: displayName,
          plantBySpecies: plantBySpecies,
        );

        final bool diseaseUnrecognized =
            isDiseaseInferenceUnrecognized(dis);
        final String storedDiseaseKey = diseaseKeyForScanStorage(
          diseaseUnrecognized: diseaseUnrecognized,
          modelLabel: dis.top.rawKey ?? dis.top.label,
        );
        final double diseaseConfUnit = diseaseUnrecognized
            ? 0.0
            : confidenceToUnit(dis.top.confidence);
        final int healthScore = computeHealthScore(
          diseaseKey: storedDiseaseKey,
          diseaseConfidenceUnit: diseaseConfUnit,
        );
        final String scanId = const Uuid().v4();

        String? imageUrl;
        String? thumbnailUrl;
        List<PlantRegionModel>? regionMarkers;
        int? regionIndex;
        final Uint8List? originalBytes = s.imageBytes;
        if (originalBytes != null) {
          final ImageCropService cropService = sl<ImageCropService>();
          if (multiRegion) {
            final int idx = analysis.regionIndex.clamp(0, s.regions.length - 1);
            final Uint8List? regionJpeg = cropService.cropRegion(
              imageBytes: originalBytes,
              region: s.regions[idx],
            );
            if (regionJpeg != null) {
              imageUrl = await sl<FirebaseStorageService>().uploadScanImage(
                ownerUid: uid,
                scanId: scanId,
                jpegBytes: regionJpeg,
              );
              if (imageUrl == null || imageUrl.isEmpty) {
                anyPhotoFailed = true;
              } else {
                thumbnailUrl = imageUrl;
              }
            } else {
              anyPhotoFailed = true;
            }
            regionIndex = analysis.regionIndex;
          } else {
            final Uint8List? jpegBytes = cropService.bytesForScanUpload(
              imageBytes: originalBytes,
              regions: s.regions,
              selectedRegionIndex: analysis.regionIndex,
            );
            if (jpegBytes != null) {
              imageUrl = await sl<FirebaseStorageService>().uploadScanImage(
                ownerUid: uid,
                scanId: scanId,
                jpegBytes: jpegBytes,
              );
              if (imageUrl == null || imageUrl.isEmpty) {
                anyPhotoFailed = true;
              }
            } else {
              anyPhotoFailed = true;
            }
          }
        }

        final String? regionNote = analyses.length > 1
            ? l10n.scanRegionNote(analysis.regionIndex + 1)
            : null;

        final PlantScanModel scan = PlantScanModel(
          id: scanId,
          ownerUid: uid,
          plantId: plant.id,
          createdAt: DateTime.now(),
          speciesLabel: speciesLabel,
          speciesConfidence: confidenceToUnit(sp.top.confidence),
          diseaseKey: storedDiseaseKey,
          diseaseConfidence: diseaseConfUnit,
          healthScore: healthScore,
          imageUrl: imageUrl,
          thumbnailUrl: thumbnailUrl,
          regionMarkers: regionMarkers,
          regionIndex: regionIndex,
          notes: regionNote,
        );

        await sl<CatalogFirestoreService>().ensureSpecies(rawLabel: scan.speciesLabel);
        if (!diseaseUnrecognized) {
          await sl<CatalogFirestoreService>().ensureDisease(diseaseKey: scan.diseaseKey);
        }
        await sl<PlantScansFirestoreService>().addScan(scan);
        savedCount++;

        await _notifyAfterSave(
          scan: scan,
          plant: plant,
          speciesDisplayName: displayName,
          diseaseUnrecognized: diseaseUnrecognized,
        );
      }

      ref.invalidate(historyFirestoreProvider);
      ref.invalidate(homeStatsProvider);
      ref.invalidate(plantsProvider);
      await ref.read(plantsProvider.notifier).load();

      if (!mounted) {
        return;
      }

      final int skipped = analyses.length - savable.length;
      String message;
      if (savedCount == 1) {
        message = l10n.scanSavedToPlantSuccess;
      } else if (skipped > 0) {
        message = l10n.scanSaveMultiWithSkipped(savedCount, skipped);
      } else {
        message = l10n.scanSaveMultiSuccess(savedCount);
      }
      if (anyPhotoFailed) {
        message = l10n.scanSavedPhotoFailed;
      }

      if (savedCount > 0) {
        context.pop(message);
      } else {
        showAppSnackBar(
          context,
          message: l10n.scanSaveMultiNone,
          isError: true,
        );
      }
    } catch (e, st) {
      sl<AppLogger>().e('scan_save', e, st);
      if (mounted) {
        showAppSnackBar(
          context,
          message: context.l10n.errorGeneric,
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _savingScan = false);
      }
    }
  }

  PlantScanModel? _plantScanFromFirstSavable() {
    final ScanFlowState s = ref.read(scanFlowProvider);
    final ScanRegionAnalysis? analysis = s.firstSavableAnalysis;
    if (analysis == null) {
      return null;
    }
    final String? uid = ref.read(authProvider).uid;
    final InferenceResultModel? dis = analysis.disease;
    if (dis == null) {
      return null;
    }
    final bool diseaseUnrecognized = isDiseaseInferenceUnrecognized(dis);
    final String storedDiseaseKey = diseaseKeyForScanStorage(
      diseaseUnrecognized: diseaseUnrecognized,
      modelLabel: dis.top.rawKey ?? dis.top.label,
    );
    final double diseaseConfUnit = diseaseUnrecognized
        ? 0.0
        : confidenceToUnit(dis.top.confidence);
    return PlantScanModel(
      id: const Uuid().v4(),
      ownerUid: uid ?? '',
      plantId: '',
      createdAt: DateTime.now(),
      speciesLabel: analysis.species.top.rawKey ?? analysis.species.top.label,
      speciesConfidence: confidenceToUnit(analysis.species.top.confidence),
      diseaseKey: storedDiseaseKey,
      diseaseConfidence: diseaseConfUnit,
      healthScore: computeHealthScore(
        diseaseKey: storedDiseaseKey,
        diseaseConfidenceUnit: diseaseConfUnit,
      ),
      imageUrl: null,
    );
  }

  Future<void> _exportPdfFromCurrent() async {
    final PlantScanModel? record = _plantScanFromFirstSavable();
    if (record == null) {
      return;
    }
    setState(() => _exportingPdf = true);
    try {
      final PdfReportService pdf = sl<PdfReportService>();
      final Uint8List bytes = await pdf.buildScanReportPdf(
        record: record,
        l10n: context.l10n,
      );
      await Printing.sharePdf(bytes: bytes, filename: 'phytoguard_report.pdf');
    } catch (e, st) {
      sl<AppLogger>().e('pdf_share', e, st);
      if (mounted) {
        showAppSnackBar(
          context,
          message: context.l10n.scanPdfDownloadError,
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _exportingPdf = false);
      }
    }
  }

  Future<void> _downloadPdfFromCurrent() async {
    final PlantScanModel? record = _plantScanFromFirstSavable();
    if (record == null) {
      return;
    }
    setState(() => _downloadingPdf = true);
    final AppLocalizations l10n = context.l10n;
    try {
      final PdfReportService pdf = sl<PdfReportService>();
      final Uint8List bytes = await pdf.buildScanReportPdf(
        record: record,
        l10n: l10n,
      );
      await sl<PdfFileSaveService>().saveToDevice(
        bytes: bytes,
        filename: 'phytoguard_report.pdf',
        notificationTitle: l10n.pdfDownloadNotificationTitle,
        notificationBodyForFile: l10n.pdfDownloadNotificationBody,
      );
      if (mounted) {
        showAppSnackBar(
          context,
          message: context.l10n.scanPdfDownloadSuccess,
          isError: false,
        );
      }
    } catch (e, st) {
      sl<AppLogger>().e('pdf_download', e, st);
      if (mounted) {
        showAppSnackBar(
          context,
          message: context.l10n.scanPdfDownloadError,
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _downloadingPdf = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    ref.listen<ScanFlowState>(scanFlowProvider, (
      ScanFlowState? previous,
      ScanFlowState next,
    ) {
      final String? msg = next.errorMessage;
      if (msg != null && msg.isNotEmpty) {
        showAppSnackBar(
          context,
          message: localizedScanFlowError(msg, l10n),
          isError: true,
        );
        ref.read(scanFlowProvider.notifier).clearError();
      }
    });

    final ScanFlowState state = ref.watch(scanFlowProvider);
    final ScanFlowNotifier notifier = ref.read(scanFlowProvider.notifier);

    final String appBarTitle = switch (state.step) {
      ScanStep.analyzingSpecies => l10n.scanSpeciesLoading,
      ScanStep.analyzingDisease => l10n.scanDiseaseLoading,
      _ => l10n.scanTitle,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.25),
          child: _buildBody(context, l10n, state, notifier),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    ScanFlowState state,
    ScanFlowNotifier notifier,
  ) {
    switch (state.step) {
      case ScanStep.pickImage:
        return _buildPick(context, l10n);
      case ScanStep.selectRegions:
        return _buildRegions(context, l10n, state, notifier);
      case ScanStep.analyzingSpecies:
        return _buildAnalyzingPage(l10n, state, isSpecies: true);
      case ScanStep.speciesDone:
        return _buildSpeciesDone(context, l10n, state, notifier);
      case ScanStep.analyzingDisease:
        return _buildAnalyzingPage(l10n, state, isSpecies: false);
      case ScanStep.summary:
        return _buildSummary(context, l10n, state, notifier);
    }
  }

  Widget _buildPick(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          l10n.scanPickTitle,
          style: TextStyle(
            fontSize: TextSizesEnum.title.value,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.5),
        AppPrimaryButton(
          label: l10n.scanPickCamera,
          onPressed: () => _pickImage(ImageSource.camera),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        AppPrimaryButton(
          label: l10n.scanPickGallery,
          onPressed: () => _pickImage(ImageSource.gallery),
        ),
      ],
    );
  }

  Widget _buildRegions(
    BuildContext context,
    AppLocalizations l10n,
    ScanFlowState state,
    ScanFlowNotifier notifier,
  ) {
    final Uint8List? bytes = state.imageBytes;
    if (bytes == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          l10n.scanRegionsTitle,
          style: TextStyle(
            fontSize: TextSizesEnum.title.value,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        Text(
          l10n.scanRegionsHint,
          style: TextStyle(
            fontSize: TextSizesEnum.body.value,
            color: context.palMuted,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        Expanded(
          child: PlantRegionPickerWidget(
            bytes: bytes,
            regions: state.regions,
            selectedIndex: state.selectedRegionIndex,
            onCreateRegionFromDrag:
                ({
                  required double startNx,
                  required double startNy,
                  required double endNx,
                  required double endNy,
                }) => notifier.addRegionFromDragRect(
                  startNx: startNx,
                  startNy: startNy,
                  endNx: endNx,
                  endNy: endNy,
                ),
            onSelectRegion: notifier.selectRegion,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        Row(
          children: <Widget>[
            TextButton(
              onPressed: state.regions.isEmpty ? null : notifier.clearRegions,
              child: Text(l10n.scanRegionsClear),
            ),
            const Spacer(),
            Text(
              '${l10n.scanRegionsAdd}: ${state.regions.length}',
              style: TextStyle(color: context.palMuted),
            ),
          ],
        ),
        AppPrimaryButton(
          label: l10n.scanRegionsNext,
          onPressed: state.regions.isEmpty
              ? null
              : () async {
                  await notifier.runAllRegionsSpecies();
                },
        ),
      ],
    );
  }

  /// Tür / hastalık analizi — tam ekran laser yükleme (aynı bileşen).
  Widget _buildAnalyzingPage(
    AppLocalizations l10n,
    ScanFlowState state, {
    required bool isSpecies,
  }) {
    final int current = state.analyzingRegionIndex + 1;
    final int total = state.regions.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: ScanLoadingWidget(
            message: isSpecies ? l10n.scanSpeciesLoading : l10n.scanDiseaseLoading,
            icon: isSpecies ? Icons.eco_rounded : Icons.biotech_rounded,
            subtitle: total > 1
                ? (isSpecies
                    ? l10n.scanAnalyzingRegionSpecies(current, total)
                    : l10n.scanAnalyzingRegionDisease(current, total))
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSpeciesDone(
    BuildContext context,
    AppLocalizations l10n,
    ScanFlowState state,
    ScanFlowNotifier notifier,
  ) {
    final List<ScanRegionAnalysis> analyses = state.regionAnalyses;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          l10n.scanSpeciesResultsTitle,
          style: TextStyle(
            fontSize: TextSizesEnum.title.value,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.divider.value * 8),
        Text(
          l10n.scanSpeciesResultsHint,
          style: TextStyle(
            fontSize: TextSizesEnum.body.value,
            color: context.palMuted,
            height: 1.4,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        Expanded(
          child: ListView(
            children: analyses
                .map(
                  (ScanRegionAnalysis a) => _buildRegionResultCard(
                    context,
                    l10n,
                    a,
                    showDisease: false,
                  ),
                )
                .toList(),
          ),
        ),
        AppPrimaryButton(
          label: l10n.continueCta,
          onPressed: () async {
            await notifier.runAllRegionsDisease();
          },
        ),
      ],
    );
  }

  Widget _buildRegionResultCard(
    BuildContext context,
    AppLocalizations l10n,
    ScanRegionAnalysis analysis, {
    bool showDisease = true,
  }) {
    final String speciesLine = analysis.speciesUnrecognized
        ? l10n.scanUnrecognizedTitle
        : '${speciesInferenceTopForUi(context, analysis.species.top)} '
            '(${confidencePercentLabel(analysis.species.top.confidence)})';
    final String diseaseLine = !showDisease || !analysis.hasDisease
        ? l10n.scanDiseasePending
        : '${diseaseDisplayForInference(
            analysis.disease!.top,
            l10n,
            unrecognized: analysis.diseaseUnrecognized,
          )} (${confidencePercentLabel(analysis.disease!.top.confidence)})';

    return Card(
      margin: EdgeInsets.only(bottom: WidgetSizesEnum.cardRadius.value * 0.65),
      child: Padding(
        padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 0.85),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.scanRegionLabel(analysis.regionIndex + 1),
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: TextSizesEnum.body.value,
                color: context.palOnSurface,
              ),
            ),
            SizedBox(height: WidgetSizesEnum.divider.value * 6),
            Text(
              l10n.scanSpeciesTitle,
              style: TextStyle(
                fontSize: TextSizesEnum.caption.value,
                color: context.palMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(speciesLine),
            if (showDisease) ...<Widget>[
              SizedBox(height: WidgetSizesEnum.divider.value * 6),
              Text(
                l10n.scanDiseaseTitle,
                style: TextStyle(
                  fontSize: TextSizesEnum.caption.value,
                  color: context.palMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(diseaseLine),
            ],
            if (!showDisease && analysis.speciesUnrecognized) ...<Widget>[
              SizedBox(height: WidgetSizesEnum.divider.value * 6),
              Text(
                l10n.errorSpeciesUnknownSave,
                style: TextStyle(
                  fontSize: TextSizesEnum.caption.value,
                  color: context.palAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            if (showDisease && !analysis.canSaveToHistory) ...<Widget>[
              SizedBox(height: WidgetSizesEnum.divider.value * 6),
              Text(
                l10n.errorSpeciesUnknownSave,
                style: TextStyle(
                  fontSize: TextSizesEnum.caption.value,
                  color: context.palAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(
    BuildContext context,
    AppLocalizations l10n,
    ScanFlowState state,
    ScanFlowNotifier notifier,
  ) {
    final List<ScanRegionAnalysis> analyses = state.regionAnalyses;
    if (analyses.isEmpty) {
      return const SizedBox.shrink();
    }
    final int savable = state.savableRegionCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          l10n.scanSummaryTitle,
          style: TextStyle(
            fontSize: TextSizesEnum.title.value,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.divider.value * 8),
        Text(
          l10n.scanSummaryMultiHint,
          style: TextStyle(
            fontSize: TextSizesEnum.body.value,
            color: context.palMuted,
            height: 1.4,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        Expanded(
          child: ListView(
            children: analyses
                .map(
                  (ScanRegionAnalysis a) => _buildRegionResultCard(
                    context,
                    l10n,
                    a,
                    showDisease: true,
                  ),
                )
                .toList(),
          ),
        ),
        AppPrimaryButton(
          label: l10n.scanExportPdfCta,
          isLoading: _exportingPdf,
          onPressed: savable > 0 ? _exportPdfFromCurrent : null,
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        AppPrimaryButton(
          label: l10n.scanDownloadPdfCta,
          isLoading: _downloadingPdf,
          onPressed: savable > 0 ? _downloadPdfFromCurrent : null,
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        AppPrimaryButton(
          label: savable > 0
              ? l10n.scanSaveMultiCta(savable)
              : l10n.scanSaveToPlantCta,
          isLoading: _savingScan,
          onPressed: savable == 0 ? null : _onSaveScan,
        ),
      ],
    );
  }
}
