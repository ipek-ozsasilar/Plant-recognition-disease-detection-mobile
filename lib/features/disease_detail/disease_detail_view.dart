import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/services/disease_info_catalog.dart';
import 'package:bitirme_mobile/core/services/disease_label_display.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/indicator/confidence_indicator.dart';
import 'package:bitirme_mobile/core/widgets/appbar/conditional_back_leading.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:flutter/material.dart';

/// Hastalık detay: açıklama, neden, tedavi, önleme.
class DiseaseDetailView extends StatelessWidget {
  const DiseaseDetailView({
    required this.diseaseKey,
    required this.confidence,
    super.key,
  });

  final String diseaseKey;
  final double confidence;

  @override
  Widget build(BuildContext context) {
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;
    final TextTheme tt = Theme.of(context).textTheme;
    final String title = diseaseClassKeyToDisplay(diseaseKey, context.l10n);
    final DiseaseInfo info = const DiseaseInfoCatalog().get(
      diseaseKey,
      context.l10n,
    );

    return Scaffold(
      backgroundColor: context.palSurface,
      appBar: appBarWithConditionalBack(
        context: context,
        title: Text(context.l10n.diseaseDetailTitle),
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
            title,
            style: tt.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: context.palOnSurface,
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          ConfidenceIndicator(
            confidenceUnit: confidence,
            label: context.l10n.diseaseDetailConfidenceLabel,
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          _SectionCard(
            title: context.l10n.diseaseDetailSectionDescription,
            body: info.description,
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          _SectionCard(
            title: context.l10n.diseaseDetailSectionCauses,
            body: info.causes,
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          _SectionCard(
            title: context.l10n.diseaseDetailSectionTreatment,
            body: info.treatment,
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          _SectionCard(
            title: context.l10n.diseaseDetailSectionPrevention,
            body: info.prevention,
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.body});

  final String title;
  final String body;

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
          SizedBox(height: WidgetSizesEnum.divider.value * 10),
          Text(
            body,
            style: tt.bodyMedium?.copyWith(
              color: context.palMuted,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
