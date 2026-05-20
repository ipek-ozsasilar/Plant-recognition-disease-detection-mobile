import 'package:bitirme_mobile/core/enums/duration_enum.dart';
import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:flutter/material.dart';

/// Tarama sırasında animasyonlu yükleniyor görünümü (laser scan).
class ScanLoadingWidget extends StatefulWidget {
  const ScanLoadingWidget({
    required this.message,
    this.subtitle,
    super.key,
  });

  final String message;
  final String? subtitle;

  @override
  State<ScanLoadingWidget> createState() => _ScanLoadingWidgetState();
}

class _ScanLoadingWidgetState extends State<ScanLoadingWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: DurationEnum.scanLaserCycle.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;
    final double box = ImageSizesEnum.hero.value * 0.9;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: WidgetSizesEnum.maxContentWidth.value),
        child: SoftElevationCard(
          onTap: null,
          padding: EdgeInsets.all(pad),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: box,
                height: box,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(WidgetSizesEnum.cardRadius.value),
                  child: AnimatedBuilder(
                    animation: _c,
                    builder: (BuildContext context, Widget? child) {
                      final double t = _c.value;
                      final double y = (t * box);
                      return Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  context.palPrimary.withValues(alpha: 0.10),
                                  context.palAccent.withValues(alpha: 0.14),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Icon(
                              Icons.eco_rounded,
                              size: ImageSizesEnum.hero.value * 0.55,
                              color: context.palPrimary,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: y - (WidgetSizesEnum.divider.value * 20),
                            child: Container(
                              height: WidgetSizesEnum.divider.value * 10,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: <Color>[
                                    Colors.transparent,
                                    context.palAccent.withValues(alpha: 0.65),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: context.palOutline.withValues(alpha: 0.45),
                                ),
                                borderRadius:
                                    BorderRadius.circular(WidgetSizesEnum.cardRadius.value),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value),
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: tt.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: context.palOnSurface,
                ),
              ),
              if (widget.subtitle != null && widget.subtitle!.isNotEmpty) ...<Widget>[
                SizedBox(height: WidgetSizesEnum.divider.value * 8),
                Text(
                  widget.subtitle!,
                  textAlign: TextAlign.center,
                  style: tt.bodyMedium?.copyWith(
                    color: context.palMuted,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ],
              SizedBox(height: WidgetSizesEnum.divider.value * 10),
              Text(
                context.l10n.loading,
                style: tt.bodySmall?.copyWith(
                  color: context.palMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

