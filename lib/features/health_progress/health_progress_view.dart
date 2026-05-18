import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/locale/species_class_display.dart';
import 'package:bitirme_mobile/core/services/ml_metadata_loader.dart';
import 'package:bitirme_mobile/core/services/scan_identification_filter.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/appbar/conditional_back_leading.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/features/health_progress/provider/health_progress_provider.dart';
import 'package:bitirme_mobile/features/health_progress/sub_view/disease_progress_chart.dart';
import 'package:bitirme_mobile/features/health_progress/view_model/health_progress_view_model.dart';
import 'package:bitirme_mobile/features/history/provider/history_firestore_provider.dart';
import 'package:bitirme_mobile/features/plants/provider/plants_provider.dart';
import 'package:bitirme_mobile/models/plant_model.dart';
import 'package:bitirme_mobile/models/plant_scan_model.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Geçmiş taramalardan fiziksel bitki bazında hastalık trendi.
class HealthProgressView extends ConsumerWidget {
  const HealthProgressView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HealthProgressViewModel vm = HealthProgressViewModel(ref: ref);
    final TextTheme tt = Theme.of(context).textTheme;
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;
    final String? selected = ref.watch(healthProgressProvider).selectedPlantId;
    final AsyncValue<List<PlantScanModel>> historyAsync =
        ref.watch(historyFirestoreProvider);
    ref.watch(plantsProvider);

    final Set<String> knownDiseases = knownDiseaseKeysFromList(
      sl<MlMetadataLoader>().diseaseClassKeys,
    );

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
          plantOptions: <_PlantOption>[],
          chartScans: <PlantScanModel>[],
        ),
        data: (List<PlantScanModel> all) {
          final List<PlantScanModel> identified = all
              .where(
                (PlantScanModel s) =>
                    isScanFullyIdentified(s, knownDiseaseKeys: knownDiseases) &&
                    s.plantId.isNotEmpty,
              )
              .toList();

          final Map<String, PlantModel> plantsById = <String, PlantModel>{
            for (final PlantModel p in ref.read(plantsProvider).items) p.id: p,
          };

          final Map<String, _PlantOption> optionByPlantId = <String, _PlantOption>{};
          for (final PlantScanModel scan in identified) {
            final PlantModel? plant = plantsById[scan.plantId];
            final String title = plant?.name ??
                speciesClassDisplayForRaw(context, scan.speciesLabel);
            final String? subtitle = plant != null
                ? speciesClassDisplayForRaw(context, scan.speciesLabel)
                : null;
            optionByPlantId.putIfAbsent(
              scan.plantId,
              () => _PlantOption(
                plantId: scan.plantId,
                title: title,
                subtitle: subtitle,
              ),
            );
          }

          final List<_PlantOption> options = optionByPlantId.values.toList()
            ..sort(
              (_PlantOption a, _PlantOption b) => a.title.compareTo(b.title),
            );

          final String? effectiveSelected =
              options.any((_PlantOption o) => o.plantId == selected)
                  ? selected
                  : (options.isNotEmpty ? options.first.plantId : null);

          if (effectiveSelected != selected && effectiveSelected != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              vm.selectPlant(effectiveSelected);
            });
          }

          final List<PlantScanModel> chartScans = effectiveSelected == null
              ? <PlantScanModel>[]
              : identified
                  .where((PlantScanModel s) => s.plantId == effectiveSelected)
                  .toList();

          return _buildScroll(
            context,
            tt,
            pad,
            effectiveSelected,
            vm,
            plantOptions: options,
            chartScans: chartScans,
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
    required List<_PlantOption> plantOptions,
    required List<PlantScanModel> chartScans,
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
                context.l10n.healthProgressPickPlantTitle,
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
              if (plantOptions.isEmpty)
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
                  hint: Text(context.l10n.healthProgressSelectPlant),
                  items: plantOptions
                      .map(
                        (_PlantOption o) => DropdownMenuItem<String>(
                          value: o.plantId,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(o.title),
                              if (o.subtitle != null)
                                Text(
                                  o.subtitle!,
                                  style: tt.bodySmall?.copyWith(
                                    color: context.palMuted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: vm.selectPlant,
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
                context.l10n.healthProgressChartTitle,
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: context.palOnSurface,
                ),
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.85),
              SizedBox(
                height: WidgetSizesEnum.homeHeaderHeight.value * 1.15,
                child: DiseaseProgressChart(
                  scans: chartScans,
                  primary: context.palPrimary,
                  accent: context.palAccent,
                  outline: context.palOutline,
                  muted: context.palMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

final class _PlantOption {
  const _PlantOption({
    required this.plantId,
    required this.title,
    required this.subtitle,
  });

  final String plantId;
  final String title;
  final String? subtitle;
}
