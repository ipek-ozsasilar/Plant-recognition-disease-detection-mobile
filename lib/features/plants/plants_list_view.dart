import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/locale/species_class_display.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/appbar/conditional_back_leading.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/features/plants/provider/plants_provider.dart';
import 'package:bitirme_mobile/features/plants/provider/plants_state.dart';
import 'package:bitirme_mobile/models/plant_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Kullanıcının bitki koleksiyonu (liste).
class PlantsListView extends ConsumerStatefulWidget {
  const PlantsListView({super.key});

  @override
  ConsumerState<PlantsListView> createState() => _PlantsListViewState();
}

class _PlantsListViewState extends ConsumerState<PlantsListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(plantsProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final PlantsState state = ref.watch(plantsProvider);
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;
    final TextTheme tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: context.palSurface,
      appBar: appBarWithConditionalBack(
        context: context,
        title: Text(context.l10n.myPlantsTitle),
        actions: <Widget>[
          IconButton(
            onPressed: () => context.push('${AppPaths.myPlants}/add'),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.fromLTRB(pad, pad, pad, WidgetSizesEnum.bottomNavHeight.value),
              children: <Widget>[
                Text(
                  context.l10n.myPlantsHeadline,
                  style: tt.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: context.palOnSurface,
                    letterSpacing: -0.4,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.divider.value * 8),
                Text(
                  context.l10n.myPlantsSubtitle,
                  style: tt.bodyLarge?.copyWith(
                    color: context.palMuted,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.25),
                SoftElevationCard(
                  onTap: () => context.push('${AppPaths.myPlants}/add'),
                  padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.05),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: WidgetSizesEnum.cardRadius.value * 2.15,
                        height: WidgetSizesEnum.cardRadius.value * 2.15,
                        decoration: BoxDecoration(
                          color: context.palPrimarySoftBg,
                          borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
                        ),
                        child: Icon(Icons.add_rounded, color: context.palPrimary),
                      ),
                      SizedBox(width: WidgetSizesEnum.cardRadius.value),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              context.l10n.myPlantsAddTitle,
                              style: tt.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: context.palOnSurface,
                              ),
                            ),
                            SizedBox(height: WidgetSizesEnum.divider.value * 6),
                            Text(
                              context.l10n.myPlantsEmpty,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: tt.bodySmall?.copyWith(
                                color: context.palMuted,
                                height: 1.35,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: context.palMuted),
                    ],
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value),
                if (state.items.isEmpty)
                  SoftElevationCard(
                    onTap: null,
                    padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          context.l10n.emptyState,
                          style: tt.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: context.palOnSurface,
                          ),
                        ),
                        SizedBox(height: WidgetSizesEnum.divider.value * 8),
                        Text(
                          context.l10n.myPlantsEmpty,
                          style: tt.bodyMedium?.copyWith(
                            color: context.palMuted,
                            height: 1.35,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...List<Widget>.generate(state.items.length, (int index) {
                    final PlantModel p = state.items[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == state.items.length - 1
                            ? 0
                            : WidgetSizesEnum.cardRadius.value * 0.85,
                      ),
                      child: SoftElevationCard(
                        onTap: () => context.push('${AppPaths.myPlants}/${p.id}'),
                        padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: WidgetSizesEnum.cardRadius.value * 2.2,
                              height: WidgetSizesEnum.cardRadius.value * 2.2,
                              decoration: BoxDecoration(
                                color: context.palPrimary.withValues(alpha: 0.12),
                                borderRadius:
                                    BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
                              ),
                              child: p.photoUrl == null || p.photoUrl!.isEmpty
                                  ? Icon(Icons.local_florist_rounded, color: context.palPrimary)
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        WidgetSizesEnum.chipRadius.value,
                                      ),
                                      child: Image.network(
                                        p.photoUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Icon(
                                          Icons.local_florist_rounded,
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
                                    p.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: context.palOnSurface,
                                      fontSize: TextSizesEnum.subtitle.value,
                                    ),
                                  ),
                                  SizedBox(height: WidgetSizesEnum.divider.value * 6),
                                  Text(
                                    speciesClassDisplayForRaw(context, p.speciesLabel),
                                    style: TextStyle(
                                      color: context.palMuted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded, color: context.palMuted),
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

