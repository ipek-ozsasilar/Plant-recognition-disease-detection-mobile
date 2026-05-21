import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/mixins/scaffold_message_mixin.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/core/services/firestore_setup_service.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/appbar/conditional_back_leading.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/features/profile/provider/user_profile_provider.dart';
import 'package:bitirme_mobile/features/profile/sub_view/profile_settings_tile.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:bitirme_mobile/models/user_profile_model.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Gizlilik, şifre sıfırlama ve veri silme.
class ProfilePrivacyView extends ConsumerStatefulWidget {
  const ProfilePrivacyView({super.key});

  @override
  ConsumerState<ProfilePrivacyView> createState() => _ProfilePrivacyViewState();
}

class _ProfilePrivacyViewState extends ConsumerState<ProfilePrivacyView>
    with ScaffoldMessageMixin {
  bool _sendingPasswordReset = false;

  Future<void> _confirmDeleteData() async {
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
    if (ok != true || !mounted) {
      return;
    }
    final String? uid = ref.read(authProvider).uid;
    if (uid == null) {
      return;
    }
    try {
      await sl<FirestoreSetupService>().deleteAllUserData(uid: uid);
      await ref.read(authProvider.notifier).logout();
      if (mounted) {
        context.go(AppPaths.login);
      }
    } catch (_) {
      if (mounted) {
        showAppSnackBar(
          context,
          message: context.l10n.profileDeleteDataError,
          isError: true,
        );
      }
    }
  }

  Future<void> _requestPasswordReset(String email) async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text(ctx.l10n.profilePasswordResetConfirmTitle),
        content: Text(ctx.l10n.profilePasswordResetConfirmBody(email)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(ctx.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(ctx.l10n.forgotPasswordCta),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) {
      return;
    }

    setState(() => _sendingPasswordReset = true);
    final String? error = await ref
        .read(authProvider.notifier)
        .sendPasswordResetEmail(email, context.l10n);
    if (!mounted) {
      return;
    }
    setState(() => _sendingPasswordReset = false);

    if (error != null) {
      showAppSnackBar(context, message: error, isError: true);
    } else {
      showAppSnackBar(context, message: context.l10n.forgotPasswordSuccess);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;
    final String email = (ref.watch(authProvider).email ?? '').trim();
    final UserProfileModel? profile = ref.watch(userProfileProvider).valueOrNull;
    final bool isGoogleAccount = profile?.authProvider == 'google';

    return Scaffold(
      backgroundColor: context.palSurface,
      appBar: appBarWithConditionalBack(
        context: context,
        title: Text(context.l10n.profilePrivacySecurity),
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
                if (!isGoogleAccount && email.isNotEmpty)
                  ProfileSettingsTile(
                    icon: Icons.lock_reset_rounded,
                    title: context.l10n.profileChangePassword,
                    onTap: _sendingPasswordReset
                        ? () {}
                        : () => _requestPasswordReset(email),
                  ),
                if (isGoogleAccount)
                  Padding(
                    padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.lock_outline_rounded,
                          color: context.palMuted,
                          size: IconSizesEnum.medium.value,
                        ),
                        SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.75),
                        Expanded(
                          child: Text(
                            context.l10n.profilePasswordGoogleHint,
                            style: tt.bodyMedium?.copyWith(
                              color: context.palMuted,
                              height: 1.45,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (!isGoogleAccount && email.isNotEmpty) ...<Widget>[
            SizedBox(height: WidgetSizesEnum.divider.value * 8),
            if (_sendingPasswordReset)
              const Center(child: CircularProgressIndicator())
            else
              Text(
                context.l10n.profilePasswordResetHint(email),
                style: tt.bodySmall?.copyWith(
                  color: context.palMuted,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
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
            onTap: _confirmDeleteData,
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
