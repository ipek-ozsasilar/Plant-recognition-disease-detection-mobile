import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/home_daily_tip_text.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/services/home_daily_tip_service.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/features/home/provider/home_daily_tip_provider.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Geçmiş taramalara göre kural tabanlı günün ipucu kartı.
class HomeInsightBanner extends ConsumerWidget {
  const HomeInsightBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme tt = Theme.of(context).textTheme;
    final HomeDailyTipResult tip = ref.watch(homeDailyTipProvider);
    final String body = homeDailyTipBodyForResult(
      context: context,
      l10n: context.l10n,
      result: tip,
    );

    return SoftElevationCard(
      onTap: null,
      padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.05),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(WidgetSizesEnum.divider.value * 10),
            decoration: BoxDecoration(
              color: ColorName.warning.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
            ),
            child: Icon(
              Icons.lightbulb_outline_rounded,
              color: context.palOnSurface,
              size: IconSizesEnum.large.value,
            ),
          ),
          SizedBox(width: WidgetSizesEnum.cardRadius.value),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  context.l10n.homeTipTitle,
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: context.palOnSurface,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.divider.value * 6),
                Text(
                  body,
                  style: tt.bodySmall?.copyWith(
                    color: context.palMuted,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
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
