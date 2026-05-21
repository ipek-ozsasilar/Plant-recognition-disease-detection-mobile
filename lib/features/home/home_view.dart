import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/core/navigation/scan_flow_launcher.dart';
import 'package:bitirme_mobile/core/services/notification_service.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/features/history/provider/history_firestore_provider.dart';
import 'package:bitirme_mobile/features/home/sub_view/home_dashboard_header.dart';
import 'package:bitirme_mobile/features/home/sub_view/home_empty_state.dart';
import 'package:bitirme_mobile/features/home/sub_view/home_insight_banner.dart';
import 'package:bitirme_mobile/features/home/sub_view/home_quick_actions_row.dart';
import 'package:bitirme_mobile/features/home/sub_view/home_recent_strip.dart';
import 'package:bitirme_mobile/features/home/sub_view/home_scan_hero_card.dart';
import 'package:bitirme_mobile/models/plant_scan_model.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Ana sayfa panosu — modern kart ve degrade düzeni.
class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl<NotificationService>().ensureInitialPermissionPrompt();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthState auth = ref.watch(authProvider);
    final AsyncValue<List<PlantScanModel>> historyAsync = ref.watch(
      historyFirestoreProvider,
    );

    final String name = auth.displayName ?? context.l10n.homeGreeting;
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;

    return Scaffold(
      backgroundColor: context.palSurface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[HomeDashboardHeader(displayName: name)],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              pad,
              WidgetSizesEnum.cardRadius.value * 0.85,
              pad,
              pad,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                HomeQuickActionsRow(
                  onScan: () => launchScanFlow(context),
                  onHistory: () => context.go(AppPaths.history),
                  onGuide: () => context.push(AppPaths.guide),
                  onSettings: () => context.push(AppPaths.settings),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.35),
                HomeScanHeroCard(onTap: () => launchScanFlow(context)),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.35),
                HomeInsightBanner(),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.5),
                Text(
                  context.l10n.homeStatsTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: context.palOnSurface,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.85),
                historyAsync.when(
                  loading: () => const Center(child: LinearProgressIndicator()),
                  error: (err, stack) => Text(context.l10n.placeholderDash),
                  data: (history) {
                    final int totalScans = history.length;
                    final int totalSpecies = history
                        .map((e) => e.speciesLabel)
                        .toSet()
                        .length;

                    return Row(
                      children: <Widget>[
                        Expanded(
                          child: _HomeStatTile(
                            icon: Icons.analytics_rounded,
                            label: context.l10n.homeStatScans,
                            value: '$totalScans',
                            accent: context.palPrimary,
                          ),
                        ),
                        SizedBox(
                          width: WidgetSizesEnum.cardRadius.value * 0.85,
                        ),
                        Expanded(
                          child: _HomeStatTile(
                            icon: Icons.biotech_rounded,
                            label: context.l10n.homeStatSpecies,
                            value: '$totalSpecies',
                            accent: context.palAccent,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      context.l10n.homeRecent,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: context.palOnSurface,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go(AppPaths.history),
                      child: Text(context.l10n.homeSeeAll),
                    ),
                  ],
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.65),
                historyAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (err, stack) => const SizedBox.shrink(),
                  data: (history) => history.isEmpty
                      ? HomeEmptyState(
                          onStartScan: () => launchScanFlow(context),
                        )
                      : HomeRecentStrip(records: history.take(8).toList()),
                ),
                SizedBox(height: WidgetSizesEnum.bottomNavHeight.value),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeStatTile extends StatelessWidget {
  const _HomeStatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    return SoftElevationCard(
      onTap: null,
      padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.05),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(WidgetSizesEnum.divider.value * 10),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(
                WidgetSizesEnum.chipRadius.value,
              ),
            ),
            child: Icon(icon, color: accent, size: IconSizesEnum.large.value),
          ),
          SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.85),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  value,
                  style: tt.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: context.palOnSurface,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.divider.value * 4),
                Text(
                  label,
                  style: tt.labelMedium?.copyWith(
                    color: context.palMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
