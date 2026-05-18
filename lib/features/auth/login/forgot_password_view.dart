import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/mixins/scaffold_message_mixin.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/button/app_primary_button.dart';
import 'package:bitirme_mobile/core/widgets/input/app_text_field.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/features/auth/sub_view/auth_gradient_hero.dart';
import 'package:bitirme_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Şifre sıfırlama ekranı — mevcut modern iskeletle tam uyumlu.
class ForgotPasswordView extends ConsumerStatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  ConsumerState<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends ConsumerState<ForgotPasswordView>
    with ScaffoldMessageMixin {
  final TextEditingController _email = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);

    final String? error = await ref
        .read(authProvider.notifier)
        .sendPasswordResetEmail(_email.text.trim(), context.l10n);

    if (!mounted) return;
    setState(() => _loading = false);

    if (error != null) {
      showAppSnackBar(context, message: error, isError: true);
    } else {
      showAppSnackBar(context, message: context.l10n.forgotPasswordSuccess);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double topRadius = WidgetSizesEnum.cardRadius.value * 1.45;
    final double hPad = WidgetSizesEnum.cardRadius.value * 1.35;
    final TextTheme tt = Theme.of(context).textTheme;
    final AppLocalizations l10n = context.l10n;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: context.palSurface,
        body: Column(
          children: <Widget>[
            Expanded(
              flex: WidgetSizesEnum.authLoginHeroFlexTop.value.toInt(),
              child: const AuthGradientHero(),
            ),
            Expanded(
              flex: WidgetSizesEnum.authLoginHeroFlexBottom.value.toInt(),
              child: Transform.translate(
                offset: Offset(
                  0,
                  -WidgetSizesEnum.homeHeaderExtend.value * 0.45,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.palSurfaceCard,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(topRadius),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.09),
                        blurRadius: WidgetSizesEnum.cardShadowBlur.value,
                        offset: Offset(
                          0,
                          -WidgetSizesEnum.cardShadowOffsetY.value * 0.35,
                        ),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(topRadius),
                    ),
                    child: SafeArea(
                      top: false,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          hPad,
                          WidgetSizesEnum.cardRadius.value * 1.35,
                          hPad,
                          WidgetSizesEnum.cardRadius.value * 1.5,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => context.pop(),
                                    icon: const Icon(Icons.arrow_back_rounded),
                                    style: IconButton.styleFrom(
                                      backgroundColor: context.palPrimarySoftBg,
                                      foregroundColor: context.palPrimary,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        WidgetSizesEnum.cardRadius.value * 0.65,
                                  ),
                                  Text(
                                    l10n.forgotPasswordTitle,
                                    style: tt.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: context.palOnSurface,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: WidgetSizesEnum.divider.value * 6,
                              ),
                              Text(
                                l10n.forgotPasswordSubtitle,
                                style: tt.bodyLarge?.copyWith(
                                  color: context.palMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: WidgetSizesEnum.cardRadius.value * 1.35,
                              ),
                              AppTextField(
                                label: l10n.emailLabel,
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? l10n.validationRequired
                                    : null,
                              ),
                              SizedBox(
                                height: WidgetSizesEnum.cardRadius.value * 1.45,
                              ),
                              AppPrimaryButton(
                                label: l10n.forgotPasswordCta,
                                isLoading: _loading,
                                onPressed: _onSubmit,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
