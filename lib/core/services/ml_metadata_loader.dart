import 'dart:convert';

import 'package:bitirme_mobile/core/enums/ml_assets_enum.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/core/services/plantnet_species_name_repository.dart';
import 'package:bitirme_mobile/core/services/sink_species_class_repository.dart';
import 'package:flutter/services.dart';

/// PlantNet haritası ve sink sınıf listesini asset'ten yükler (tarama öncesi isimler için).
final class MlMetadataLoader {
  MlMetadataLoader({
    required AppLogger logger,
    required PlantnetSpeciesNameRepository plantnetNames,
    required SinkSpeciesClassRepository sinkSpeciesClasses,
  })  : _logger = logger,
        _plantnetNames = plantnetNames,
        _sinkSpeciesClasses = sinkSpeciesClasses;

  final AppLogger _logger;
  final PlantnetSpeciesNameRepository _plantnetNames;
  final SinkSpeciesClassRepository _sinkSpeciesClasses;

  Future<void>? _loadFuture;
  List<String> _diseaseClassKeys = <String>[];

  List<String> get diseaseClassKeys => List<String>.unmodifiable(_diseaseClassKeys);

  Future<void> ensureLoaded() {
    _loadFuture ??= _load();
    return _loadFuture!;
  }

  Future<void> _load() async {
    try {
      final String mapJson =
          await rootBundle.loadString(MlAssetsEnum.plantnetSpeciesIdMapJson.value);
      final Object? mapDec = json.decode(mapJson);
      if (mapDec is Map<String, dynamic>) {
        _plantnetNames.setFromJson(mapDec);
      }
    } catch (e, st) {
      _logger.w('PlantNet ID haritası yüklenemedi', e, st);
    }
    try {
      final String sinkJson =
          await rootBundle.loadString(MlAssetsEnum.sinkSpeciesClassesJson.value);
      final Object? sinkDec = json.decode(sinkJson);
      if (sinkDec is List<dynamic>) {
        _sinkSpeciesClasses.setFromJsonList(sinkDec);
      }
    } catch (e, st) {
      _logger.w('Sink sınıf listesi yüklenemedi', e, st);
    }
    try {
      final String diseaseJson =
          await rootBundle.loadString(MlAssetsEnum.diseaseLabelsJson.value);
      final Object? dsDec = json.decode(diseaseJson);
      if (dsDec is List<dynamic>) {
        _diseaseClassKeys = dsDec.map((dynamic e) => e.toString()).toList();
      }
    } catch (e, st) {
      _logger.w('Hastalık sınıf listesi yüklenemedi', e, st);
    }
  }
}
