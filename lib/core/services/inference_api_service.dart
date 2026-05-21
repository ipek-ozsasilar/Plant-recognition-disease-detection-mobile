import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:bitirme_mobile/core/env/env.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:bitirme_mobile/core/utils/confidence_format.dart';
import 'package:bitirme_mobile/core/services/tflite_plant_inference_service.dart';
import 'package:bitirme_mobile/models/inference_result_model.dart';
import 'package:http/http.dart' as http;

/// Bitki türü ve hastalık tahmini: mock, yerel TFLite veya HTTP API.
class InferenceApiService {
  InferenceApiService({
    required AppLogger logger,
    required TflitePlantInferenceService tflite,
  }) : _logger = logger,
       _tflite = tflite;

  final AppLogger _logger;
  final TflitePlantInferenceService _tflite;
  final Random _random = Random();

  static const List<String> _mockSpecies = <String>[
    'Domates',
    'Biber',
    'Patlıcan',
    'Salatalık',
    'Marul',
    'Çilek',
    'Gül',
    'Lavanta',
  ];

  static const List<String> _mockDiseaseKeys = <String>[
    'healthy',
    'leaf_disease',
    'mold',
    'pest_damage',
    'powdery_mildew',
    'rot',
    'rust',
  ];

  Future<InferenceResultModel> predictSpecies(Uint8List imageBytes) async {
    if (Env.useMockInference) {
      return _mockResult(_mockSpecies);
    }
    if (Env.useLocalTflite && !kIsWeb) {
      try {
        return await _tflite.predictSpecies(imageBytes);
      } catch (e, st) {
        _logger.e('inference_tflite_species', e, st);
        rethrow;
      }
    }
    if (kIsWeb && Env.useLocalTflite) {
      _logger.w('Web: TFLite atlandı, HTTP/mock kullanılıyor.');
    }
    try {
      final Uri uri = Uri.parse('${Env.apiBaseUrl}/predict/species');
      final http.MultipartRequest request = http.MultipartRequest('POST', uri);
      request.files.add(
        http.MultipartFile.fromBytes('file', imageBytes, filename: 'crop.jpg'),
      );
      final http.StreamedResponse streamed = await request.send();
      final String body = await streamed.stream.bytesToString();
      if (streamed.statusCode >= 200 && streamed.statusCode < 300) {
        return _parseInferenceJson(body);
      }
      throw Exception('HTTP ${streamed.statusCode}');
    } catch (e, st) {
      _logger.e('inference_http_species', e, st);
      rethrow;
    }
  }

  Future<InferenceResultModel> predictDisease(Uint8List imageBytes) async {
    if (Env.useMockInference) {
      return _mockResult(_mockDiseaseKeys);
    }
    if (Env.useLocalTflite && !kIsWeb) {
      try {
        return await _tflite.predictDisease(imageBytes);
      } catch (e, st) {
        _logger.e('inference_tflite_disease', e, st);
        rethrow;
      }
    }
    if (kIsWeb && Env.useLocalTflite) {
      _logger.w('Web: TFLite atlandı, HTTP/mock kullanılıyor.');
    }
    try {
      final Uri uri = Uri.parse('${Env.apiBaseUrl}/predict/disease');
      final http.MultipartRequest request = http.MultipartRequest('POST', uri);
      request.files.add(
        http.MultipartFile.fromBytes('file', imageBytes, filename: 'crop.jpg'),
      );
      final http.StreamedResponse streamed = await request.send();
      final String body = await streamed.stream.bytesToString();
      if (streamed.statusCode >= 200 && streamed.statusCode < 300) {
        return _parseInferenceJson(body);
      }
      throw Exception('HTTP ${streamed.statusCode}');
    } catch (e, st) {
      _logger.e('inference_http_disease', e, st);
      rethrow;
    }
  }

  InferenceResultModel _mockResult(List<String> labels) {
    final int topIdx = _random.nextInt(labels.length);
    final String topLabel = labels[topIdx];
    final double topConf = 0.55 + _random.nextDouble() * 0.44;
    final List<InferenceClassScoreModel> alt = <InferenceClassScoreModel>[];
    for (int i = 0; i < labels.length && i < 4; i++) {
      if (i == topIdx) {
        continue;
      }
      alt.add(
        InferenceClassScoreModel(
          label: labels[i],
          confidence: _random.nextDouble() * 0.4,
          rawKey: labels[i],
        ),
      );
    }
    return InferenceResultModel(
      top: InferenceClassScoreModel(
        label: topLabel,
        confidence: topConf,
        rawKey: topLabel,
      ),
      alternatives: alt,
    );
  }

  InferenceResultModel _parseInferenceJson(String body) {
    final Object? decoded = json.decode(body);
    if (decoded is! Map<String, Object?>) {
      throw FormatException('Invalid JSON', body);
    }
    final String? topLabel =
        decoded['label'] as String? ?? decoded['top_label'] as String?;
    final num? topConf =
        decoded['confidence'] as num? ?? decoded['score'] as num?;
    if (topLabel == null || topConf == null) {
      throw FormatException('Missing fields', body);
    }
    final String? rawLabel =
        decoded['raw_label'] as String? ?? decoded['raw'] as String?;
    return InferenceResultModel(
      top: InferenceClassScoreModel(
        label: topLabel,
        confidence: confidenceToUnit(topConf),
        rawKey: rawLabel ?? topLabel,
      ),
    );
  }
}
