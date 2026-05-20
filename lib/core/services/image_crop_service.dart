import 'dart:typed_data';

import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/models/plant_region_model.dart';
import 'package:image/image.dart' as img;

/// Normalize dikdörtgen alandan görüntü kırpar.
class ImageCropService {
  ImageCropService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;

  Uint8List? cropRegion({
    required Uint8List imageBytes,
    required PlantRegionModel region,
  }) {
    try {
      final img.Image? raw = img.decodeImage(imageBytes);
      if (raw == null) {
        return null;
      }
      final img.Image decoded = img.bakeOrientation(raw);
      final int w = decoded.width;
      final int h = decoded.height;
      final int left = (region.nx * w).round().clamp(0, w - 1);
      final int top = (region.ny * h).round().clamp(0, h - 1);
      int cropW = (region.nw * w).round().clamp(1, w - left);
      int cropH = (region.nh * h).round().clamp(1, h - top);
      const int minSide = 96;
      img.Image cropped = img.copyCrop(
        decoded,
        x: left,
        y: top,
        width: cropW,
        height: cropH,
      );
      if (cropped.width < minSide || cropped.height < minSide) {
        final int targetW = cropped.width < minSide ? minSide : cropped.width;
        final int targetH = cropped.height < minSide ? minSide : cropped.height;
        cropped = img.copyResize(
          cropped,
          width: targetW,
          height: targetH,
          interpolation: img.Interpolation.linear,
        );
      }
      final Uint8List out = Uint8List.fromList(img.encodeJpg(cropped, quality: 92));
      return out;
    } catch (e, st) {
      _logger.e('image_crop', e, st);
      return null;
    }
  }

  /// Dokunuş merkezli varsayılan kare bölge (normalize).
  PlantRegionModel regionAroundTap({
    required double nx,
    required double ny,
    double? side,
  }) {
    final double s = side ?? WidgetSizesEnum.regionMinSide.value;
    double left = nx - s / 2;
    double top = ny - s / 2;
    if (left < 0) {
      left = 0;
    }
    if (top < 0) {
      top = 0;
    }
    if (left + s > 1) {
      left = 1 - s;
    }
    if (top + s > 1) {
      top = 1 - s;
    }
    return PlantRegionModel(
      id: '',
      nx: left,
      ny: top,
      nw: s,
      nh: s,
    );
  }

  /// Sürükle-bırak ile seçilen dikdörtgen bölgeyi normalize edip minimum boyuta zorlar.
  PlantRegionModel regionFromDragRect({
    required double startNx,
    required double startNy,
    required double endNx,
    required double endNy,
    double? minSide,
  }) {
    final double sMin = minSide ?? WidgetSizesEnum.regionMinSide.value;
    final double left0 = startNx < endNx ? startNx : endNx;
    final double top0 = startNy < endNy ? startNy : endNy;
    final double right0 = startNx < endNx ? endNx : startNx;
    final double bottom0 = startNy < endNy ? endNy : startNy;

    double left = left0.clamp(0.0, 1.0);
    double top = top0.clamp(0.0, 1.0);
    final double right = right0.clamp(0.0, 1.0);
    final double bottom = bottom0.clamp(0.0, 1.0);

    double w = (right - left).clamp(0.0, 1.0);
    double h = (bottom - top).clamp(0.0, 1.0);
    if (w < sMin || h < sMin) {
      final double cx = (left + right) / 2.0;
      final double cy = (top + bottom) / 2.0;
      w = w < sMin ? sMin : w;
      h = h < sMin ? sMin : h;
      left = (cx - w / 2.0).clamp(0.0, 1.0);
      top = (cy - h / 2.0).clamp(0.0, 1.0);
      if (left + w > 1.0) {
        left = 1.0 - w;
      }
      if (top + h > 1.0) {
        top = 1.0 - h;
      }
    }

    return PlantRegionModel(
      id: '',
      nx: left,
      ny: top,
      nw: w,
      nh: h,
    );
  }

  /// Storage yükleme için JPEG baytları: önce bölge kırpımı, olmazsa tüm fotoğraf.
  Uint8List? bytesForScanUpload({
    required Uint8List imageBytes,
    required List<PlantRegionModel> regions,
    required int selectedRegionIndex,
  }) {
    if (regions.isNotEmpty) {
      final int idx = selectedRegionIndex.clamp(0, regions.length - 1);
      final Uint8List? cropped = cropRegion(
        imageBytes: imageBytes,
        region: regions[idx],
      );
      if (cropped != null) {
        return cropped;
      }
    }
    return encodeJpeg(imageBytes);
  }

  Uint8List? encodeJpeg(Uint8List imageBytes) {
    try {
      final img.Image? decoded = img.decodeImage(imageBytes);
      if (decoded == null) {
        return null;
      }
      return Uint8List.fromList(img.encodeJpg(decoded, quality: 92));
    } catch (e, st) {
      _logger.e('image_encode_jpeg', e, st);
      return null;
    }
  }
}
