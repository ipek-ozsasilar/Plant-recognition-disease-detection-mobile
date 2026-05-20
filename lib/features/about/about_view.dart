import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/appbar/conditional_back_leading.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:flutter/material.dart';

/// Proje hakkında bilgi.
class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;

    return Scaffold(
      backgroundColor: context.palSurface,
      appBar: appBarWithConditionalBack(
        context: context,
        title: Text(context.l10n.aboutTitle),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          pad,
          pad,
          pad,
          WidgetSizesEnum.bottomNavHeight.value,
        ),
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: WidgetSizesEnum.cardRadius.value * 2.4,
                height: WidgetSizesEnum.cardRadius.value * 2.4,
                decoration: BoxDecoration(
                  color: context.palPrimarySoftBg,
                  borderRadius: BorderRadius.circular(
                    WidgetSizesEnum.chipRadius.value,
                  ),
                ),
                child: Icon(
                  Icons.eco_rounded,
                  color: context.palPrimary,
                  size: IconSizesEnum.xlarge.value,
                ),
              ),
              SizedBox(width: WidgetSizesEnum.cardRadius.value),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      context.l10n.appName,
                      style: tt.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: context.palPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: WidgetSizesEnum.divider.value * 4),
                    Text(
                      context.l10n.aboutSubtitle,
                      style: tt.bodyMedium?.copyWith(
                        color: context.palMuted,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.25),
          _AboutSection(
            title: context.l10n.aboutPurposeTitle,
            body: context.l10n.aboutPurposeBody,
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          _AboutSection(
            title: context.l10n.aboutFeaturesTitle,
            body: context.l10n.aboutFeaturesBody,
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          _AboutSection(
            title: context.l10n.aboutHowItWorksTitle,
            body: context.l10n.aboutHowItWorksBody,
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          _AboutSection(
            title: context.l10n.aboutThesisTitle,
            body: context.l10n.aboutThesisBody,
            accent: true,
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          SoftElevationCard(
            onTap: null,
            backgroundColor: context.palPrimarySoftBg,
            padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  context.l10n.aboutDisclaimerTitle,
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: context.palOnSurface,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.divider.value * 8),
                Text(
                  context.l10n.aboutDisclaimerBody,
                  style: tt.bodySmall?.copyWith(
                    color: context.palMuted,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.1),
          Center(
            child: Text(
              context.l10n.aboutVersionLabel,
              style: tt.labelMedium?.copyWith(
                color: context.palMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({
    required this.title,
    required this.body,
    this.accent = false,
  });

  final String title;
  final String body;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    return SoftElevationCard(
      onTap: null,
      backgroundColor: accent ? context.palPrimarySoftBg : null,
      padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: context.palOnSurface,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.divider.value * 8),
          Text(
            body,
            style: tt.bodyMedium?.copyWith(
              color: context.palMuted,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
