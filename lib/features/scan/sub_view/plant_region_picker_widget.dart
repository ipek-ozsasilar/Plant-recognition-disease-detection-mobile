import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/models/plant_region_model.dart';
import 'package:flutter/material.dart';

/// Görüntü üzerinde dokunarak bitki bölgeleri ekler.
class PlantRegionPickerWidget extends StatefulWidget {
  const PlantRegionPickerWidget({
    required this.bytes,
    required this.regions,
    required this.selectedIndex,
    required this.onCreateRegionFromDrag,
    required this.onSelectRegion,
    super.key,
  });

  final Uint8List bytes;
  final List<PlantRegionModel> regions;
  final int selectedIndex;
  final void Function({
    required double startNx,
    required double startNy,
    required double endNx,
    required double endNy,
  }) onCreateRegionFromDrag;
  final ValueChanged<int> onSelectRegion;

  @override
  State<PlantRegionPickerWidget> createState() => _PlantRegionPickerWidgetState();
}

class _PlantRegionPickerWidgetState extends State<PlantRegionPickerWidget> {
  ui.Image? _decoded;
  Offset? _dragStart;
  Offset? _dragNow;

  @override
  void initState() {
    super.initState();
    _decode();
  }

  Future<void> _decode() async {
    try {
      final ui.Codec codec = await ui.instantiateImageCodec(widget.bytes);
      final ui.FrameInfo frame = await codec.getNextFrame();
      final ui.Image imgDecoded = frame.image;
      if (!mounted) {
        return;
      }
      setState(() => _decoded = imgDecoded);
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _decoded = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ui.Image? decoded = _decoded;
    if (decoded == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final double iw = decoded.width.toDouble();
    final double ih = decoded.height.toDouble();
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double maxW = constraints.maxWidth;
        final double maxH = WidgetSizesEnum.maxContentWidth.value * 1.2;
        final double scale = math.min(maxW / iw, maxH / ih);
        final double dw = iw * scale;
        final double dh = ih * scale;
        final Offset? dragStart = _dragStart;
        final Offset? dragNow = _dragNow;
        Rect? liveRect;
        if (dragStart != null && dragNow != null) {
          final double l = math.min(dragStart.dx, dragNow.dx);
          final double t = math.min(dragStart.dy, dragNow.dy);
          final double r = math.max(dragStart.dx, dragNow.dx);
          final double b = math.max(dragStart.dy, dragNow.dy);
          liveRect = Rect.fromLTRB(l, t, r, b);
        }
        return Center(
          child: SizedBox(
            width: dw,
            height: dh,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (DragStartDetails details) {
                    final Offset local = details.localPosition;
                    setState(() {
                      _dragStart = Offset(
                        local.dx.clamp(0.0, dw),
                        local.dy.clamp(0.0, dh),
                      );
                      _dragNow = _dragStart;
                    });
                  },
                  onPanUpdate: (DragUpdateDetails details) {
                    final Offset local = details.localPosition;
                    setState(() {
                      _dragNow = Offset(
                        local.dx.clamp(0.0, dw),
                        local.dy.clamp(0.0, dh),
                      );
                    });
                  },
                  onPanEnd: (_) {
                    final Offset? a = _dragStart;
                    final Offset? b = _dragNow;
                    setState(() {
                      _dragStart = null;
                      _dragNow = null;
                    });
                    if (a == null || b == null) {
                      return;
                    }
                    final double startNx = (a.dx / dw).clamp(0.0, 1.0);
                    final double startNy = (a.dy / dh).clamp(0.0, 1.0);
                    final double endNx = (b.dx / dw).clamp(0.0, 1.0);
                    final double endNy = (b.dy / dh).clamp(0.0, 1.0);
                    widget.onCreateRegionFromDrag(
                      startNx: startNx,
                      startNy: startNy,
                      endNx: endNx,
                      endNy: endNy,
                    );
                  },
                  child: Image.memory(
                    widget.bytes,
                    width: dw,
                    height: dh,
                    fit: BoxFit.fill,
                  ),
                ),
                ...widget.regions.asMap().entries.map((MapEntry<int, PlantRegionModel> e) {
                  final int idx = e.key;
                  final PlantRegionModel r = e.value;
                  final bool sel = idx == widget.selectedIndex;
                  return Positioned(
                    left: r.nx * dw,
                    top: r.ny * dh,
                    width: r.nw * dw,
                    height: r.nh * dh,
                    child: GestureDetector(
                      onTap: () => widget.onSelectRegion(idx),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: sel ? 3 : 2,
                          ),
                          color: Colors.white.withValues(alpha: sel ? 0.14 : 0.08),
                        ),
                        child: Text(
                          '${idx + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                if (liveRect != null)
                  Positioned.fromRect(
                    rect: liveRect,
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2.5),
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
