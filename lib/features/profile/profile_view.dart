import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/features/plants/provider/plants_provider.dart';
import 'package:bitirme_mobile/features/profile/sub_view/profile_settings_tile.dart';
import 'package:bitirme_mobile/features/profile/sub_view/profile_stat_pill.dart';
import 'package:bitirme_mobile/features/history/provider/history_provider.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Kullanıcı profili (yerel oturum).
class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(plantsProvider.notifier).load();
      await ref.read(historyProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthState auth = ref.watch(authProvider);
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;
    final TextTheme tt = Theme.of(context).textTheme;
    final int plantsCount = ref.watch(plantsProvider).items.length;
    final int scansCount = ref.watch(historyProvider).length;
    final double topInset = MediaQuery.paddingOf(context).top + kToolbarHeight;

    return Scaffold(
      backgroundColor: context.palSurface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(context.l10n.profileTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              context.palPrimarySoftBg.withValues(alpha: 0.65),
              context.palSurface,
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            pad,
            topInset + (pad * 0.6),
            pad,
            WidgetSizesEnum.bottomNavHeight.value,
          ),
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: ImageSizesEnum.thumb.value * 1.6,
                    height: ImageSizesEnum.thumb.value * 1.6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.palSurfaceCard,
                      border: Border.all(
                        color: context.palOutline.withValues(alpha: 0.55),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: context.palPrimary.withValues(alpha: 0.18),
                          blurRadius: WidgetSizesEnum.cardShadowBlur.value,
                          offset: Offset(
                            0,
                            WidgetSizesEnum.cardShadowOffsetY.value * 0.85,
                          ),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person_rounded,
                        size: ImageSizesEnum.thumb.value * 0.85,
                        color: context.palPrimary,
                      ),
                    ),
                  ),
                  SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.85),
                  Text(
                    auth.displayName ?? context.l10n.placeholderDash,
                    textAlign: TextAlign.center,
                    style: tt.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: context.palOnSurface,
                      letterSpacing: -0.4,
                    ),
                  ),
                  SizedBox(height: WidgetSizesEnum.divider.value * 6),
                  Text(
                    auth.email ?? context.l10n.placeholderDash,
                    textAlign: TextAlign.center,
                    style: tt.bodyMedium?.copyWith(
                      color: context.palMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.15),
            Row(
              children: <Widget>[
                Expanded(
                  child: ProfileStatPill(
                    value: '$plantsCount',
                    label: context.l10n.profilePlantsTracked,
                    accent: context.palPrimary,
                  ),
                ),
                SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.75),
                Expanded(
                  child: ProfileStatPill(
                    value: '$scansCount',
                    label: context.l10n.profileScansDone,
                    accent: context.palAccent,
                  ),
                ),
              ],
            ),
            SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.25),
            SoftElevationCard(
              onTap: null,
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      WidgetSizesEnum.cardRadius.value,
                      WidgetSizesEnum.cardRadius.value,
                      WidgetSizesEnum.cardRadius.value,
                      WidgetSizesEnum.cardRadius.value * 0.5,
                    ),
                    child: Text(
                      context.l10n.profileAccountSettingsTitle,
                      style: tt.labelLarge?.copyWith(
                        color: context.palMuted,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  ProfileSettingsTile(
                    icon: Icons.person_outline_rounded,
                    title: context.l10n.profilePersonalInfo,
                    onTap: () => context.push(AppPaths.settings),
                  ),
                  Divider(
                    height: WidgetSizesEnum.divider.value,
                    thickness: WidgetSizesEnum.divider.value,
                    color: context.palOutline.withValues(alpha: 0.35),
                  ),
                  ProfileSettingsTile(
                    icon: Icons.notifications_none_rounded,
                    title: context.l10n.profileNotificationSettings,
                    onTap: () => context.push(AppPaths.settings),
                  ),
                  Divider(
                    height: WidgetSizesEnum.divider.value,
                    thickness: WidgetSizesEnum.divider.value,
                    color: context.palOutline.withValues(alpha: 0.35),
                  ),
                  ProfileSettingsTile(
                    icon: Icons.lock_outline_rounded,
                    title: context.l10n.profilePrivacySecurity,
                    onTap: () => context.push(AppPaths.settings),
                  ),
                  Divider(
                    height: WidgetSizesEnum.divider.value,
                    thickness: WidgetSizesEnum.divider.value,
                    color: context.palOutline.withValues(alpha: 0.35),
                  ),
                  ProfileSettingsTile(
                    icon: Icons.help_outline_rounded,
                    title: context.l10n.profileHelpCenter,
                    onTap: () => context.push(AppPaths.about),
                  ),
                ],
              ),
            ),
            SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.25),
            SoftElevationCard(
              onTap: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  context.go(AppPaths.login);
                }
              },
              padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.logout_rounded, color: ColorName.error),
                  SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.6),
                  Text(
                    context.l10n.logout,
                    style: tt.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: ColorName.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
