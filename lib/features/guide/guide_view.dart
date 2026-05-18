import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/appbar/conditional_back_leading.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:flutter/material.dart';

/// Bakım ve fotoğraf ipuçları rehberi.
class GuideView extends StatelessWidget {
  const GuideView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;
    return Scaffold(
      backgroundColor: context.palSurface,
      appBar: appBarWithConditionalBack(
        context: context,
        title: Text(context.l10n.guideTitle),
        actions: <Widget>[
          IconButton(
            tooltip: context.l10n.search,
            onPressed: null,
            icon: const Icon(Icons.search_rounded),
          ),
        ],
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
            context.l10n.guidesHeadline,
            style: tt.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: context.palOnSurface,
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.divider.value * 8),
          Text(
            context.l10n.guidesSubtitle,
            style: tt.bodyLarge?.copyWith(
              color: context.palMuted,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.25),
          _GuideHeroCard(
            title: context.l10n.guideSectionPhoto,
            body: context.l10n.guidePhotoTips,
            icon: Icons.photo_camera_rounded,
            onTap: null,
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          _GuideDualCard(
            title: context.l10n.guideSectionMulti,
            body: context.l10n.guideMultiTips,
            leftIcon: Icons.crop_free_rounded,
            rightIcon: Icons.center_focus_strong_rounded,
            onTap: null,
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          _SafetyCheckCard(
            title: context.l10n.guideSectionDisease,
            body: context.l10n.guideDiseaseTips,
            onTap: null,
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          _InfoBanner(text: context.l10n.guidesFooterInfo),
        ],
      ),
    );
  }
}

class _GuideHeroCard extends StatelessWidget {
  const _GuideHeroCard({
    required this.title,
    required this.body,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String body;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    return SoftElevationCard(
      onTap: onTap,
      padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                title,
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: context.palOnSurface,
                ),
              ),
              const Spacer(),
              Container(
                width: WidgetSizesEnum.cardRadius.value * 1.85,
                height: WidgetSizesEnum.cardRadius.value * 1.85,
                decoration: BoxDecoration(
                  color: context.palPrimarySoftBg,
                  borderRadius: BorderRadius.circular(
                    WidgetSizesEnum.chipRadius.value,
                  ),
                ),
                child: Icon(icon, color: context.palPrimary),
              ),
            ],
          ),
          SizedBox(height: WidgetSizesEnum.divider.value * 8),
          Text(
            body,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: tt.bodyMedium?.copyWith(
              color: context.palMuted,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.85),
          Row(
            children: <Widget>[
              Text(
                context.l10n.guidesLearnMore,
                style: tt.labelLarge?.copyWith(
                  color: context.palPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: WidgetSizesEnum.divider.value * 6),
              Icon(
                Icons.arrow_forward_rounded,
                color: context.palPrimary,
                size: IconSizesEnum.small.value,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GuideDualCard extends StatelessWidget {
  const _GuideDualCard({
    required this.title,
    required this.body,
    required this.leftIcon,
    required this.rightIcon,
    required this.onTap,
  });

  final String title;
  final String body;
  final IconData leftIcon;
  final IconData rightIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    return SoftElevationCard(
      onTap: onTap,
      padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                title,
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: context.palOnSurface,
                ),
              ),
              const Spacer(),
              Row(
                children: <Widget>[
                  _MiniIconBox(icon: leftIcon),
                  SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.65),
                  _MiniIconBox(icon: rightIcon),
                ],
              ),
            ],
          ),
          SizedBox(height: WidgetSizesEnum.divider.value * 8),
          Text(
            body,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: tt.bodyMedium?.copyWith(
              color: context.palMuted,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniIconBox extends StatelessWidget {
  const _MiniIconBox({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: WidgetSizesEnum.cardRadius.value * 1.65,
      height: WidgetSizesEnum.cardRadius.value * 1.65,
      decoration: BoxDecoration(
        color: context.palSurface,
        borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
        border: Border.all(color: context.palOutline.withValues(alpha: 0.35)),
      ),
      child: Icon(
        icon,
        color: context.palPrimary,
        size: IconSizesEnum.medium.value,
      ),
    );
  }
}

class _SafetyCheckCard extends StatelessWidget {
  const _SafetyCheckCard({
    required this.title,
    required this.body,
    required this.onTap,
  });

  final String title;
  final String body;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    return SoftElevationCard(
      onTap: onTap,
      backgroundColor: context.palPrimarySoftBg,
      padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.05),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: WidgetSizesEnum.cardRadius.value * 0.65,
                    vertical: WidgetSizesEnum.divider.value * 8,
                  ),
                  decoration: BoxDecoration(
                    color: context.palSurfaceCard,
                    borderRadius: BorderRadius.circular(
                      WidgetSizesEnum.chipRadius.value,
                    ),
                  ),
                  child: Text(
                    context.l10n.guidesSafetyCheckBadge,
                    style: tt.labelSmall?.copyWith(
                      letterSpacing: 0.8,
                      color: context.palPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.75),
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
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: tt.bodySmall?.copyWith(
                    color: context.palMuted,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.85),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: WidgetSizesEnum.cardRadius.value * 0.85,
                    vertical: WidgetSizesEnum.divider.value * 10,
                  ),
                  decoration: BoxDecoration(
                    color: context.palSurfaceCard,
                    borderRadius: BorderRadius.circular(
                      WidgetSizesEnum.chipRadius.value,
                    ),
                    border: Border.all(
                      color: context.palOutline.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.local_florist_rounded,
                        size: IconSizesEnum.small.value,
                        color: context.palPrimary,
                      ),
                      SizedBox(width: WidgetSizesEnum.divider.value * 8),
                      Text(
                        context.l10n.guidesCheckPlantsCta,
                        style: tt.labelLarge?.copyWith(
                          color: context.palPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: WidgetSizesEnum.cardRadius.value),
          Icon(
            Icons.shield_moon_rounded,
            color: context.palPrimary.withValues(alpha: 0.5),
            size: IconSizesEnum.xlarge.value,
          ),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return SoftElevationCard(
      backgroundColor: context.palPrimarySoftBg,
      padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 0.95),
      child: Row(
        children: <Widget>[
          Icon(Icons.info_outline_rounded, color: context.palPrimary),
          SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.75),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: context.palMuted,
                height: 1.35,
                fontWeight: FontWeight.w600,
                fontSize: TextSizesEnum.caption.value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
