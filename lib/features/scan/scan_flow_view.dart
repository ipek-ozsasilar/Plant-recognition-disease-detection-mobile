import 'dart:typed_data';

import 'package:bitirme_mobile/core/enums/notification_follow_up_enum.dart';
import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/enums/inference_threshold_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/locale/species_class_display.dart';
import 'package:bitirme_mobile/core/locale/scan_flow_localized_error.dart';
import 'package:bitirme_mobile/core/mixins/scaffold_message_mixin.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
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
import 'package:bitirme_mobile/core/services/sink_species_class_repository.dart';
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
import 'package:bitirme_mobile/features/scan/sub_view/scan_plant_picker_sheet.dart';
import 'package:bitirme_mobile/l10n/app_localizations.dart';
import 'package:bitirme_mobile/models/inference_result_model.dart';
import 'package:bitirme_mobile/models/plant_model.dart';
import 'package:bitirme_mobile/models/plant_scan_model.dart';
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

  /// Kayıt sonrası bitki bazlı tek takip bildirimi planlar.
  Future<void> _scheduleFollowUpNotification({
    required PlantScanModel scan,
    required String plantName,
  }) async {
    if (!mounted) {
      return;
    }
    final AppLocalizations l10n = context.l10n;
    await sl<NotificationService>().scheduleScanFollowUp(
      plantId: scan.plantId,
      title: l10n.notificationFollowUpTitle,
      body: scanFollowUpBody(
        l10n: l10n,
        plantName: plantName,
        healthScore: scan.healthScore,
      ),
      healthScore: scan.healthScore,
    );
  }

  bool _isInferenceUnrecognized({
    required InferenceResultModel species,
    required InferenceResultModel disease,
  }) {
    final double spUnit = confidenceToUnit(species.top.confidence);
    final String spRaw = (species.top.rawKey ?? species.top.label).trim();
    final bool spIsSink = sl<SinkSpeciesClassRepository>().snapshot.contains(spRaw);
    final bool spUnrecognized = spIsSink
        ? spUnit < InferenceThresholdEnum.unrecognizedSink.value
        : spUnit < InferenceThresholdEnum.unrecognizedGlobal.value;
    final double disUnit = confidenceToUnit(disease.top.confidence);
    final bool disUnrecognized =
        disUnit < InferenceThresholdEnum.unrecognizedGlobal.value;
    return spUnrecognized || disUnrecognized;
  }

  Future<PlantModel?> _resolvePlantForSave({
    required String ownerUid,
    required String speciesLabel,
    required String displayName,
  }) async {
    final PlantsFirestoreService plantsService = sl<PlantsFirestoreService>();
    final List<PlantModel> sameSpecies = await plantsService.listPlantsForSpecies(
      ownerUid: ownerUid,
      speciesLabel: speciesLabel,
    );

    if (sameSpecies.isEmpty) {
      return plantsService.createPlantForSpecies(
        ownerUid: ownerUid,
        speciesLabel: speciesLabel,
        displayName: displayName,
      );
    }

    if (!mounted) {
      return null;
    }

    final ScanPlantPickerOutcome? pick = await showScanPlantPickerSheet(
      context: context,
      existingPlants: sameSpecies,
    );
    if (pick == null) {
      return null;
    }
    if (pick.createNew) {
      return plantsService.createPlantForSpecies(
        ownerUid: ownerUid,
        speciesLabel: speciesLabel,
        displayName: displayName,
      );
    }
    return pick.plant;
  }

  Future<void> _onSaveScan() async {
    final ScanFlowState s = ref.read(scanFlowProvider);
    final InferenceResultModel? sp = s.species;
    final InferenceResultModel? dis = s.disease;
    if (sp == null || dis == null) {
      return;
    }

    if (_isInferenceUnrecognized(species: sp, disease: dis)) {
      showAppSnackBar(
        context,
        message: context.l10n.errorSpeciesUnknownSave,
        isError: true,
      );
      return;
    }

    final String? uid = ref.read(authProvider).uid;
    if (uid == null || uid.isEmpty) {
      return;
    }

    setState(() => _savingScan = true);

    try {
      final String speciesLabel = sp.top.rawKey ?? sp.top.label;
      final String displayName = speciesClassDisplayForRaw(context, speciesLabel);
      final PlantModel? plant = await _resolvePlantForSave(
        ownerUid: uid,
        speciesLabel: speciesLabel,
        displayName: displayName,
      );
      if (plant == null) {
        return;
      }

      final double diseaseConfUnit = confidenceToUnit(dis.top.confidence);
      final int healthScore = computeHealthScore(
        diseaseKey: dis.top.label,
        diseaseConfidenceUnit: diseaseConfUnit,
      );
      final String scanId = const Uuid().v4();

      String? imageUrl;
      bool photoUploadFailed = false;
      final Uint8List? originalBytes = s.imageBytes;
      if (originalBytes != null) {
        final Uint8List? jpegBytes = sl<ImageCropService>().bytesForScanUpload(
          imageBytes: originalBytes,
          regions: s.regions,
          selectedRegionIndex: s.selectedRegionIndex,
        );
        if (jpegBytes != null) {
          imageUrl = await sl<FirebaseStorageService>().uploadScanImage(
            ownerUid: uid,
            scanId: scanId,
            jpegBytes: jpegBytes,
          );
          photoUploadFailed = imageUrl == null || imageUrl.isEmpty;
        } else {
          photoUploadFailed = true;
        }
      }

      final PlantScanModel scan = PlantScanModel(
        id: scanId,
        ownerUid: uid,
        plantId: plant.id,
        createdAt: DateTime.now(),
        speciesLabel: speciesLabel,
        speciesConfidence: confidenceToUnit(sp.top.confidence),
        diseaseKey: dis.top.label,
        diseaseConfidence: diseaseConfUnit,
        healthScore: healthScore,
        imageUrl: imageUrl,
      );

      await sl<CatalogFirestoreService>().ensureSpecies(rawLabel: scan.speciesLabel);
      await sl<CatalogFirestoreService>().ensureDisease(diseaseKey: scan.diseaseKey);
      await sl<PlantScansFirestoreService>().addScan(scan);

      ref.invalidate(historyFirestoreProvider);
      ref.invalidate(homeStatsProvider);
      ref.invalidate(plantsProvider);
      await ref.read(plantsProvider.notifier).load();
      if (!mounted) {
        return;
      }
      final AppLocalizations l10n = context.l10n;
      await _scheduleFollowUpNotification(scan: scan, plantName: plant.name);

      if (healthScore < NotificationFollowUpEnum.mediumRisk.minHealthScore) {
        await sl<NotificationService>().showRiskAlert(
          title: l10n.notificationRiskTitle,
          body: l10n.notificationRiskBodyFor(plant.name),
        );
      }

      if (!mounted) {
        return;
      }
      showAppSnackBar(
        context,
        message: photoUploadFailed
            ? context.l10n.scanSavedPhotoFailed
            : context.l10n.scanSavedToPlantSuccess,
        isError: photoUploadFailed,
      );
      context.pop();
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

  PlantScanModel? _plantScanFromCurrentInference() {
    final ScanFlowState s = ref.read(scanFlowProvider);
    final InferenceResultModel? sp = s.species;
    final InferenceResultModel? dis = s.disease;
    if (sp == null || dis == null) {
      return null;
    }
    final String? uid = ref.read(authProvider).uid;
    final double diseaseConfUnit = confidenceToUnit(dis.top.confidence);
    return PlantScanModel(
      id: const Uuid().v4(),
      ownerUid: uid ?? '',
      plantId: '',
      createdAt: DateTime.now(),
      speciesLabel: sp.top.rawKey ?? sp.top.label,
      speciesConfidence: confidenceToUnit(sp.top.confidence),
      diseaseKey: dis.top.label,
      diseaseConfidence: diseaseConfUnit,
      healthScore: computeHealthScore(
        diseaseKey: dis.top.label,
        diseaseConfidenceUnit: diseaseConfUnit,
      ),
      imageUrl: null,
    );
  }

  Future<void> _exportPdfFromCurrent() async {
    final PlantScanModel? record = _plantScanFromCurrentInference();
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
    final PlantScanModel? record = _plantScanFromCurrentInference();
    if (record == null) {
      return;
    }
    setState(() => _downloadingPdf = true);
    try {
      final PdfReportService pdf = sl<PdfReportService>();
      final Uint8List bytes = await pdf.buildScanReportPdf(
        record: record,
        l10n: context.l10n,
      );
      await sl<PdfFileSaveService>().saveToDevice(
        bytes: bytes,
        filename: 'phytoguard_report.pdf',
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scanTitle),
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
      case ScanStep.speciesLoading:
        return _buildLoading(l10n.scanSpeciesLoading);
      case ScanStep.speciesDone:
        return _buildSpeciesDone(context, l10n, state, notifier);
      case ScanStep.diseaseLoading:
        return _buildLoading(l10n.scanDiseaseLoading);
      case ScanStep.diseaseDone:
        return _buildDiseaseDone(context, l10n, state, notifier);
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
                  await notifier.runSpecies();
                },
        ),
      ],
    );
  }

  Widget _buildLoading(String message) {
    return ScanLoadingWidget(message: message);
  }

  Widget _buildSpeciesDone(
    BuildContext context,
    AppLocalizations l10n,
    ScanFlowState state,
    ScanFlowNotifier notifier,
  ) {
    final InferenceResultModel? sp = state.species;
    if (sp == null) {
      return const SizedBox.shrink();
    }
    final double unit = confidenceToUnit(sp.top.confidence);
    final String raw = (sp.top.rawKey ?? sp.top.label).trim();
    final bool isSink = sl<SinkSpeciesClassRepository>().snapshot.contains(raw);
    final bool unrecognized = isSink
        ? unit < InferenceThresholdEnum.unrecognizedSink.value
        : unit < InferenceThresholdEnum.unrecognizedGlobal.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          l10n.scanSpeciesTitle,
          style: TextStyle(
            fontSize: TextSizesEnum.title.value,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        Card(
          child: ListTile(
            title: Text(
              unrecognized
                  ? l10n.scanUnrecognizedTitle
                  : speciesInferenceTopForUi(context, sp.top),
            ),
            subtitle: Text(
              unrecognized
                  ? l10n.scanUnrecognizedBody
                  : '${l10n.scanSpeciesConfidence}: ${confidencePercentLabel(sp.top.confidence)}',
            ),
            trailing: unrecognized
                ? null
                : TextButton(
                    onPressed: () => context.push(
                      '${AppPaths.speciesDetail}/${Uri.encodeComponent(sp.top.rawKey ?? sp.top.label)}?confidence=$unit',
                    ),
                    child: Text(l10n.detailCta),
                  ),
          ),
        ),
        const Spacer(),
        AppPrimaryButton(
          label: l10n.continueCta,
          onPressed: () async {
            await notifier.runDisease();
          },
        ),
      ],
    );
  }

  Widget _buildDiseaseDone(
    BuildContext context,
    AppLocalizations l10n,
    ScanFlowState state,
    ScanFlowNotifier notifier,
  ) {
    final InferenceResultModel? dis = state.disease;
    if (dis == null) {
      return const SizedBox.shrink();
    }
    final double unit = confidenceToUnit(dis.top.confidence);
    final bool unrecognized =
        unit < InferenceThresholdEnum.unrecognizedGlobal.value;
    final String diseaseText = diseaseClassKeyToDisplay(dis.top.label, l10n);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          l10n.scanDiseaseTitle,
          style: TextStyle(
            fontSize: TextSizesEnum.title.value,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        Text(
          l10n.scanDiseaseNote,
          style: TextStyle(
            fontSize: TextSizesEnum.caption.value,
            color: context.palMuted,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        Card(
          child: ListTile(
            title: Text(
              unrecognized ? l10n.scanUnrecognizedTitle : diseaseText,
            ),
            subtitle: Text(
              unrecognized
                  ? l10n.scanUnrecognizedBody
                  : '${l10n.scanSpeciesConfidence}: ${confidencePercentLabel(dis.top.confidence)}',
            ),
            trailing: unrecognized
                ? null
                : TextButton(
                    onPressed: () => context.push(
                      '${AppPaths.diseaseDetail}/${Uri.encodeComponent(dis.top.label)}?confidence=$unit',
                    ),
                    child: Text(l10n.detailCta),
                  ),
          ),
        ),
        const Spacer(),
        AppPrimaryButton(
          label: l10n.continueCta,
          onPressed: notifier.goToSummary,
        ),
      ],
    );
  }

  Widget _buildSummary(
    BuildContext context,
    AppLocalizations l10n,
    ScanFlowState state,
    ScanFlowNotifier notifier,
  ) {
    final InferenceResultModel? sp = state.species;
    final InferenceResultModel? dis = state.disease;
    if (sp == null || dis == null) {
      return const SizedBox.shrink();
    }
    final double spUnit = confidenceToUnit(sp.top.confidence);
    final double disUnit = confidenceToUnit(dis.top.confidence);
    final String spRaw = (sp.top.rawKey ?? sp.top.label).trim();
    final bool spIsSink = sl<SinkSpeciesClassRepository>().snapshot.contains(
      spRaw,
    );
    final bool spUnrecognized = spIsSink
        ? spUnit < InferenceThresholdEnum.unrecognizedSink.value
        : spUnit < InferenceThresholdEnum.unrecognizedGlobal.value;
    final bool disUnrecognized =
        disUnit < InferenceThresholdEnum.unrecognizedGlobal.value;
    final String diseaseText = diseaseClassKeyToDisplay(dis.top.label, l10n);
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
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        Card(
          child: ListTile(
            title: Text(l10n.scanSpeciesTitle),
            subtitle: Text(
              spUnrecognized
                  ? l10n.scanUnrecognizedTitle
                  : '${speciesInferenceTopForUi(context, sp.top)} (${confidencePercentLabel(sp.top.confidence)})',
            ),
          ),
        ),
        Card(
          child: ListTile(
            title: Text(l10n.scanDiseaseTitle),
            subtitle: Text(
              disUnrecognized
                  ? l10n.scanUnrecognizedTitle
                  : '$diseaseText (${confidencePercentLabel(dis.top.confidence)})',
            ),
          ),
        ),
        const Spacer(),
        AppPrimaryButton(
          label: l10n.scanExportPdfCta,
          isLoading: _exportingPdf,
          onPressed: _exportPdfFromCurrent,
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        AppPrimaryButton(
          label: l10n.scanDownloadPdfCta,
          isLoading: _downloadingPdf,
          onPressed: _downloadPdfFromCurrent,
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        AppPrimaryButton(
          label: l10n.scanSaveToPlantCta,
          isLoading: _savingScan,
          onPressed: _onSaveScan,
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        OutlinedButton(
          onPressed: () {
            notifier.reset();
          },
          child: Text(l10n.scanRetry),
        ),
      ],
    );
  }
}
