import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class ProfileStatPill extends StatelessWidget {
  const ProfileStatPill({
    required this.value,
    required this.label,
    required this.accent,
    this.icon = Icons.eco_rounded,
    super.key,
  });

  final String value;
  final String label;
  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: WidgetSizesEnum.cardRadius.value * 0.95,
        vertical: WidgetSizesEnum.cardRadius.value * 0.75,
      ),
      decoration: BoxDecoration(
        color: context.palSurfaceCard,
        borderRadius: BorderRadius.circular(WidgetSizesEnum.cardRadius.value * 1.35),
        border: Border.all(color: context.palOutline.withValues(alpha: 0.45)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: accent.withValues(alpha: 0.12),
            blurRadius: WidgetSizesEnum.cardShadowBlur.value * 0.65,
            offset: Offset(0, WidgetSizesEnum.cardShadowOffsetY.value * 0.65),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(WidgetSizesEnum.divider.value * 8),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
            ),
            child: Icon(icon, color: accent, size: IconSizesEnum.medium.value),
          ),
          SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.75),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: context.palOnSurface,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.divider.value * 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.labelMedium?.copyWith(
                    color: context.palMuted,
                    fontWeight: FontWeight.w700,
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

