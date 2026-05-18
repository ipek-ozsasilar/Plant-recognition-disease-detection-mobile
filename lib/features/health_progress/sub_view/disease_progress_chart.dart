import 'package:bitirme_mobile/core/enums/disease_class_chart_enum.dart';
import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
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
    required this.outline,
    required this.muted,
    super.key,
  });

  final List<PlantScanModel> scans;
  final Color primary;
  final Color outline;
  final Color muted;

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

    final DateTime windowStart =
        DateTime.now().subtract(const Duration(days: 14));
    final List<_ChartPoint> points = <_ChartPoint>[];
    for (final PlantScanModel scan in sorted) {
      if (scan.createdAt.isBefore(windowStart)) {
        continue;
      }
      final int? y = DiseaseClassChartEnum.chartYForKey(scan.diseaseKey);
      if (y == null) {
        continue;
      }
      final double x = scan.createdAt.difference(windowStart).inDays.toDouble();
      points.add(
        _ChartPoint(
          x: x,
          y: y.toDouble(),
          dateLabel: dayFmt.format(scan.createdAt),
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

    final double maxX = points.map((_ChartPoint p) => p.x).reduce(
          (double a, double b) => a > b ? a : b,
        );
    final List<FlSpot> spots =
        points.map((_ChartPoint p) => FlSpot(p.x, p.y)).toList(growable: false);

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: maxX < 1 ? 14 : maxX,
        minY: 0,
        maxY: 4,
        gridData: FlGridData(
          show: true,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (double value) => FlLine(
            color: outline.withValues(alpha: 0.35),
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (double value) => FlLine(
            color: outline.withValues(alpha: 0.18),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: outline.withValues(alpha: 0.5)),
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
                return Padding(
                  padding: EdgeInsets.only(right: WidgetSizesEnum.divider.value * 6),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: muted,
                      fontSize: TextSizesEnum.caption.value * 0.9,
                      fontWeight: FontWeight.w700,
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
              reservedSize: WidgetSizesEnum.cardRadius.value * 1.1,
              interval: maxX < 4 ? 1 : 2,
              getTitlesWidget: (double value, TitleMeta meta) {
                _ChartPoint? match;
                for (final _ChartPoint p in points) {
                  if ((p.x - value).abs() < 0.5) {
                    match = p;
                    break;
                  }
                }
                if (match == null) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: EdgeInsets.only(top: WidgetSizesEnum.divider.value * 8),
                  child: Text(
                    match.dateLabel,
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
        lineBarsData: <LineChartBarData>[
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.2,
            color: primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (
                FlSpot spot,
                double percent,
                LineChartBarData bar,
                int index,
              ) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: primary,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }
}

final class _ChartPoint {
  const _ChartPoint({
    required this.x,
    required this.y,
    required this.dateLabel,
  });

  final double x;
  final double y;
  final String dateLabel;
}
