import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

/// Tarama küçük görseli (Firestore `imageUrl`).
class ScanThumbnailImage extends StatelessWidget {
  const ScanThumbnailImage({
    required this.imageUrl,
    this.size,
    super.key,
  });

  final String? imageUrl;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final double side = size ?? WidgetSizesEnum.cardRadius.value * 2.2;
    return SizedBox(
      width: side,
      height: side,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.palPrimary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholder(context),
                )
              : _placeholder(context),
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return ColoredBox(
      color: context.palPrimarySoftBg,
      child: Center(
        child: Icon(
          Icons.eco_rounded,
          color: context.palPrimary,
          size: IconSizesEnum.medium.value,
        ),
      ),
    );
  }
}
