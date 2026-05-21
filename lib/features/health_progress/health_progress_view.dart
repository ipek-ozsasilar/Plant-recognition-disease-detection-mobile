import 'package:bitirme_mobile/core/enums/chart_window_enum.dart';
import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/services/ml_metadata_loader.dart';
import 'package:bitirme_mobile/core/services/plant_scan_display_helper.dart';
import 'package:bitirme_mobile/core/services/scan_identification_filter.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/appbar/conditional_back_leading.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/features/health_progress/provider/health_progress_provider.dart';
import 'package:bitirme_mobile/features/health_progress/provider/health_progress_state.dart';
import 'package:bitirme_mobile/features/health_progress/sub_view/disease_progress_chart.dart';
import 'package:bitirme_mobile/features/health_progress/sub_view/plant_scan_photo_timeline.dart';
import 'package:bitirme_mobile/features/health_progress/view_model/health_progress_view_model.dart';
import 'package:bitirme_mobile/features/history/provider/history_firestore_provider.dart';
import 'package:bitirme_mobile/models/plant_scan_model.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Geçmiş taramalardan bitki türü bazında hastalık trendi.
class HealthProgressView extends ConsumerStatefulWidget {
  const HealthProgressView({super.key});

  @override
  ConsumerState<HealthProgressView> createState() => _HealthProgressViewState();
}

