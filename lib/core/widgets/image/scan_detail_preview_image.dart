import 'dart:math' as math;

import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

/// Tarama detayında fotoğrafın tamamı görünsün (kırpılmadan, orana göre boyut).
class ScanDetailPreviewImage extends StatefulWidget {
  const ScanDetailPreviewImage({
    required this.imageUrl,
    this.onTap,
    super.key,
  });

  final String imageUrl;
  final VoidCallback? onTap;

  @override
  State<ScanDetailPreviewImage> createState() => _ScanDetailPreviewImageState();
}

class _ScanDetailPreviewImageState extends State<ScanDetailPreviewImage> {
  double? _aspectRatio;
  bool _failed = false;
  ImageStream? _imageStream;
  ImageStreamListener? _imageListener;

  @override
  void initState() {
    super.initState();
    _resolveAspectRatio();
  }

  @override
  void didUpdateWidget(covariant ScanDetailPreviewImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _disposeImageStream();
      _aspectRatio = null;
      _failed = false;
      _resolveAspectRatio();
    }
  }

  @override
  void dispose() {
    _disposeImageStream();
    super.dispose();
  }

  void _disposeImageStream() {
    if (_imageStream != null && _imageListener != null) {
      _imageStream!.removeListener(_imageListener!);
    }
    _imageStream = null;
    _imageListener = null;
  }

  void _resolveAspectRatio() {
    final ImageStream stream = NetworkImage(
      widget.imageUrl,
    ).resolve(const ImageConfiguration());
    _imageStream = stream;
    _imageListener = ImageStreamListener(
      (ImageInfo info, bool _) {
        if (!mounted) {
          return;
        }
        final int w = info.image.width;
        final int h = info.image.height;
        if (w > 0 && h > 0) {
          setState(() => _aspectRatio = w / h);
        }
        _disposeImageStream();
      },
      onError: (_, __) {
        if (mounted) {
          setState(() => _failed = true);
        }
        _disposeImageStream();
      },
    );
    stream.addListener(_imageListener!);
  }

  @override
  Widget build(BuildContext context) {
    final double maxHeight = math.min(
      MediaQuery.sizeOf(context).height *
          SheetSizesEnum.historyPhotoMaxScreenFraction.value,
      ImageSizesEnum.historyScanDetailMaxHeight.value,
    );
    final double radius = WidgetSizesEnum.chipRadius.value;

    Widget imageBody = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double maxWidth = constraints.maxWidth;
        final double ratio = _aspectRatio ?? (4 / 3);
        double width = maxWidth;
        double height = width / ratio;
        if (height > maxHeight) {
          height = maxHeight;
          width = height * ratio;
        }

        if (_aspectRatio == null && !_failed) {
          return SizedBox(
            height: math.min(maxHeight, maxWidth / ratio),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (_failed) {
          return SizedBox(
            height: ImageSizesEnum.preview.value,
            child: _placeholder(context),
          );
        }

        return Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: width,
            height: height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Image.network(
                widget.imageUrl,
                width: width,
                height: height,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => _placeholder(context),
              ),
            ),
          ),
        );
      },
    );

    if (widget.onTap != null) {
      imageBody = GestureDetector(onTap: widget.onTap, child: imageBody);
    }

    return imageBody;
  }

  Widget _placeholder(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.palPrimarySoftBg,
        borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
      ),
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: IconSizesEnum.xlarge.value,
          color: context.palMuted,
        ),
      ),
    );
  }
}
