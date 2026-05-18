import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/mixins/scaffold_message_mixin.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/button/app_primary_button.dart';
import 'package:bitirme_mobile/core/widgets/input/app_text_field.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/features/profile/provider/user_profile_provider.dart';
import 'package:bitirme_mobile/models/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Ad, telefon ve kısa bio düzenleme.
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
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  bool _loading = false;
  bool _hydrated = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _bio.dispose();
    super.dispose();
  }

  void _hydrateFromProfile(UserProfileModel? profile, AuthState auth) {
    if (_hydrated) {
      return;
    }
    _name.text = profile?.displayName ?? auth.displayName ?? '';
    _phone.text = profile?.phone ?? '';
    _bio.text = profile?.bio ?? '';
    _hydrated = true;
  }

  Future<void> _save() async {
    if (!(_form.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _loading = true);
    final String? error = await ref.read(userProfileProvider.notifier).updatePersonalInfo(
          displayName: _name.text,
          phone: _phone.text,
          bio: _bio.text,
        );
    if (!mounted) {
      return;
    }
    setState(() => _loading = false);
    if (error != null) {
      showAppSnackBar(context, message: context.l10n.profileSaveError, isError: true);
      return;
    }
    showAppSnackBar(context, message: context.l10n.profileSaveSuccess, isError: false);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final AuthState auth = ref.watch(authProvider);
    final AsyncValue<UserProfileModel?> profileAsync = ref.watch(userProfileProvider);
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;

    if (!_hydrated && !profileAsync.isLoading) {
      _hydrateFromProfile(profileAsync.valueOrNull, auth);
    }

    return Scaffold(
      backgroundColor: context.palSurface,
      appBar: AppBar(
        title: Text(context.l10n.profilePersonalInfo),
        leading: const BackButton(),
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                context.l10n.profileEmailLabel,
                                style: TextStyle(
                                  fontSize: TextSizesEnum.caption.value,
                                  fontWeight: FontWeight.w700,
                                  color: context.palMuted,
                                ),
                              ),
                              SizedBox(height: WidgetSizesEnum.divider.value * 4),
                              Text(
                                auth.email ?? context.l10n.placeholderDash,
                                style: TextStyle(
                                  fontSize: TextSizesEnum.body.value,
                                  fontWeight: FontWeight.w600,
                                  color: context.palOnSurface,
                                ),
                              ),
                            ],
                          ),
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
