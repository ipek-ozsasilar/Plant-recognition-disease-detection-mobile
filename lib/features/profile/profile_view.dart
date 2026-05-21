import 'dart:typed_data';

import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/mixins/scaffold_message_mixin.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/appbar/conditional_back_leading.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/features/profile/provider/user_profile_provider.dart';
import 'package:bitirme_mobile/features/profile/sub_view/profile_avatar.dart';
import 'package:bitirme_mobile/features/profile/sub_view/profile_settings_tile.dart';
import 'package:bitirme_mobile/features/profile/sub_view/profile_stat_pill.dart';
import 'package:bitirme_mobile/features/settings/home_stats_model.dart';
import 'package:bitirme_mobile/features/settings/home_stats_provider.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:bitirme_mobile/models/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

/// Kullanıcı profili — Firestore + profil fotoğrafı.
class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> with ScaffoldMessageMixin {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _localAvatarBytes;
  bool _uploadingAvatar = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(userProfileProvider.notifier).reload();
    });
  }

  Future<void> _pickProfilePhoto() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext ctx) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(ctx.l10n.profilePhotoGallery),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(ctx.l10n.profilePhotoCamera),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) {
      return;
    }
    try {
      final double maxPx = ImageSizesEnum.galleryPickMax.value;
      final XFile? file = await _picker.pickImage(
        source: source,
        imageQuality: 88,
        maxWidth: maxPx,
        maxHeight: maxPx,
      );
      if (file == null || !mounted) {
        return;
      }
      final Uint8List bytes = await file.readAsBytes();
      setState(() {
        _localAvatarBytes = bytes;
        _uploadingAvatar = true;
      });
      final String? error =
          await ref.read(userProfileProvider.notifier).updateProfilePhoto(bytes);
      if (!mounted) {
        return;
      }
      setState(() {
        _uploadingAvatar = false;
        if (error == null) {
          _localAvatarBytes = null;
        }
      });
      if (error != null) {
        showAppSnackBar(
          context,
          message: context.l10n.profilePhotoUploadError,
          isError: true,
        );
      } else {
        showAppSnackBar(
          context,
          message: context.l10n.profilePhotoUploadSuccess,
          isError: false,
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _uploadingAvatar = false);
        showAppSnackBar(
          context,
          message: context.l10n.profilePhotoUploadError,
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthState auth = ref.watch(authProvider);
    final AsyncValue<UserProfileModel?> profileAsync = ref.watch(userProfileProvider);
    final UserProfileModel? profile = profileAsync.valueOrNull;
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;
    final TextTheme tt = Theme.of(context).textTheme;
    final AsyncValue<HomeStatsModel> statsAsync = ref.watch(homeStatsProvider);
    final int speciesCount = statsAsync.maybeWhen(
      data: (HomeStatsModel stats) => stats.uniqueSpeciesCount,
      orElse: () => 0,
    );
    final int diseaseCount = statsAsync.maybeWhen(
      data: (HomeStatsModel stats) => stats.uniqueDiseaseCount,
      orElse: () => 0,
    );
    final double topInset = MediaQuery.paddingOf(context).top + kToolbarHeight;

    final String displayName =
        profile?.displayName ?? auth.displayName ?? context.l10n.placeholderDash;
    final String email = profile?.email ?? auth.email ?? context.l10n.placeholderDash;

    return Scaffold(
      backgroundColor: context.palSurface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: const ConditionalBackLeading(),
        automaticallyImplyLeading: false,
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
                  GestureDetector(
                    onTap: _uploadingAvatar ? null : _pickProfilePhoto,
                    child: ProfileAvatar(
                      profile: profile,
                      fallbackName: displayName,
                      localBytes: _localAvatarBytes,
                      uploading: _uploadingAvatar,
                    ),
                  ),
                  SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.65),
                  Text(
                    displayName,
                    textAlign: TextAlign.center,
                    style: tt.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: context.palOnSurface,
                      letterSpacing: -0.4,
                    ),
                  ),
                  SizedBox(height: WidgetSizesEnum.divider.value * 6),
                  Text(
                    email,
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
                    value: '$speciesCount',
                    label: context.l10n.profileSpeciesCount,
                    accent: context.palPrimary,
                    icon: Icons.eco_rounded,
                  ),
                ),
                SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.75),
                Expanded(
                  child: ProfileStatPill(
                    value: '$diseaseCount',
                    label: context.l10n.profileDiseaseCount,
                    accent: context.palAccent,
                    icon: Icons.biotech_rounded,
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
                    onTap: () => context.push(AppPaths.profilePersonalInfo),
                  ),
                  Divider(
                    height: WidgetSizesEnum.divider.value,
                    thickness: WidgetSizesEnum.divider.value,
                    color: context.palOutline.withValues(alpha: 0.35),
                  ),
                  ProfileSettingsTile(
                    icon: Icons.lock_outline_rounded,
                    title: context.l10n.profilePrivacySecurity,
                    onTap: () => context.push(AppPaths.profilePrivacy),
                  ),
                  Divider(
                    height: WidgetSizesEnum.divider.value,
                    thickness: WidgetSizesEnum.divider.value,
                    color: context.palOutline.withValues(alpha: 0.35),
                  ),
                  ProfileSettingsTile(
                    icon: Icons.settings_rounded,
                    title: context.l10n.settingsTitle,
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
                    onTap: () => context.push(AppPaths.guide),
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
