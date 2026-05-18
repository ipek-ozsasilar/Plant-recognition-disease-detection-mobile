import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/appbar/conditional_back_leading.dart';
import 'package:flutter/material.dart';

/// Proje hakkında bilgi.
class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithConditionalBack(
        context: context,
        title: Text(context.l10n.aboutTitle),
      ),
      body: Padding(
        padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 1.25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              context.l10n.appName,
              style: TextStyle(
                fontSize: TextSizesEnum.headline.value,
                fontWeight: FontWeight.bold,
                color: context.palPrimary,
              ),
            ),
            SizedBox(height: WidgetSizesEnum.cardRadius.value),
            Text(
              context.l10n.aboutBody,
              style: TextStyle(
                fontSize: TextSizesEnum.body.value,
                color: context.palMuted,
                height: 1.5,
              ),
            ),
            SizedBox(height: WidgetSizesEnum.cardRadius.value),
            Text(
              context.l10n.aboutThesis,
              style: TextStyle(
                fontSize: TextSizesEnum.body.value,
                color: context.palOnSurface,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
