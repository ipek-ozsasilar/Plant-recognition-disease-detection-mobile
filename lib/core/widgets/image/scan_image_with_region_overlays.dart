import 'dart:typed_data';

import 'package:bitirme_mobile/core/widgets/image/scan_region_frame_style.dart';
import 'package:bitirme_mobile/models/plant_region_model.dart';
import 'package:flutter/material.dart';

/// Ağ veya bellek görüntüsü üzerinde normalize bölge dikdörtgenleri.
class ScanImageWithRegionOverlays extends StatelessWidget {
  const ScanImageWithRegionOverlays({
    required this.regions,
    this.imageUrl,
    this.imageBytes,
    this.highlightIndex,
    this.frameStyle = ScanRegionFrameStyle.savedRed,
    this.fit = BoxFit.contain,
    this.borderRadius,
    super.key,
  }) : assert(imageUrl != null || imageBytes != null);

  final String? imageUrl;
  final Uint8List? imageBytes;
  final List<PlantRegionModel> regions;
  final int? highlightIndex;
  final ScanRegionFrameStyle frameStyle;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final Widget image = imageBytes != null
        ? Image.memory(imageBytes!, fit: BoxFit.fill)
        : Image.network(imageUrl!, fit: BoxFit.fill);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double w = constraints.maxWidth;
        final double h = constraints.maxHeight;
        final bool isWhite = frameStyle == ScanRegionFrameStyle.selectionWhite;
        final Color borderColor = isWhite ? Colors.white : Colors.red;
        final Color labelColor = isWhite ? Colors.white : Colors.red.shade700;

        return ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: <Widget>[
              Positioned.fill(child: image),
              if (regions.isNotEmpty)
                ...regions.asMap().entries.map((MapEntry<int, PlantRegionModel> e) {
                  final int idx = e.key;
                  final PlantRegionModel r = e.value;
                  final bool highlight = highlightIndex == idx;
                  final double stroke = highlight ? 3.5 : 2.5;
                  return Positioned(
                    left: r.nx * w,
                    top: r.ny * h,
                    width: r.nw * w,
                    height: r.nh * h,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor, width: stroke),
                          color: isWhite
                              ? Colors.white.withValues(alpha: highlight ? 0.14 : 0.08)
                              : Colors.red.withValues(alpha: highlight ? 0.12 : 0.05),
                        ),
                        child: Center(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              child: Text(
                                '${idx + 1}',
                                style: TextStyle(
                                  color: labelColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}
