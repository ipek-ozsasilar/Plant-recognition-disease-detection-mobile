import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

/// Tarama fotoğrafını tam ekran gösterir.
Future<void> showScanImageViewerDialog({
  required BuildContext context,
  required String? imageUrl,
  String? caption,
}) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return Future<void>.value();
  }
  return showDialog<void>(
    context: context,
    builder: (BuildContext ctx) {
      final double maxImageHeight = MediaQuery.sizeOf(ctx).height * 0.72;
      final double maxImageWidth =
          MediaQuery.sizeOf(ctx).width - WidgetSizesEnum.cardRadius.value * 2;

      return Dialog(
        backgroundColor: context.palSurfaceCard,
        insetPadding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.of(ctx).pop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                WidgetSizesEnum.cardRadius.value,
                0,
                WidgetSizesEnum.cardRadius.value,
                WidgetSizesEnum.cardRadius.value,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: maxImageHeight,
                  maxWidth: maxImageWidth,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            if (caption != null && caption.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(
                  left: WidgetSizesEnum.cardRadius.value,
                  right: WidgetSizesEnum.cardRadius.value,
                  bottom: WidgetSizesEnum.cardRadius.value,
                ),
                child: Text(
                  caption,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.palMuted,
                    fontWeight: FontWeight.w600,
                    fontSize: TextSizesEnum.body.value,
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}
