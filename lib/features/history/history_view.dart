import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/locale/species_class_display.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/core/mixins/scaffold_message_mixin.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/core/services/pdf_file_save_service.dart';
import 'package:bitirme_mobile/core/services/pdf_report_service.dart';
import 'package:bitirme_mobile/core/services/disease_label_display.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/appbar/conditional_back_leading.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/core/widgets/button/app_primary_button.dart';
import 'package:bitirme_mobile/core/services/plant_scan_display_helper.dart';
import 'package:bitirme_mobile/core/widgets/image/scan_detail_preview_image.dart';
import 'package:bitirme_mobile/core/widgets/image/scan_image_viewer_dialog.dart';
import 'package:bitirme_mobile/core/widgets/image/scan_thumbnail_image.dart';
import 'package:bitirme_mobile/features/history/provider/history_firestore_provider.dart';
import 'package:bitirme_mobile/l10n/app_localizations.dart';
import 'package:bitirme_mobile/models/plant_scan_model.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

/// Geçmiş taramalar listesi.
class HistoryView extends ConsumerStatefulWidget {
  const HistoryView({super.key});

  @override
  ConsumerState<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends ConsumerState<HistoryView> with ScaffoldMessageMixin {
  bool _downloadingPdf = false;

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(historyFirestoreProvider);
    final String loc = Localizations.localeOf(context).languageCode;
    final DateFormat fmt = DateFormat.yMMMd(loc);
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;
    final TextTheme tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: context.palSurface,
      appBar: appBarWithConditionalBack(
        context: context,
        title: Text(context.l10n.historyTitle),
        actions: <Widget>[
          historyAsync.maybeWhen(
            data: (items) => IconButton(
              tooltip: context.l10n.search,
              onPressed: items.isEmpty
                  ? null
                  : () => showSearch(
                      context: context,
                      delegate: _ScanSearchDelegate(
                        items,
                        context,
                        fmt,
                      ),
                    ),
              icon: const Icon(Icons.search_rounded),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => _buildEmptyView(context, tt, pad),
        data: (items) => items.isEmpty
            ? _buildEmptyView(context, tt, pad)
            : _buildGroupedListView(context, items, tt, pad, fmt, ref),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context, TextTheme tt, double pad) {
    return ListView(
      padding: EdgeInsets.fromLTRB(
        pad,
        pad,
        pad,
        WidgetSizesEnum.bottomNavHeight.value,
      ),
      children: <Widget>[
        Text(
          context.l10n.historyHeadline,
          style: tt.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: context.palOnSurface,
            letterSpacing: -0.4,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.divider.value * 8),
        Text(
          context.l10n.historySubtitle,
          style: tt.bodyLarge?.copyWith(
            color: context.palMuted,
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.25),
        SoftElevationCard(
          onTap: null,
          padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: WidgetSizesEnum.cardRadius.value * 2.1,
                    height: WidgetSizesEnum.cardRadius.value * 2.1,
                    decoration: BoxDecoration(
                      color: context.palPrimarySoftBg,
                      borderRadius: BorderRadius.circular(
                        WidgetSizesEnum.chipRadius.value,
                      ),
                    ),
                    child: Icon(
                      Icons.history_rounded,
                      color: context.palPrimary,
                    ),
                  ),
                  SizedBox(width: WidgetSizesEnum.cardRadius.value),
                  Expanded(
                    child: Text(
                      context.l10n.historyEmpty,
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: context.palOnSurface,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value),
              Text(
                context.l10n.homeEmptySubtitle,
                style: tt.bodyMedium?.copyWith(
                  color: context.palMuted,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value),
              AppPrimaryButton(
                label: context.l10n.homeStartScan,
                onPressed: () => context.push(AppPaths.scan),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGroupedListView(
    BuildContext context,
    List<PlantScanModel> items,
    TextTheme tt,
    double pad,
    DateFormat fmt,
    WidgetRef ref,
  ) {
    final Map<String, List<PlantScanModel>> grouped = groupScansBySpeciesLabel(items);
    final List<String> speciesKeys = sortedSpeciesLabelsFromGrouped(grouped, context);

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        pad,
        pad,
        pad,
        WidgetSizesEnum.bottomNavHeight.value,
      ),
      itemCount: speciesKeys.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.historyHeadline,
                style: tt.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: context.palOnSurface,
                ),
              ),
              SizedBox(height: WidgetSizesEnum.divider.value * 8),
              Text(
                context.l10n.historySubtitle,
                style: tt.bodyLarge?.copyWith(
                  color: context.palMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.25),
            ],
          );
        }

        final String speciesKey = speciesKeys[index - 1];
        final List<PlantScanModel> speciesScans = grouped[speciesKey]!;
        final String title = speciesScanGroupTitle(
          context: context,
          speciesLabel: speciesKey,
        );
        return Padding(
          padding: EdgeInsets.only(bottom: WidgetSizesEnum.cardRadius.value),
          child: SoftElevationCard(
            onTap: null,
            padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: context.palOnSurface,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.divider.value * 4),
                Text(
                  context.l10n.historyScanCount(speciesScans.length),
                  style: tt.labelMedium?.copyWith(
                    color: context.palPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.85),
                ...speciesScans.map((PlantScanModel s) {
                  final String dis = diseaseClassKeyToDisplay(
                    s.diseaseKey,
                    context.l10n,
                  );
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: WidgetSizesEnum.cardRadius.value * 0.55,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(
                        WidgetSizesEnum.chipRadius.value,
                      ),
                      onTap: () => _openActions(context, s),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: WidgetSizesEnum.divider.value * 6,
                          horizontal: WidgetSizesEnum.divider.value * 4,
                        ),
                        child: Row(
                          children: <Widget>[
                            ScanThumbnailImage(
                              imageUrl: s.imageUrl,
                              size: WidgetSizesEnum.cardRadius.value * 1.75,
                            ),
                            SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.75),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    dis,
                                    style: tt.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: context.palOnSurface,
                                    ),
                                  ),
                                  Text(
                                    fmt.format(s.createdAt),
                                    style: tt.bodySmall?.copyWith(
                                      color: context.palMuted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: context.palMuted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openActions(
    BuildContext context,
    PlantScanModel e,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (BuildContext ctx) {
        final double pad = WidgetSizesEnum.cardRadius.value * 1.15;
        final double maxSheetHeight =
            MediaQuery.sizeOf(ctx).height * SheetSizesEnum.modalMaxHeightFraction.value;
        final String diseaseLine = diseaseClassKeyToDisplay(
          e.diseaseKey,
          context.l10n,
        );
        final String title = speciesScanGroupTitle(
          context: context,
          speciesLabel: e.speciesLabel,
        );

        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxSheetHeight),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(pad, pad, pad, pad),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (e.imageUrl != null && e.imageUrl!.isNotEmpty)
                    ScanDetailPreviewImage(
                    imageUrl: e.imageUrl!,
                    onTap: () => showScanImageViewerDialog(
                      context: ctx,
                      imageUrl: e.imageUrl,
                      caption: title,
                    ),
                  ),
                if (e.imageUrl != null && e.imageUrl!.isNotEmpty)
                  SizedBox(height: WidgetSizesEnum.cardRadius.value),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: TextSizesEnum.subtitle.value,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.divider.value * 8),
                Text(
                  diseaseLine,
                  style: TextStyle(
                    color: context.palMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value),
                SoftElevationCard(
                  onTap: () {
                    Navigator.of(ctx).pop();
                    context.push(
                      '${AppPaths.speciesDetail}/${Uri.encodeComponent(e.speciesLabel)}?confidence=${e.speciesConfidence}',
                    );
                  },
                  padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.spa_rounded, color: context.palPrimary),
                      SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.75),
                      Expanded(child: Text(context.l10n.scanSpeciesTitle)),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: context.palMuted,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.65),
                SoftElevationCard(
                  onTap: () {
                    Navigator.of(ctx).pop();
                    context.push(
                      '${AppPaths.diseaseDetail}/${Uri.encodeComponent(e.diseaseKey)}?confidence=${e.diseaseConfidence}',
                    );
                  },
                  padding: EdgeInsets.all(
                    WidgetSizesEnum.cardRadius.value * 0.9,
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.healing_rounded, color: context.palAccent),
                      SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.75),
                      Expanded(child: Text(context.l10n.scanDiseaseTitle)),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: context.palMuted,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.65),
                SoftElevationCard(
                  onTap: _downloadingPdf
                      ? null
                      : () async {
                          Navigator.of(ctx).pop();
                          await _downloadPdf(e);
                        },
                  padding: EdgeInsets.all(
                    WidgetSizesEnum.cardRadius.value * 0.9,
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.download_rounded,
                        color: context.palPrimary,
                      ),
                      SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.75),
                      Expanded(
                        child: Text(
                          _downloadingPdf
                              ? context.l10n.loading
                              : context.l10n.scanDownloadPdfCta,
                        ),
                      ),
                      if (_downloadingPdf)
                        SizedBox(
                          width: IconSizesEnum.small.value,
                          height: IconSizesEnum.small.value,
                          child: CircularProgressIndicator(
                            strokeWidth: WidgetSizesEnum.divider.value * 2,
                          ),
                        )
                      else
                        Icon(
                          Icons.chevron_right_rounded,
                          color: context.palMuted,
                        ),
                    ],
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.65),
                SoftElevationCard(
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    final PdfReportService pdf = sl<PdfReportService>();
                    final Uint8List bytes = await pdf.buildScanReportPdf(
                      record: e,
                      l10n: context.l10n,
                    );
                    await Printing.sharePdf(
                      bytes: bytes,
                      filename: 'phytoguard_report.pdf',
                    );
                  },
                  padding: EdgeInsets.all(
                    WidgetSizesEnum.cardRadius.value * 0.9,
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.picture_as_pdf_rounded,
                        color: context.palPrimary,
                      ),
                      SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.75),
                      Expanded(child: Text(context.l10n.scanExportPdfCta)),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: context.palMuted,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.65),
                OutlinedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(context.l10n.cancel),
                ),
              ],
            ),
          ),
          ),
        );
      },
    );
  }

  Future<void> _downloadPdf(PlantScanModel record) async {
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
      sl<AppLogger>().e('history_pdf_download', e, st);
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
}

