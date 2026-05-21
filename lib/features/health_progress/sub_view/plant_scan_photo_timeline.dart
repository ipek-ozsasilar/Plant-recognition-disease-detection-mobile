import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/services/disease_label_display.dart';
import 'package:bitirme_mobile/core/services/plant_scan_display_helper.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/image/scan_image_viewer_dialog.dart';
import 'package:bitirme_mobile/core/widgets/image/scan_thumbnail_image.dart';
import 'package:bitirme_mobile/models/plant_scan_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Seçili bitkinin tarama fotoğrafları (kronolojik).
class PlantScanPhotoTimeline extends StatelessWidget {
  const PlantScanPhotoTimeline({
    required this.scans,
    required this.dateFormat,
    super.key,
  });

  final List<PlantScanModel> scans;
  final DateFormat dateFormat;

  static double get _thumbSize => ImageSizesEnum.thumb.value * 0.72;

  @override
  Widget build(BuildContext context) {
    if (scans.isEmpty) {
      return Text(
        context.l10n.healthProgressNoPhotoTimeline,
        style: TextStyle(
          color: context.palMuted,
          fontWeight: FontWeight.w600,
          fontSize: TextSizesEnum.body.value,
        ),
      );
    }

    final List<PlantScanModel> sorted = List<PlantScanModel>.from(scans)
      ..sort(
        (PlantScanModel a, PlantScanModel b) => a.createdAt.compareTo(b.createdAt),
      );

    return SizedBox(
      height: _thumbSize + WidgetSizesEnum.cardRadius.value * 2.4,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: sorted.length,
        separatorBuilder: (_, __) => SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.65),
        itemBuilder: (BuildContext context, int index) {
          final PlantScanModel scan = sorted[index];
          final String disease = diseaseDisplayForScan(scan, context.l10n);
          final String caption =
              '${dateFormat.format(scan.createdAt)} · $disease';

          return GestureDetector(
            onTap: () => showScanImageViewerDialog(
              context: context,
              imageUrl: scan.fullImageUrl,
              caption: caption,
              regions: scanRegionsForDisplay(scan),
              highlightRegionIndex: 0,
            ),
            child: SizedBox(
              width: _thumbSize + WidgetSizesEnum.divider.value * 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ScanThumbnailImage(
                    imageUrl: scan.listThumbnailUrl,
                    size: _thumbSize,
                  ),
                  SizedBox(height: WidgetSizesEnum.divider.value * 6),
                  Text(
                    dateFormat.format(scan.createdAt),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: TextSizesEnum.caption.value * 0.9,
                      fontWeight: FontWeight.w800,
                      color: context.palOnSurface,
                    ),
                  ),
                  Text(
                    disease,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: TextSizesEnum.caption.value * 0.85,
                      color: context.palMuted,
                      fontWeight: FontWeight.w600,
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
