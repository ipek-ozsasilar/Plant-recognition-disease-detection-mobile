import 'package:bitirme_mobile/core/enums/home_daily_tip_kind_enum.dart';
import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/home_daily_tip_text.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/services/home_daily_tip_service.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/features/home/provider/home_daily_tip_provider.dart';
import 'package:bitirme_mobile/features/home/provider/home_daily_tip_state.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Günün ipucu: AI metni veya geçmişe göre yedek sabit metin.
class HomeInsightBanner extends ConsumerWidget {
  const HomeInsightBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme tt = Theme.of(context).textTheme;
    final AsyncValue<HomeDailyTipState> tipAsync = ref.watch(homeDailyTipProvider);

    return tipAsync.when(
      loading: () => _TipCard(
        title: context.l10n.homeTipTitle,
        body: context.l10n.homeTipLoading,
        showAiBadge: false,
        tt: tt,
      ),
      error: (_, __) => _buildFromState(
        context: context,
        state: const HomeDailyTipState(
          fallback: HomeDailyTipResult(kind: HomeDailyTipKindEnum.defaultPhoto),
        ),
        tt: tt,
      ),
      data: (HomeDailyTipState state) => _buildFromState(
        context: context,
        state: state,
        tt: tt,
      ),
    );
  }

  Widget _buildFromState({
    required BuildContext context,
    required HomeDailyTipState state,
    required TextTheme tt,
  }) {
    final String? ai = state.aiBody?.trim();
    final String body = ai != null && ai.isNotEmpty
        ? ai
        : homeDailyTipBodyForResult(
            context: context,
            l10n: context.l10n,
            result: state.fallback,
          );

    return _TipCard(
      title: context.l10n.homeTipTitle,
      body: body,
      showAiBadge: state.isFromAi,
      tt: tt,
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({
    required this.title,
    required this.body,
    required this.showAiBadge,
    required this.tt,
  });

  final String title;
  final String body;
  final bool showAiBadge;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
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
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        title,
                        style: tt.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: context.palOnSurface,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    if (showAiBadge) ...<Widget>[
                      SizedBox(width: WidgetSizesEnum.divider.value * 4),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: WidgetSizesEnum.divider.value * 6,
                          vertical: WidgetSizesEnum.divider.value * 2,
                        ),
                        decoration: BoxDecoration(
                          color: ColorName.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
                        ),
                        child: Text(
                          context.l10n.homeTipAiBadge,
                          style: tt.labelSmall?.copyWith(
                            color: ColorName.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
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
