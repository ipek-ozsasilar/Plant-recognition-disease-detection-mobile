import 'dart:typed_data';

import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/core/services/plantnet_species_name_repository.dart';
import 'package:bitirme_mobile/core/services/sink_species_class_repository.dart';
import 'package:bitirme_mobile/models/inference_result_model.dart';

/// Web / wasm: TFLite FFI desteklenmez; yerel model çalıştırılmaz.
class TflitePlantInferenceService {
  TflitePlantInferenceService({
    required AppLogger logger,
    required PlantnetSpeciesNameRepository plantnetNames,
    required SinkSpeciesClassRepository sinkSpeciesClasses,
  }) : _logger = logger;

  final AppLogger _logger;

  static const String _unsupportedMessage =
      'Yerel TFLite yalnızca Android/iOS/masaüstünde çalışır. '
      'Chrome yerine emülatör/cihazda çalıştırın veya .env içinde '
      'USE_LOCAL_TFLITE=false ve API_BASE_URL ayarlayın.';

  Future<void> _ensureReady() async {
    _logger.w(_unsupportedMessage);
  }

  Future<InferenceResultModel> predictSpecies(Uint8List imageBytes) async {
    await _ensureReady();
    throw UnsupportedError(_unsupportedMessage);
  }

  Future<InferenceResultModel> predictDisease(Uint8List imageBytes) async {
    await _ensureReady();
    throw UnsupportedError(_unsupportedMessage);
  }

  void close() {}
}