class _HealthProgressViewState extends ConsumerState<HealthProgressView> {
  @override
  Widget build(BuildContext context) {
    final HealthProgressViewModel vm = HealthProgressViewModel(ref: ref);
    final TextTheme tt = Theme.of(context).textTheme;
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;
    final HealthProgressState progressState = ref.watch(healthProgressProvider);
    final String? selected = progressState.selectedSpeciesLabel;
    final ChartWindowEnum chartWindow = progressState.chartWindow;
    final AsyncValue<List<PlantScanModel>> historyAsync = ref.watch(
      historyFirestoreProvider,
    );

    final Set<String> knownDiseases = knownDiseaseKeysFromList(
      sl<MlMetadataLoader>().diseaseClassKeys,
    );
    final String loc = Localizations.localeOf(context).languageCode;
    final DateFormat dayFmt = DateFormat('d MMM', loc);

    return Scaffold(
      backgroundColor: context.palSurface,
      appBar: appBarWithConditionalBack(
        context: context,
        title: Text(context.l10n.healthProgressTitle),
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => _buildScroll(
          context,
          tt,
          pad,
          selected,
          vm,
          chartWindow: chartWindow,
          speciesOptions: <_SpeciesOption>[],
          chartScans: <PlantScanModel>[],
          dayFmt: dayFmt,
        ),
        data: (List<PlantScanModel> all) {
          final List<PlantScanModel> identified = all
              .where(
                (PlantScanModel s) =>
                    isScanFullyIdentified(s, knownDiseaseKeys: knownDiseases) &&
                    s.speciesLabel.trim().isNotEmpty,
              )
              .toList(growable: false);

          final Map<String, List<PlantScanModel>> grouped =
              groupScansBySpeciesLabel(identified);
          final List<String> speciesKeys = sortedSpeciesLabelsFromGrouped(
            grouped,
            context,
          );

          final List<_SpeciesOption> options = speciesKeys
              .map(
                (String speciesLabel) => _SpeciesOption(
                  speciesLabel: speciesLabel,
                  title: speciesScanGroupTitle(
                    context: context,
                    speciesLabel: speciesLabel,
                  ),
                ),
              )
              .toList(growable: false);

          final String? effectiveSelected =
              options.any((_SpeciesOption o) => o.speciesLabel == selected)
              ? selected
              : (options.isNotEmpty ? options.first.speciesLabel : null);

          if (effectiveSelected != selected && effectiveSelected != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              vm.selectSpecies(effectiveSelected);
            });
          }

          final List<PlantScanModel> chartScans = effectiveSelected == null
              ? <PlantScanModel>[]
              : grouped[effectiveSelected] ?? <PlantScanModel>[];

          return _buildScroll(
            context,
            tt,
            pad,
            effectiveSelected,
            vm,
            chartWindow: chartWindow,
            speciesOptions: options,
            chartScans: chartScans,
            dayFmt: dayFmt,
          );
        },
      ),
    );
  }

  Widget _buildScroll(
    BuildContext context,
    TextTheme tt,
    double pad,
    String? selected,
    HealthProgressViewModel vm, {
    required ChartWindowEnum chartWindow,
    required List<_SpeciesOption> speciesOptions,
    required List<PlantScanModel> chartScans,
    required DateFormat dayFmt,
  }) {
    return ListView(
      padding: EdgeInsets.fromLTRB(
        pad,
        pad,
        pad,
        WidgetSizesEnum.bottomNavHeight.value,
      ),
      children: <Widget>[
        Text(
          context.l10n.healthProgressHeadline,
          style: tt.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: context.palOnSurface,
            letterSpacing: -0.4,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.divider.value * 8),
        Text(
          context.l10n.healthProgressSubtitle,
          style: tt.bodyLarge?.copyWith(
            color: context.palMuted,
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.25),
        SoftElevationCard(
          onTap: null,
          padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                context.l10n.healthProgressPickSpeciesTitle,
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: context.palOnSurface,
                ),
              ),
              SizedBox(height: WidgetSizesEnum.divider.value * 10),
              Text(
                context.l10n.healthProgressHint,
                style: tt.bodySmall?.copyWith(
                  color: context.palMuted,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value),
              if (speciesOptions.isEmpty)
                Text(
                  context.l10n.healthProgressNoPlants,
                  style: tt.bodyMedium?.copyWith(
                    color: context.palMuted,
                    fontWeight: FontWeight.w600,
                  ),
                )
              else
                DropdownButtonFormField<String>(
                  value: selected,
                  hint: Text(context.l10n.healthProgressSelectSpecies),
                  items: speciesOptions
                      .map(
                        (_SpeciesOption o) => DropdownMenuItem<String>(
                          value: o.speciesLabel,
                          child: Text(o.title),
                        ),
                      )
                      .toList(),
                  onChanged: vm.selectSpecies,
                ),
            ],
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        SoftElevationCard(
          onTap: null,
          padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: WidgetSizesEnum.divider.value * 2,
                        right: WidgetSizesEnum.cardRadius.value * 0.5,
                      ),
                      child: Text(
                        context.l10n.healthProgressChartTitleDays(
                          chartWindow.days,
                        ),
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: context.palOnSurface,
                        ),
                      ),
                    ),
                  ),
                  SegmentedButton<ChartWindowEnum>(
                    segments: <ButtonSegment<ChartWindowEnum>>[
                      ButtonSegment<ChartWindowEnum>(
                        value: ChartWindowEnum.fourteen,
                        label: Text(context.l10n.healthProgressChartDays14),
                      ),
                      ButtonSegment<ChartWindowEnum>(
                        value: ChartWindowEnum.thirty,
                        label: Text(context.l10n.healthProgressChartDays30),
                      ),
                    ],
                    selected: <ChartWindowEnum>{chartWindow},
                    onSelectionChanged: (Set<ChartWindowEnum> value) {
                      if (value.isNotEmpty) {
                        vm.selectChartWindow(value.first);
                      }
                    },
                    style: SegmentedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.75),
              SizedBox(
                height: WidgetSizesEnum.homeHeaderHeight.value * 1.15,
                child: DiseaseProgressChart(
                  key: ValueKey<ChartWindowEnum>(chartWindow),
                  scans: chartScans,
                  chartWindow: chartWindow,
                  primary: context.palPrimary,
                  accent: context.palAccent,
                  outline: context.palOutline,
                  muted: context.palMuted,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: WidgetSizesEnum.cardRadius.value),
        SoftElevationCard(
          onTap: null,
          padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                context.l10n.healthProgressPhotoTimelineTitle,
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: context.palOnSurface,
                ),
              ),
              SizedBox(height: WidgetSizesEnum.divider.value * 8),
              Text(
                context.l10n.healthProgressPhotoTimelineHint,
                style: tt.bodySmall?.copyWith(
                  color: context.palMuted,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.85),
              PlantScanPhotoTimeline(scans: chartScans, dateFormat: dayFmt),
            ],
          ),
        ),
      ],
    );
  }
}

final class _SpeciesOption {
  const _SpeciesOption({required this.speciesLabel, required this.title});

  final String speciesLabel;
  final String title;
}
