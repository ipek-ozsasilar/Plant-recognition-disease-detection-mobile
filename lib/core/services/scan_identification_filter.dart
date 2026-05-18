import 'package:bitirme_mobile/core/enums/inference_threshold_enum.dart';
import 'package:bitirme_mobile/core/services/sink_species_class_repository.dart';
import 'package:bitirme_mobile/models/plant_scan_model.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';

/// Geçmiş / grafik için: hem tür hem hastalık güvenilir şekilde tanınmış tarama.
bool isScanFullyIdentified(
  PlantScanModel scan, {
  required Set<String> knownDiseaseKeys,
}) {
  final String species = scan.speciesLabel.trim();
  final String disease = scan.diseaseKey.trim().toLowerCase();
  if (species.isEmpty || disease.isEmpty) {
    return false;
  }
  final String speciesLower = species.toLowerCase();
  if (speciesLower.contains('unknown') || disease.contains('unknown')) {
    return false;
  }
  if (!knownDiseaseKeys.contains(disease)) {
    return false;
  }

  final Set<String> sinkClasses = sl<SinkSpeciesClassRepository>().snapshot;
  final bool isSink = sinkClasses.contains(species);
  final double spUnit = scan.speciesConfidence;
  final double disUnit = scan.diseaseConfidence;
  final bool spUnrecognized = isSink
      ? spUnit < InferenceThresholdEnum.unrecognizedSink.value
      : spUnit < InferenceThresholdEnum.unrecognizedGlobal.value;
  final bool disUnrecognized =
      disUnit < InferenceThresholdEnum.unrecognizedGlobal.value;
  return !spUnrecognized && !disUnrecognized;
}

Set<String> knownDiseaseKeysFromList(List<String> keys) {
  return keys.map((String k) => k.trim().toLowerCase()).toSet();
}
