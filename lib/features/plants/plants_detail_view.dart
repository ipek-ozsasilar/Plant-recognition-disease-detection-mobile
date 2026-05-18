import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/locale/species_class_display.dart';
import 'package:bitirme_mobile/core/services/disease_label_display.dart';
import 'package:bitirme_mobile/core/services/ml_metadata_loader.dart';
import 'package:bitirme_mobile/core/services/scan_identification_filter.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/features/health_progress/sub_view/disease_progress_chart.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/models/plant_scan_model.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:bitirme_mobile/core/services/plant_scans_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Bitki detay: chart + son taramalar (timeline).
class PlantsDetailView extends ConsumerStatefulWidget {
  const PlantsDetailView({required this.plantId, super.key});

  final String plantId;

  @override
  ConsumerState<PlantsDetailView> createState() => _PlantsDetailViewState();
}

class _PlantsDetailViewState extends ConsumerState<PlantsDetailView> {
  bool _loading = true;
  List<PlantScanModel> _items = <PlantScanModel>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final String? uid = ref.read(authProvider).uid;
    if (uid == null || uid.isEmpty) {
      setState(() => _loading = false);
      return;
    }
    final PlantScansFirestoreService svc = sl<PlantScansFirestoreService>();
    final List<PlantScanModel> items = await svc.listScans(
      ownerUid: uid,
      plantId: widget.plantId,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;
    final String loc = Localizations.localeOf(context).languageCode;
    final DateFormat fmt = DateFormat.yMMMd(loc);
    final TextTheme tt = Theme.of(context).textTheme;

    final Set<String> knownDiseases = knownDiseaseKeysFromList(
      sl<MlMetadataLoader>().diseaseClassKeys,
    );
    final List<PlantScanModel> filteredItems = _items
        .where(
          (PlantScanModel e) =>
              isScanFullyIdentified(e, knownDiseaseKeys: knownDiseases),
        )
        .toList();

    final bool hasFilteredData = filteredItems.isNotEmpty;
    final int lastScore = hasFilteredData ? filteredItems.first.healthScore : 0;
    final int avgScore = hasFilteredData
        ? (filteredItems.fold<int>(
                    0,
                    (int sum, PlantScanModel e) => sum + e.healthScore,
                  ) /
                  filteredItems.length)
              .round()
        : 0;

    return Scaffold(
      backgroundColor: context.palSurface,
      appBar: AppBar(
        title: Text(context.l10n.myPlantsDetailTitle),
        actions: <Widget>[
          IconButton(
            tooltip: context.l10n.search,
            onPressed: null,
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.fromLTRB(
                pad,
                pad,
                pad,
                WidgetSizesEnum.bottomNavHeight.value,
              ),
              children: <Widget>[
                Text(
                  context.l10n.myPlantsDetailHeadline,
                  style: tt.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: context.palOnSurface,
                    letterSpacing: -0.4,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.divider.value * 8),
                Text(
                  context.l10n.myPlantsDetailSubtitle,
                  style: tt.bodyLarge?.copyWith(
                    color: context.palMuted,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.15),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: SoftElevationCard(
                        onTap: null,
                        padding: EdgeInsets.all(
                          WidgetSizesEnum.cardRadius.value * 1.05,
                        ),
                        child: _StatPill(
                          icon: Icons.favorite_rounded,
                          iconColor: context.palPrimary,
                          label: context.l10n.myPlantsLastScore,
                          value: hasFilteredData
                              ? '$lastScore'
                              : context.l10n.placeholderDash,
                        ),
                      ),
                    ),
                    SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.85),
                    Expanded(
                      child: SoftElevationCard(
                        onTap: null,
                        padding: EdgeInsets.all(
                          WidgetSizesEnum.cardRadius.value * 1.05,
                        ),
                        child: _StatPill(
                          icon: Icons.insights_rounded,
                          iconColor: context.palAccent,
                          label: context.l10n.myPlantsAvgScore,
                          value: hasFilteredData
                              ? '$avgScore'
                              : context.l10n.placeholderDash,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value),
                SoftElevationCard(
                  onTap: null,
                  padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value),
                  child: SizedBox(
                    height: WidgetSizesEnum.homeHeaderHeight.value * 0.9,
                    child: !hasFilteredData
                        ? Center(
                            child: Text(
                              context.l10n.myPlantsNoScans,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: context.palMuted,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        : DiseaseProgressChart(
                            scans: filteredItems,
                            primary: context.palPrimary,
                            outline: context.palOutline,
                            muted: context.palMuted,
                          ),
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.85),
                Text(
                  context.l10n.myPlantsTimelineTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: context.palOnSurface,
                    fontSize: TextSizesEnum.subtitle.value,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.65),
                if (!hasFilteredData)
                  SoftElevationCard(
                    onTap: null,
                    padding: EdgeInsets.all(
                      WidgetSizesEnum.cardRadius.value * 1.05,
                    ),
                    child: Row(
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
                            Icons.timeline_rounded,
                            color: context.palPrimary,
                          ),
                        ),
                        SizedBox(width: WidgetSizesEnum.cardRadius.value),
                        Expanded(
                          child: Text(
                            context.l10n.myPlantsTimelineEmpty,
                            style: tt.bodyMedium?.copyWith(
                              color: context.palMuted,
                              height: 1.35,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...filteredItems.map((PlantScanModel e) {
                    final String disease = diseaseClassKeyToDisplay(
                      e.diseaseKey,
                      context.l10n,
                    );
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: WidgetSizesEnum.cardRadius.value * 0.75,
                      ),
                      child: SoftElevationCard(
                        onTap: null,
                        padding: EdgeInsets.all(
                          WidgetSizesEnum.cardRadius.value * 0.95,
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: WidgetSizesEnum.cardRadius.value * 2.1,
                              height: WidgetSizesEnum.cardRadius.value * 2.1,
                              decoration: BoxDecoration(
                                color: context.palPrimary.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(
                                  WidgetSizesEnum.chipRadius.value,
                                ),
                              ),
                              child: e.imageUrl == null || e.imageUrl!.isEmpty
                                  ? Icon(
                                      Icons.analytics_rounded,
                                      color: context.palPrimary,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        WidgetSizesEnum.chipRadius.value,
                                      ),
                                      child: Image.network(
                                        e.imageUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Icon(
                                          Icons.analytics_rounded,
                                          color: context.palPrimary,
                                        ),
                                      ),
                                    ),
                            ),
                            SizedBox(width: WidgetSizesEnum.cardRadius.value),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    fmt.format(e.createdAt),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: context.palOnSurface,
                                    ),
                                  ),
                                  SizedBox(
                                    height: WidgetSizesEnum.divider.value * 6,
                                  ),
                                  Text(
                                    speciesClassDisplayForRaw(
                                      context,
                                      e.speciesLabel,
                                    ),
                                    style: TextStyle(
                                      color: context.palMuted,
                                      fontSize: TextSizesEnum.caption.value,
                                    ),
                                  ),
                                  SizedBox(
                                    height: WidgetSizesEnum.divider.value * 4,
                                  ),
                                  Text(
                                    '$disease • ${context.l10n.myPlantsHealthScoreLabel} ${e.healthScore}',
                                    style: TextStyle(color: context.palMuted),
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
                    );
                  }),
              ],
            ),
    );
  }

}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(WidgetSizesEnum.divider.value * 10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(
              WidgetSizesEnum.chipRadius.value,
            ),
          ),
          child: Icon(icon, color: iconColor, size: IconSizesEnum.large.value),
        ),
        SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.85),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                value,
                style: tt.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: context.palOnSurface,
                  letterSpacing: -0.4,
                ),
              ),
              SizedBox(height: WidgetSizesEnum.divider.value * 4),
              Text(
                label,
                style: tt.labelMedium?.copyWith(
                  color: context.palMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
