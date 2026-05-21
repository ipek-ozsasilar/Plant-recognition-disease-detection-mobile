import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/locale/species_class_display.dart';
import 'package:bitirme_mobile/core/services/disease_label_display.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/models/plant_scan_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Son taramalar — yatay kaydırmalı kart şeridi.
class HomeRecentStrip extends StatelessWidget {
  const HomeRecentStrip({required this.records, super.key});

  final List<PlantScanModel> records;

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    final String lang = Localizations.localeOf(context).languageCode;
    final DateFormat fmt = DateFormat.yMMMd(lang);
    return SizedBox(
      height: WidgetSizesEnum.recentCardHeight.value,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: records.length,
        separatorBuilder: (_, __) =>
            SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.85),
        itemBuilder: (BuildContext context, int i) {
          final PlantScanModel e = records[i];
          final String dateStr = fmt.format(e.createdAt);
          return Container(
            width: WidgetSizesEnum.maxContentWidth.value * 0.52,
            decoration: BoxDecoration(
              color: context.palSurfaceCard,
              borderRadius: BorderRadius.circular(
                WidgetSizesEnum.cardRadius.value,
              ),
              border: Border.all(
                color: context.palOutline.withValues(alpha: 0.45),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: context.palPrimary.withValues(alpha: 0.06),
                  blurRadius: WidgetSizesEnum.cardShadowBlur.value * 0.7,
                  offset: Offset(
                    0,
                    WidgetSizesEnum.cardShadowOffsetY.value * 0.65,
                  ),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                WidgetSizesEnum.cardRadius.value,
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: WidgetSizesEnum.divider.value * 5,
                    color: context.palAccent,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(
                        WidgetSizesEnum.cardRadius.value * 0.75,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.eco_rounded,
                                size: IconSizesEnum.small.value,
                                color: context.palPrimary,
                              ),
                              SizedBox(
                                width: WidgetSizesEnum.divider.value * 4,
                              ),
                              Expanded(
                                child: Text(
                                  speciesClassDisplayForRaw(
                                    context,
                                    e.speciesLabel,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: tt.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: context.palOnSurface,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: WidgetSizesEnum.divider.value * 6),
                          Text(
                            diseaseDisplayForScan(e, context.l10n),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: tt.bodySmall?.copyWith(
                              color: context.palMuted,
                              height: 1.25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            dateStr,
                            style: tt.labelSmall?.copyWith(
                              color: context.palMuted,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