class _ScanSearchDelegate extends SearchDelegate<PlantScanModel?> {
  _ScanSearchDelegate(
    this.allItems,
    this.context,
    this.fmt,
  );
  final List<PlantScanModel> allItems;
  final BuildContext context;
  final DateFormat fmt;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults();

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults();

  Widget _buildSearchResults() {
    final results = allItems.where((PlantScanModel element) {
      final String species = speciesClassDisplayForRaw(
        context,
        element.speciesLabel,
      ).toLowerCase();
      final String disease = diseaseClassKeyToDisplay(
        element.diseaseKey,
        context.l10n,
      ).toLowerCase();
      final String q = query.toLowerCase();
      return species.contains(q) || disease.contains(q);
    }).toList();

    if (results.isEmpty) {
      return Center(child: Text(context.l10n.emptyState));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final e = results[index];
        return ListTile(
          leading: ScanThumbnailImage(imageUrl: e.imageUrl),
          title: Text(
            speciesScanGroupTitle(context: context, speciesLabel: e.speciesLabel),
          ),
          subtitle: Text(
            '${diseaseClassKeyToDisplay(e.diseaseKey, context.l10n)} · ${fmt.format(e.createdAt)}',
          ),
          onTap: () => close(context, e),
        );
      },
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
      child: Ink(
        padding: EdgeInsets.symmetric(
          horizontal: WidgetSizesEnum.cardRadius.value * 0.65,
          vertical: WidgetSizesEnum.divider.value * 10,
        ),
        decoration: BoxDecoration(
          color: context.palPrimarySoftBg,
          borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
          border: Border.all(color: context.palOutline.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: IconSizesEnum.small.value,
              color: context.palPrimary,
            ),
            SizedBox(width: WidgetSizesEnum.divider.value * 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: context.palOnSurface,
                fontSize: TextSizesEnum.caption.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
