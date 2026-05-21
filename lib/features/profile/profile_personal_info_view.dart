import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/mixins/scaffold_message_mixin.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/appbar/conditional_back_leading.dart';
import 'package:bitirme_mobile/core/widgets/button/app_primary_button.dart';
import 'package:bitirme_mobile/core/widgets/input/app_text_field.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/features/profile/provider/user_profile_provider.dart';
import 'package:bitirme_mobile/models/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Ad, e-posta, telefon ve kısa bio düzenleme.
class ProfilePersonalInfoView extends ConsumerStatefulWidget {
  const ProfilePersonalInfoView({super.key});

  @override
  ConsumerState<ProfilePersonalInfoView> createState() =>
      _ProfilePersonalInfoViewState();
}

class _ProfilePersonalInfoViewState extends ConsumerState<ProfilePersonalInfoView>
    with ScaffoldMessageMixin {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  bool _loading = false;
  bool _hydrated = false;
  bool _isGoogleAccount = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _bio.dispose();
    super.dispose();
  }

  void _hydrateFromProfile(UserProfileModel? profile, AuthState auth) {
    if (_hydrated) {
      return;
    }
    _name.text = profile?.displayName ?? auth.displayName ?? '';
    _email.text = profile?.email ?? auth.email ?? '';
    _phone.text = profile?.phone ?? '';
    _bio.text = profile?.bio ?? '';
    _isGoogleAccount = profile?.authProvider == 'google';
    _hydrated = true;
  }

  Future<void> _save() async {
    if (!(_form.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _loading = true);
    final String emailBefore = (ref.read(authProvider).email ?? '').trim();
    final String? error = await ref.read(userProfileProvider.notifier).updatePersonalInfo(
          displayName: _name.text,
          email: _email.text,
          phone: _phone.text,
          bio: _bio.text,
          l10n: context.l10n,
        );
    if (!mounted) {
      return;
    }
    setState(() => _loading = false);
    if (error != null) {
      showAppSnackBar(context, message: error, isError: true);
      return;
    }
    showAppSnackBar(
      context,
      message: _email.text.trim() != emailBefore
          ? context.l10n.profileEmailVerificationSent
          : context.l10n.profileSaveSuccess,
      isError: false,
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final AuthState auth = ref.watch(authProvider);
    final AsyncValue<UserProfileModel?> profileAsync = ref.watch(userProfileProvider);
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;
    final TextTheme tt = Theme.of(context).textTheme;

    if (!_hydrated && !profileAsync.isLoading) {
      _hydrateFromProfile(profileAsync.valueOrNull, auth);
    }

    return Scaffold(
      backgroundColor: context.palSurface,
      appBar: appBarWithConditionalBack(
        context: context,
        title: Text(context.l10n.profilePersonalInfo),
      ),
      body: profileAsync.isLoading && !_hydrated
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
                  context.l10n.profilePersonalInfoIntro,
                  style: tt.bodyMedium?.copyWith(
                        color: context.palMuted,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value),
                SoftElevationCard(
                  onTap: null,
                  padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value),
                  child: Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        AppTextField(
                          controller: _name,
                          label: context.l10n.profileDisplayNameLabel,
                          validator: (String? v) {
                            if (v == null || v.trim().isEmpty) {
                              return context.l10n.profileDisplayNameRequired;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: WidgetSizesEnum.cardRadius.value),
                        AppTextField(
                          controller: _phone,
                          label: context.l10n.profilePhoneLabel,
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: WidgetSizesEnum.cardRadius.value),
                        AppTextField(
                          controller: _bio,
                          label: context.l10n.profileBioLabel,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.15),
                Text(
                  context.l10n.profileEmailChangeSection,
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: context.palOnSurface,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.75),
                SoftElevationCard(
                  onTap: null,
                  padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      AppTextField(
                        controller: _email,
                        label: context.l10n.profileEmailLabel,
                        keyboardType: TextInputType.emailAddress,
                        readOnly: _isGoogleAccount,
                        validator: (String? v) {
                          if (v == null || v.trim().isEmpty) {
                            return context.l10n.profileEmailRequired;
                          }
                          if (!v.contains('@') || !v.contains('.')) {
                            return context.l10n.errorAuthInvalidEmail;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: WidgetSizesEnum.divider.value * 8),
                      Text(
                        _isGoogleAccount
                            ? context.l10n.profileEmailGoogleHint
                            : context.l10n.profileEmailChangeHint,
                        style: TextStyle(
                          fontSize: TextSizesEnum.caption.value,
                          color: context.palMuted,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value),
                AppPrimaryButton(
                  label: context.l10n.save,
                  isLoading: _loading,
                  onPressed: _loading ? null : _save,
                ),
              ],
            ),
    );
  }
}
