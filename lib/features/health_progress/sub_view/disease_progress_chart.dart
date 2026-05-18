import 'package:bitirme_mobile/core/enums/chart_window_enum.dart';
import 'package:bitirme_mobile/core/enums/disease_class_chart_enum.dart';
import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:bitirme_mobile/l10n/app_localizations.dart';
import 'package:bitirme_mobile/models/plant_scan_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Son taramalarda hastalık sınıfını gün (X) × sınıf (Y) olarak gösterir.
class DiseaseProgressChart extends StatelessWidget {
  const DiseaseProgressChart({
    required this.scans,
    required this.primary,
    required this.accent,
    required this.outline,
    required this.muted,
    super.key,
  });

  final List<PlantScanModel> scans;
  final Color primary;
  final Color accent;
  final Color outline;
  final Color muted;

  static const ChartWindowEnum _window = ChartWindowEnum.healthProgress;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final String loc = Localizations.localeOf(context).languageCode;
    final DateFormat dayFmt = DateFormat.Md(loc);

    if (scans.isEmpty) {
      return Center(
        child: Text(
          l10n.healthProgressNoChartData,
          style: TextStyle(
            color: muted,
            fontWeight: FontWeight.w600,
            fontSize: TextSizesEnum.body.value,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    final List<PlantScanModel> sorted = List<PlantScanModel>.from(scans)
      ..sort(
        (PlantScanModel a, PlantScanModel b) => a.createdAt.compareTo(b.createdAt),
      );

    final DateTime windowEnd = DateTime.now();
    final DateTime windowStart =
        windowEnd.subtract(Duration(days: _window.days));
    final double maxX = _window.days.toDouble();

    final List<_ChartPoint> points = <_ChartPoint>[];
    for (final PlantScanModel scan in sorted) {
      if (scan.createdAt.isBefore(windowStart)) {
        continue;
      }
      final DiseaseClassChartEnum? disease = DiseaseClassChartEnum.forKey(scan.diseaseKey);
      if (disease == null) {
        continue;
      }
      final double x = scan.createdAt.difference(windowStart).inDays.toDouble();
      points.add(
        _ChartPoint(
          x: x.clamp(0, maxX),
          y: disease.chartY.toDouble(),
          dateLabel: dayFmt.format(scan.createdAt),
          color: disease.chartColor,
        ),
      );
    }

    if (points.isEmpty) {
      return Center(
        child: Text(
          l10n.healthProgressNoChartData,
          style: TextStyle(
            color: muted,
            fontWeight: FontWeight.w600,
            fontSize: TextSizesEnum.body.value,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    final List<FlSpot> spots =
        points.map((_ChartPoint p) => FlSpot(p.x, p.y)).toList(growable: false);

    final List<Color> lineGradient = <Color>[primary, accent, ColorName.gradientEnd];

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: maxX,
        minY: 0,
        maxY: 4,
        gridData: FlGridData(
          show: true,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (double value) => FlLine(
            color: outline.withValues(alpha: 0.4),
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (double value) => FlLine(
            color: outline.withValues(alpha: 0.22),
            strokeWidth: 1,
            dashArray: <int>[4, 4],
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: outline.withValues(alpha: 0.55)),
        ),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              reservedSize: WidgetSizesEnum.cardRadius.value * 3.2,
              getTitlesWidget: (double value, TitleMeta meta) {
                final int y = value.round();
                if (!DiseaseClassChartEnum.chartYTicks.contains(y)) {
                  return const SizedBox.shrink();
                }
                final String label = DiseaseClassChartEnum.labelForChartY(l10n, y);
                if (label.isEmpty) {
                  return const SizedBox.shrink();
                }
                final Color tickColor =
                    DiseaseClassChartEnum.forChartY(y)?.chartColor ?? muted;
                return Padding(
                  padding: EdgeInsets.only(right: WidgetSizesEnum.divider.value * 6),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: tickColor.withValues(alpha: 0.95),
                      fontSize: TextSizesEnum.caption.value * 0.9,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: WidgetSizesEnum.cardRadius.value * 1.15,
              interval: maxX / 2,
              getTitlesWidget: (double value, TitleMeta meta) {
                final int day = value.round();
                if (day != 0 && day != _window.days ~/ 2 && day != _window.days) {
                  return const SizedBox.shrink();
                }
                final DateTime labelDate = windowStart.add(Duration(days: day));
                return Padding(
                  padding: EdgeInsets.only(top: WidgetSizesEnum.divider.value * 8),
                  child: Text(
                    dayFmt.format(labelDate),
                    style: TextStyle(
                      color: muted,
                      fontSize: TextSizesEnum.caption.value,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => ColorName.surfaceCard.withValues(alpha: 0.96),
            getTooltipItems: (List<LineBarSpot> touched) {
              return touched.map((LineBarSpot spot) {
                final int index = spot.spotIndex;
                if (index < 0 || index >= points.length) {
                  return null;
                }
                final _ChartPoint p = points[index];
                final String diseaseLabel =
                    DiseaseClassChartEnum.labelForChartY(l10n, p.y.round());
                return LineTooltipItem(
                  '${p.dateLabel}\n$diseaseLabel',
                  TextStyle(
                    color: p.color,
                    fontWeight: FontWeight.w800,
                    fontSize: TextSizesEnum.caption.value,
                  ),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: <LineChartBarData>[
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.28,
            gradient: LinearGradient(colors: lineGradient),
            barWidth: 3.5,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  primary.withValues(alpha: 0.35),
                  accent.withValues(alpha: 0.12),
                  Colors.transparent,
                ],
              ),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (
                FlSpot spot,
                double percent,
                LineChartBarData bar,
                int index,
              ) {
                final Color dotColor = points[index].color;
                return FlDotCirclePainter(
                  radius: 5,
                  color: dotColor,
                  strokeWidth: 2.5,
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }
}

final class _ChartPoint {
  const _ChartPoint({
    required this.x,
    required this.y,
    required this.dateLabel,
    required this.color,
  });

  final double x;
  final double y;
  final String dateLabel;
  final Color color;
}
