import 'dart:typed_data';

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
import 'package:bitirme_mobile/core/services/pdf_report_service.dart';
import 'package:bitirme_mobile/core/services/notification_service.dart';
import 'package:bitirme_mobile/core/services/image_crop_service.dart';
import 'package:bitirme_mobile/core/services/sink_species_class_repository.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/utils/confidence_format.dart';
import 'package:bitirme_mobile/core/widgets/animation/scan_loading_widget.dart';
import 'package:bitirme_mobile/core/widgets/button/app_primary_button.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/features/history/provider/history_firestore_provider.dart';
import 'package:bitirme_mobile/features/settings/home_stats_provider.dart';
import 'package:bitirme_mobile/features/plants/provider/plants_provider.dart';
import 'package:bitirme_mobile/features/scan/provider/scan_flow_provider.dart';
import 'package:bitirme_mobile/features/scan/sub_view/plant_region_picker_widget.dart';
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
  bool _savingToPlant = false;
  bool _savingToHistory = false;
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

  /// Analiz sonucuna göre bildirim planlar.
  Future<void> _scheduleFollowUpNotification(PlantScanModel scan) async {
    final NotificationService svc = sl<NotificationService>();
    final bool enabled = await svc.isEnabled();
    if (!enabled) return;

    int days;
    String body;
    final String plantName = scan.plantId == 'general'
        ? speciesClassDisplayForRaw(context, scan.speciesLabel)
        : scan.plantId; // Bitki adı l10n ile daha iyi yönetilebilir.

    if (scan.healthScore >= 85) {
      days = 7;
      body = context
          .l10n
          .notificationWateringBody; // "Sağlıklı, 7 gün sonra kontrol et"
    } else if (scan.healthScore >= 70) {
      days = 5;
      body =
          "${context.l10n.homeGreeting}! $plantName için hafif risk tespiti. 5 gün sonra tekrar kontrol önerilir.";
    } else if (scan.healthScore >= 55) {
      days = 3;
      body =
          context.l10n.notificationRiskBody; // "Orta risk, 3 gün sonra kontrol"
    } else {
      days = 1;
      body =
          "Acil: $plantName durumu ciddi görünüyor. Lütfen yarın tekrar kontrol edin.";
    }

    await svc.scheduleDailyWatering(
      title: context.l10n.notificationWateringTitle,
      body: body,
      // Not: Servisinizde 'delayDays' parametresi olduğunu varsayıyoruz veya
      // o servisi buna göre güncelliyoruz.
    );
  }

  Future<void> _onSaveToPlant() async {
    final ScanFlowState s = ref.read(scanFlowProvider);
    final InferenceResultModel? sp = s.species;
    final InferenceResultModel? dis = s.disease;
    if (sp == null || dis == null) {
      return;
    }

    // Tür tanınamadıysa veya güven skoru çok düşükse kaydetmeye izin verme
    final double spUnit = confidenceToUnit(sp.top.confidence);
    final String spRaw = (sp.top.rawKey ?? sp.top.label).trim();
    final bool spIsSink = sl<SinkSpeciesClassRepository>().snapshot.contains(
      spRaw,
    );
    final bool spUnrecognized = spIsSink
        ? spUnit < InferenceThresholdEnum.unrecognizedSink.value
        : spUnit < InferenceThresholdEnum.unrecognizedGlobal.value;

    if (spUnrecognized) {
      showAppSnackBar(
        context,
        message: context.l10n.errorSpeciesUnknownSave,
        isError: true,
      );
      return;
    }

    await ref.read(plantsProvider.notifier).load();
    if (!mounted) {
      return;
    }
    // 'Tanınmadı' (unrecognized) olan, türü veya hastalığı belirsiz bitkileri seçim listesinden filtrele
    final List<PlantModel> validPlants = ref.read(plantsProvider).items.where((
      p,
    ) {
      final String unrecognized = context.l10n.scanUnrecognizedTitle
          .toLowerCase();
      final String name = p.name.toLowerCase();
      final String label = p.speciesLabel.toLowerCase();
      // Not: PlantModel içinde direkt diseaseKey yoksa speciesLabel üzerinden kontrol edilir.
      return !name.contains(unrecognized) &&
          !label.contains(unrecognized) &&
          !label.contains('unknown');
    }).toList();

    if (validPlants.isEmpty) {
      showAppSnackBar(
        context,
        message: context.l10n.myPlantsEmpty,
        isError: true,
      );
      return;
    }

    final PlantModel? selected = await showModalBottomSheet<PlantModel>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (BuildContext ctx) {
        final double pad = WidgetSizesEnum.cardRadius.value * 1.15;
        return Padding(
          padding: EdgeInsets.fromLTRB(pad, pad, pad, pad),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                context.l10n.scanSaveToPlantTitle,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: TextSizesEnum.subtitle.value,
                ),
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.75),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: validPlants.length,
                  separatorBuilder: (_, __) =>
                      SizedBox(height: WidgetSizesEnum.divider.value * 8),
                  itemBuilder: (BuildContext context, int index) {
                    final PlantModel p = validPlants[index];
                    return SoftElevationCard(
                      onTap: () => Navigator.of(ctx).pop(p),
                      padding: EdgeInsets.all(
                        WidgetSizesEnum.cardRadius.value * 0.9,
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: WidgetSizesEnum.cardRadius.value * 1.9,
                            height: WidgetSizesEnum.cardRadius.value * 1.9,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(
                                WidgetSizesEnum.chipRadius.value,
                              ),
                            ),
                            child: Icon(
                              Icons.local_florist_rounded,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          SizedBox(
                            width: WidgetSizesEnum.cardRadius.value * 0.75,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  p.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                                SizedBox(
                                  height: WidgetSizesEnum.divider.value * 4,
                                ),
                                Text(
                                  speciesClassDisplayForRaw(
                                    context,
                                    p.speciesLabel,
                                  ),
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.65),
                                    fontSize: TextSizesEnum.caption.value,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.45),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selected == null || !mounted) {
      return;
    }

    setState(() => _savingToPlant = true);
    final double diseaseConfUnit = confidenceToUnit(dis.top.confidence);
    final int healthScore = computeHealthScore(
      diseaseKey: dis.top.label,
      diseaseConfidenceUnit: diseaseConfUnit,
    );
    final String riskTitle = context.l10n.notificationRiskTitle;
    final String riskBody = context.l10n.notificationRiskBody;

    final PlantScanModel scan = PlantScanModel(
      id: const Uuid().v4(),
      ownerUid: selected.ownerUid,
      plantId: selected.id,
      createdAt: DateTime.now(),
      speciesLabel: sp.top.rawKey ?? sp.top.label,
      speciesConfidence: confidenceToUnit(sp.top.confidence),
      diseaseKey: dis.top.label,
      diseaseConfidence: diseaseConfUnit,
      healthScore: healthScore,
      imageUrl: null,
    );
    String? imageUrl;
    final Uint8List? originalBytes = s.imageBytes;
    if (originalBytes != null && s.regions.isNotEmpty) {
      final int idx = s.selectedRegionIndex.clamp(0, s.regions.length - 1);
      final Uint8List? cropped = sl<ImageCropService>().cropRegion(
        imageBytes: originalBytes,
        region: s.regions[idx],
      );
      if (cropped != null) {
        imageUrl = await sl<FirebaseStorageService>().uploadJpegBytes(
          path: 'users/${selected.ownerUid}/scans/${scan.id}.jpg',
          bytes: cropped,
        );
      }
    }
    final PlantScanModel scanWithImage = PlantScanModel(
      id: scan.id,
      ownerUid: scan.ownerUid,
      plantId: scan.plantId,
      createdAt: scan.createdAt,
      speciesLabel: scan.speciesLabel,
      speciesConfidence: scan.speciesConfidence,
      diseaseKey: scan.diseaseKey,
      diseaseConfidence: scan.diseaseConfidence,
      healthScore: scan.healthScore,
      imageUrl: imageUrl,
    );
    await sl<CatalogFirestoreService>().ensureSpecies(
      rawLabel: scanWithImage.speciesLabel,
    );
    await sl<CatalogFirestoreService>().ensureDisease(
      diseaseKey: scanWithImage.diseaseKey,
    );

    // Hem bitkiyi güncelle hem de geçmişe (scans) kaydet
    await sl<PlantScansFirestoreService>().addScan(scanWithImage);
    ref.invalidate(historyFirestoreProvider);
    ref.invalidate(homeStatsProvider); // İstatistikleri güncelle
    await _scheduleFollowUpNotification(scanWithImage);

    if (healthScore < 55) {
      await sl<NotificationService>().showRiskAlert(
        title: riskTitle,
        body: riskBody,
      );
    }
    if (!mounted) {
      return;
    }
    setState(() => _savingToPlant = false);
    showAppSnackBar(
      context,
      message: context.l10n.scanSavedToPlantSuccess,
      isError: false,
    );
  }

  Future<void> _onSaveToHistoryOnly() async {
    final ScanFlowState s = ref.read(scanFlowProvider);
    final InferenceResultModel? sp = s.species;
    final InferenceResultModel? dis = s.disease;
    if (sp == null || dis == null) return;

    final String? uid = ref.read(authProvider).uid;
    if (uid == null) return;

    setState(() => _savingToHistory = true);

    String? imageUrl;
    final String scanId = const Uuid().v4();
    final double diseaseConfUnit = confidenceToUnit(dis.top.confidence);
    final int healthScore = computeHealthScore(
      diseaseKey: dis.top.label,
      diseaseConfidenceUnit: diseaseConfUnit,
    );

    if (s.imageBytes != null && s.regions.isNotEmpty) {
      final int idx = s.selectedRegionIndex.clamp(0, s.regions.length - 1);
      final Uint8List? cropped = sl<ImageCropService>().cropRegion(
        imageBytes: s.imageBytes!,
        region: s.regions[idx],
      );
      if (cropped != null) {
        imageUrl = await sl<FirebaseStorageService>().uploadJpegBytes(
          path: 'users/$uid/scans/$scanId.jpg',
          bytes: cropped,
        );
      }
    }

    final PlantScanModel finalScan = PlantScanModel(
      id: scanId,
      ownerUid: uid,
      plantId: 'general',
      createdAt: DateTime.now(),
      speciesLabel: sp.top.rawKey ?? sp.top.label,
      speciesConfidence: confidenceToUnit(sp.top.confidence),
      diseaseKey: dis.top.label,
      diseaseConfidence: diseaseConfUnit,
      healthScore: healthScore,
      imageUrl: imageUrl,
    );

    await sl<CatalogFirestoreService>().ensureSpecies(
      rawLabel: finalScan.speciesLabel,
    );
    await sl<CatalogFirestoreService>().ensureDisease(
      diseaseKey: finalScan.diseaseKey,
    );
    await sl<PlantScansFirestoreService>().addScan(finalScan);

    ref.invalidate(historyFirestoreProvider);
    ref.invalidate(homeStatsProvider); // İstatistikleri güncelle

    if (!mounted) return;
    setState(() => _savingToHistory = false);

    showAppSnackBar(context, message: context.l10n.scanSavedToPlantSuccess);
    // Kayıttan sonra ana sayfaya veya geçmişe yönlendirilebilir
    context.pop();
  }

  Future<void> _exportPdfFromCurrent() async {
    final ScanFlowState s = ref.read(scanFlowProvider);
    final InferenceResultModel? sp = s.species;
    final InferenceResultModel? dis = s.disease;
    if (sp == null || dis == null) {
      return;
    }
    final String? uid = ref.read(authProvider).uid;
    setState(() => _exportingPdf = true);

    final double diseaseConfUnit = confidenceToUnit(dis.top.confidence);
    final int healthScore = computeHealthScore(
      diseaseKey: dis.top.label,
      diseaseConfidenceUnit: diseaseConfUnit,
    );

    final PlantScanModel record = PlantScanModel(
      id: const Uuid().v4(),
      ownerUid: uid ?? '',
      plantId: 'general',
      createdAt: DateTime.now(),
      speciesLabel: sp.top.rawKey ?? sp.top.label,
      speciesConfidence: confidenceToUnit(sp.top.confidence),
      diseaseKey: dis.top.label,
      diseaseConfidence: diseaseConfUnit,
      healthScore: healthScore,
      imageUrl: null,
    );
    final PdfReportService pdf = sl<PdfReportService>();
    final Uint8List bytes = await pdf.buildScanReportPdf(
      record: record,
      l10n: context.l10n,
    );
    await Printing.sharePdf(bytes: bytes, filename: 'phytoguard_report.pdf');
    if (!mounted) {
      return;
    }
    setState(() => _exportingPdf = false);
  }

  Future<void> _downloadPdfFromCurrent() async {
    final ScanFlowState s = ref.read(scanFlowProvider);
    final InferenceResultModel? sp = s.species;
    final InferenceResultModel? dis = s.disease;
    if (sp == null || dis == null) {
      return;
    }
    final String? uid = ref.read(authProvider).uid;
    setState(() => _downloadingPdf = true);

    final double diseaseConfUnit = confidenceToUnit(dis.top.confidence);
    final int healthScore = computeHealthScore(
      diseaseKey: dis.top.label,
      diseaseConfidenceUnit: diseaseConfUnit,
    );

    final PlantScanModel record = PlantScanModel(
      id: const Uuid().v4(),
      ownerUid: uid ?? '',
      plantId: 'general',
      createdAt: DateTime.now(),
      speciesLabel: sp.top.rawKey ?? sp.top.label,
      speciesConfidence: confidenceToUnit(sp.top.confidence),
      diseaseKey: dis.top.label,
      diseaseConfidence: diseaseConfUnit,
      healthScore: healthScore,
      imageUrl: null,
    );
    final PdfReportService pdf = sl<PdfReportService>();
    final Uint8List bytes = await pdf.buildScanReportPdf(
      record: record,
      l10n: context.l10n,
    );
    // Mobil cihazlarda 'Paylaş' menüsü üzerinden 'Dosyalara Kaydet' seçeneği en 'direkt' indirme yoludur.
    await Printing.sharePdf(bytes: bytes, filename: 'phytoguard_report.pdf');
    if (!mounted) {
      return;
    }
    setState(() => _downloadingPdf = false);
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
          label: l10n.scanSaveHistory,
          isLoading: _savingToHistory,
          onPressed: _onSaveToHistoryOnly,
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.75),
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
          isLoading: _savingToPlant,
          onPressed: _onSaveToPlant,
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
