import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:bitirme_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Grafik Y ekseni: 5 sınıflık hastalık modeli sırası.
enum DiseaseClassChartEnum {
  blight('blight', 0),
  healthy('healthy', 4),
  mold('mold', 1),
  powderyMildew('powdery_mildew', 2),
  rust('rust', 3);

  const DiseaseClassChartEnum(this.key, this.chartY);
  final String key;
  final int chartY;

  static int? chartYForKey(String diseaseKey) {
    final String k = diseaseKey.trim().toLowerCase();
    for (final DiseaseClassChartEnum e in DiseaseClassChartEnum.values) {
      if (e.key == k) {
        return e.chartY;
      }
    }
    return null;
  }

  static DiseaseClassChartEnum? forKey(String diseaseKey) {
    final String k = diseaseKey.trim().toLowerCase();
    for (final DiseaseClassChartEnum e in DiseaseClassChartEnum.values) {
      if (e.key == k) {
        return e;
      }
    }
    return null;
  }

  Color get chartColor {
    switch (this) {
      case DiseaseClassChartEnum.blight:
        return ColorName.error;
      case DiseaseClassChartEnum.healthy:
        return ColorName.success;
      case DiseaseClassChartEnum.mold:
        return const Color(0xFF6B4E9E);
      case DiseaseClassChartEnum.powderyMildew:
        return ColorName.warning;
      case DiseaseClassChartEnum.rust:
        return const Color(0xFFC45C2A);
    }
  }

  static DiseaseClassChartEnum? forChartY(int chartY) {
    for (final DiseaseClassChartEnum e in DiseaseClassChartEnum.values) {
      if (e.chartY == chartY) {
        return e;
      }
    }
    return null;
  }

  static String labelForChartY(AppLocalizations l10n, int chartY) {
    return forChartY(chartY)?.displayLabel(l10n) ?? '';
  }

  String displayLabel(AppLocalizations l10n) {
    switch (this) {
      case DiseaseClassChartEnum.blight:
        return l10n.inferenceDiseaseBlight;
      case DiseaseClassChartEnum.healthy:
        return l10n.inferenceDiseaseHealthy;
      case DiseaseClassChartEnum.mold:
        return l10n.inferenceDiseaseMold;
      case DiseaseClassChartEnum.powderyMildew:
        return l10n.inferenceDiseasePowderyMildew;
      case DiseaseClassChartEnum.rust:
        return l10n.inferenceDiseaseRust;
    }
  }

  static const List<int> chartYTicks = <int>[0, 1, 2, 3, 4];
}
