import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/locale/species_class_display.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/indicator/confidence_indicator.dart';
import 'package:bitirme_mobile/core/widgets/appbar/conditional_back_leading.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Tür detay: bakım + riskli hastalıklar (MVP: katalog metinleri l10n içinden).
class SpeciesDetailView extends StatelessWidget {
  const SpeciesDetailView({
    required this.speciesLabel,
    required this.confidence,
    super.key,
  });

  final String speciesLabel;
  final double confidence;

  @override
  Widget build(BuildContext context) {
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;
    final TextTheme tt = Theme.of(context).textTheme;

    final List<_RiskDisease> risks = <_RiskDisease>[
      _RiskDisease(
        key: 'powdery_mildew',
        label: context.l10n.inferenceDiseasePowderyMildew,
      ),
      _RiskDisease(key: 'blight', label: context.l10n.inferenceDiseaseBlight),
      _RiskDisease(key: 'rust', label: context.l10n.inferenceDiseaseRust),
    ];

    return Scaffold(
      backgroundColor: context.palSurface,
      appBar: appBarWithConditionalBack(
        context: context,
        title: Text(context.l10n.speciesDetailTitle),
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
            speciesClassDisplayForRaw(
              context,
              Uri.decodeComponent(speciesLabel),
            ),
            style: tt.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: context.palOnSurface,
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          ConfidenceIndicator(
            confidenceUnit: confidence,
            label: context.l10n.speciesDetailConfidenceLabel,
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          _CareCard(
            title: context.l10n.speciesDetailCareTitle,
            items: <_CareItem>[
              _CareItem(
                label: context.l10n.speciesDetailWateringLabel,
                value: context.l10n.speciesDetailWateringValue,
              ),
              _CareItem(
                label: context.l10n.speciesDetailSunLabel,
                value: context.l10n.speciesDetailSunValue,
              ),
              _CareItem(
                label: context.l10n.speciesDetailSoilLabel,
                value: context.l10n.speciesDetailSoilValue,
              ),
            ],
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          SoftElevationCard(
            onTap: null,
            padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  context.l10n.speciesDetailRiskTitle,
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: context.palOnSurface,
                  ),
                ),
                SizedBox(height: WidgetSizesEnum.divider.value * 10),
                ...risks.map((_RiskDisease d) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: WidgetSizesEnum.divider.value * 10,
                    ),
                    child: SoftElevationCard(
                      onTap: () => context.push(
                        '${AppPaths.diseaseDetail}/${d.key}?confidence=0',
                      ),
                      padding: EdgeInsets.all(
                        WidgetSizesEnum.cardRadius.value * 0.85,
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: WidgetSizesEnum.cardRadius.value * 1.35,
                            height: WidgetSizesEnum.cardRadius.value * 1.35,
                            decoration: BoxDecoration(
                              color: context.palAccent.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(
                                WidgetSizesEnum.chipRadius.value,
                              ),
                            ),
                            child: Icon(
                              Icons.warning_rounded,
                              color: context.palAccent,
                            ),
                          ),
                          SizedBox(
                            width: WidgetSizesEnum.cardRadius.value * 0.75,
                          ),
                          Expanded(
                            child: Text(
                              d.label,
                              style: tt.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: context.palOnSurface,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: context.palMuted,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _CareItem {
  const _CareItem({required this.label, required this.value});
  final String label;
  final String value;
}

final class _RiskDisease {
  const _RiskDisease({required this.key, required this.label});
  final String key;
  final String label;
}

class _CareCard extends StatelessWidget {
  const _CareCard({required this.title, required this.items});

  final String title;
  final List<_CareItem> items;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    return SoftElevationCard(
      onTap: null,
      padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: tt.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: context.palOnSurface,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.85),
          ...items.map((_CareItem it) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: WidgetSizesEnum.divider.value * 10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width:
                        100, // Etiket için sabit genişlik vererek kaymayı engelliyoruz
                    child: Text(
                      it.label,
                      style: tt.bodyMedium?.copyWith(
                        color: context.palMuted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      it.value,
                      textAlign: TextAlign.right,
                      style: tt.bodyMedium?.copyWith(
                        color: context.palOnSurface,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
