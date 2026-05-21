import 'package:bitirme_mobile/core/locale/species_class_display.dart';
import 'package:bitirme_mobile/models/plant_region_model.dart';
import 'package:bitirme_mobile/models/plant_scan_model.dart';
import 'package:flutter/material.dart';

/// Taramaları bitki türü etiketine göre gruplar.
Map<String, List<PlantScanModel>> groupScansBySpeciesLabel(
  List<PlantScanModel> scans,
) {
  final Map<String, List<PlantScanModel>> grouped = <String, List<PlantScanModel>>{};
  for (final PlantScanModel scan in scans) {
    final String key = scan.speciesLabel.trim();
    if (key.isEmpty) {
      continue;
    }
    grouped.putIfAbsent(key, () => <PlantScanModel>[]).add(scan);
  }
  for (final List<PlantScanModel> list in grouped.values) {
    list.sort(
      (PlantScanModel a, PlantScanModel b) => b.createdAt.compareTo(a.createdAt),
    );
  }
  return grouped;
}

/// Tür adına göre alfabetik sıralı etiket listesi.
List<String> sortedSpeciesLabelsFromGrouped(
  Map<String, List<PlantScanModel>> grouped,
  BuildContext context,
) {
  return grouped.keys.toList()
    ..sort(
      (String a, String b) => speciesClassDisplayForRaw(context, a)
          .compareTo(speciesClassDisplayForRaw(context, b)),
    );
}

String speciesScanGroupTitle({
  required BuildContext context,
  required String speciesLabel,
}) {
  return speciesClassDisplayForRaw(context, speciesLabel);
}

/// Geçmişte tam fotoğraf + çoklu bölge: yalnızca bu kaydın bölgesini çiz.
List<PlantRegionModel>? scanRegionsForDisplay(PlantScanModel scan) {
  final List<PlantRegionModel>? markers = scan.regionMarkers;
  if (markers == null || markers.isEmpty) {
    return null;
  }
  if (markers.length == 1) {
    return markers;
  }
  final int? idx = scan.regionIndex;
  if (idx != null && idx >= 0 && idx < markers.length) {
    return <PlantRegionModel>[markers[idx]];
  }
  return markers;
}
