import 'package:bitirme_mobile/core/enums/inference_threshold_enum.dart';
import 'package:bitirme_mobile/core/services/disease_label_display.dart';
import 'package:bitirme_mobile/core/services/sink_species_class_repository.dart';
import 'package:bitirme_mobile/core/utils/confidence_format.dart';
import 'package:bitirme_mobile/models/inference_result_model.dart';
import 'package:bitirme_mobile/models/plant_region_model.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:equatable/equatable.dart';

/// Tek bölge için tür (+ isteğe bağlı hastalık) çıktısı.
class ScanRegionAnalysis extends Equatable {
  const ScanRegionAnalysis({
    required this.regionIndex,
    required this.region,
    required this.species,
    this.disease,
  });

  final int regionIndex;
  final PlantRegionModel region;
  final InferenceResultModel species;
  final InferenceResultModel? disease;

  bool get hasDisease => disease != null;

  bool get speciesUnrecognized {
    final double unit = confidenceToUnit(species.top.confidence);
    final String raw = (species.top.rawKey ?? species.top.label).trim();
    final bool isSink = sl<SinkSpeciesClassRepository>().snapshot.contains(raw);
    return isSink
        ? unit < InferenceThresholdEnum.unrecognizedSink.value
        : unit < InferenceThresholdEnum.unrecognizedGlobal.value;
  }

  bool get diseaseUnrecognized {
    if (disease == null) {
      return true;
    }
    return isDiseaseInferenceUnrecognized(disease!);
  }

  /// Özet ekranında hastalık da tamamlandıktan sonra kayıt mümkün.
  bool get canSaveToHistory => !speciesUnrecognized && hasDisease;

  ScanRegionAnalysis copyWithDisease(InferenceResultModel diseaseResult) {
    return ScanRegionAnalysis(
      regionIndex: regionIndex,
      region: region,
      species: species,
      disease: diseaseResult,
    );
  }

  @override
  List<Object?> get props => <Object?>[regionIndex, region, species, disease];
}
