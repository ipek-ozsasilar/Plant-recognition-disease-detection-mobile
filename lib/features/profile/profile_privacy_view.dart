import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/core/services/firestore_setup_service.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/features/profile/sub_view/profile_settings_tile.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Gizlilik, şifre ve veri silme.
class ProfilePrivacyView extends ConsumerWidget {
  const ProfilePrivacyView({super.key});

  Future<void> _confirmDeleteData(BuildContext context, WidgetRef ref) async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text(ctx.l10n.profileDeleteDataTitle),
        content: Text(ctx.l10n.profileDeleteDataBody),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(ctx.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              ctx.l10n.profileDeleteDataConfirm,
              style: TextStyle(color: ColorName.error, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) {
      return;
    }
    final String? uid = ref.read(authProvider).uid;
    if (uid == null) {
      return;
    }
    try {
      await sl<FirestoreSetupService>().deleteAllUserData(uid: uid);
      await ref.read(authProvider.notifier).logout();
      if (context.mounted) {
        context.go(AppPaths.login);
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.profileDeleteDataError)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme tt = Theme.of(context).textTheme;
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;
    final String email = ref.watch(authProvider).email ?? '';

    return Scaffold(
      backgroundColor: context.palSurface,
      appBar: AppBar(
        title: Text(context.l10n.profilePrivacySecurity),
        leading: const BackButton(),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          pad,
          pad,
          pad,
          WidgetSizesEnum.bottomNavHeight.value,
        ),
        children: <Widget>[
          Text(
            context.l10n.profilePrivacyIntro,
            style: tt.bodyLarge?.copyWith(
              color: context.palMuted,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          SoftElevationCard(
            onTap: null,
            padding: EdgeInsets.zero,
            child: Column(
              children: <Widget>[
                ProfileSettingsTile(
                  icon: Icons.lock_reset_rounded,
                  title: context.l10n.profileChangePassword,
                  onTap: () => context.push(AppPaths.forgotPassword),
                ),
                Divider(
                  height: WidgetSizesEnum.divider.value,
                  color: context.palOutline.withValues(alpha: 0.35),
                ),
                ProfileSettingsTile(
                  icon: Icons.tune_rounded,
                  title: context.l10n.settingsTitle,
                  onTap: () => context.push(AppPaths.settings),
                ),
              ],
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          SoftElevationCard(
            onTap: null,
            padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value),
            child: Text(
              context.l10n.profilePrivacyDataNote(email),
              style: tt.bodyMedium?.copyWith(
                color: context.palMuted,
                height: 1.45,
              ),
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          SoftElevationCard(
            onTap: () => _confirmDeleteData(context, ref),
            padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value),
            child: Row(
              children: <Widget>[
                Icon(Icons.delete_outline_rounded, color: ColorName.error),
                SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.75),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        context.l10n.profileDeleteDataTitle,
                        style: tt.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: ColorName.error,
                        ),
                      ),
                      SizedBox(height: WidgetSizesEnum.divider.value * 4),
                      Text(
                        context.l10n.profileDeleteDataHint,
                        style: tt.bodySmall?.copyWith(color: context.palMuted),
                      ),
                    ],
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
