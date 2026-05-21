import 'dart:convert';
import 'dart:math';
import 'package:bitirme_mobile/core/enums/ml_assets_enum.dart';
import 'package:bitirme_mobile/core/enums/ml_preprocess_enum.dart';
import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/core/services/plantnet_species_name_repository.dart';
import 'package:bitirme_mobile/core/services/sink_species_class_repository.dart';
import 'package:bitirme_mobile/core/services/species_label_formatter.dart';
import 'package:bitirme_mobile/models/inference_result_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

/// Yerel tür (`MlAssetsEnum.speciesModel`) ve hastalık (`MlAssetsEnum.diseaseModel`) TFLite çıkarımı.
class TflitePlantInferenceService {
  TflitePlantInferenceService({
    required AppLogger logger,
    required PlantnetSpeciesNameRepository plantnetNames,
    required SinkSpeciesClassRepository sinkSpeciesClasses,
  })  : _logger = logger,
        _plantnetNames = plantnetNames,
        _sinkSpeciesClasses = sinkSpeciesClasses;

  final AppLogger _logger;
  final PlantnetSpeciesNameRepository _plantnetNames;
  final SinkSpeciesClassRepository _sinkSpeciesClasses;
  Interpreter? _speciesInterpreter;
  Interpreter? _diseaseInterpreter;
  List<String>? _speciesLabels;
  List<String>? _diseaseLabels;
  Future<void>? _initFuture;

  Future<void> _ensureReady() async {
    _initFuture ??= _loadAll();
    await _initFuture;
  }

  Future<void> _loadAll() async {
    try {
      final String speciesJson = await rootBundle.loadString(MlAssetsEnum.speciesLabelsJson.value);
      final String diseaseJson = await rootBundle.loadString(MlAssetsEnum.diseaseLabelsJson.value);
      final Object? spDec = json.decode(speciesJson);
      final Object? dsDec = json.decode(diseaseJson);
      if (spDec is! List<dynamic> || dsDec is! List<dynamic>) {
        throw const FormatException('Sınıf JSON beklenen formatta değil.');
      }
      _speciesLabels = spDec.map((dynamic e) => e.toString()).toList();
      _diseaseLabels = dsDec.map((dynamic e) => e.toString()).toList();

      final InterpreterOptions opts = InterpreterOptions()..threads = 4;
      _speciesInterpreter = await Interpreter.fromAsset(
        MlAssetsEnum.speciesModel.value,
        options: opts,
      );
      _diseaseInterpreter = await Interpreter.fromAsset(
        MlAssetsEnum.diseaseModel.value,
        options: opts,
      );
      try {
        final String mapJson = await rootBundle.loadString(MlAssetsEnum.plantnetSpeciesIdMapJson.value);
        final Object? mapDec = json.decode(mapJson);
        if (mapDec is Map<String, dynamic>) {
          _plantnetNames.setFromJson(mapDec);
        }
      } catch (e, st) {
        _logger.w('PlantNet ID haritası yüklenemedi (isteğe bağlı)', e, st);
      }
      try {
        final String sinkJson = await rootBundle.loadString(MlAssetsEnum.sinkSpeciesClassesJson.value);
        final Object? sinkDec = json.decode(sinkJson);
        if (sinkDec is List<dynamic>) {
          _sinkSpeciesClasses.setFromJsonList(sinkDec);
        }
      } catch (e, st) {
        _logger.w('Sink sınıf listesi yüklenemedi (isteğe bağlı)', e, st);
      }
      _logger.d(
        'TFLite yüklendi — species: ${MlAssetsEnum.speciesModel.value}, '
        'disease: ${MlAssetsEnum.diseaseModel.value}',
      );
    } catch (e, st) {
      _logger.e('TFLite yükleme', e, st);
      rethrow;
    }
  }

  MlPreprocessEnum _preprocessFor(MlAssetsEnum model) {
    // DEBUG: raw0to255 test — model içinde preprocess varsa bu doğru
    return MlPreprocessEnum.raw0to255;
  }

  int _fallbackSquareFor(MlAssetsEnum model) {
    // Tür modelin leafsnap/efficientnet tabanlı ise 300 yaygın.
    // Çoğu tflite modelde ise 224.
    if (model == MlAssetsEnum.speciesModel) {
      return MlInputSizesEnum.efficientNetB3.asInt;
    }
    return MlInputSizesEnum.defaultSquare.asInt;
  }

  Future<InferenceResultModel> predictSpecies(Uint8List imageBytes) async {
    await _ensureReady();
    final Interpreter i = _speciesInterpreter!;
    final List<String> labels = _speciesLabels!;
    return _runClassification(
      interpreter: i,
      rawLabels: labels,
      imageBytes: imageBytes,
      formatLabel: (String raw) =>
          formatSpeciesRawLabel(raw, plantnetMap: _plantnetNames.snapshot),
      preprocess: _preprocessFor(MlAssetsEnum.speciesModel),
      fallbackSquare: _fallbackSquareFor(MlAssetsEnum.speciesModel),
      attachRawKey: true,
    );
  }

  Future<InferenceResultModel> predictDisease(Uint8List imageBytes) async {
    await _ensureReady();
    final Interpreter i = _diseaseInterpreter!;
    final List<String> labels = _diseaseLabels!;
    return _runClassification(
      interpreter: i,
      rawLabels: labels,
      imageBytes: imageBytes,
      formatLabel: (String raw) => raw,
      preprocess: _preprocessFor(MlAssetsEnum.diseaseModel),
      fallbackSquare: _fallbackSquareFor(MlAssetsEnum.diseaseModel),
      attachRawKey: true,
    );
  }

  InferenceResultModel _runClassification({
    required Interpreter interpreter,
    required List<String> rawLabels,
    required Uint8List imageBytes,
    required String Function(String raw) formatLabel,
    required MlPreprocessEnum preprocess,
    required int fallbackSquare,
    bool attachRawKey = false,
  }) {
    final img.Image? decoded = img.decodeImage(imageBytes);
    if (decoded == null) {
      throw FormatException('Görüntü çözülemedi.');
    }

    final Tensor inputTensor = interpreter.getInputTensor(0);
    // Geçici doğrulama: konsolda [1, 300, 300, 3] ve MlPreprocessEnum.raw0to255 beklenir.
    final List<int> inputShape = List<int>.from(inputTensor.shape);
    debugPrint('>>> Input shape: $inputShape');
    debugPrint('>>> Preprocess mode: $preprocess');
    final Tensor outputTensor = interpreter.getOutputTensor(0);
    final List<int> inShape = List<int>.from(inputTensor.shape);
    for (int i = 0; i < inShape.length; i++) {
      if (inShape[i] < 0) {
        inShape[i] = fallbackSquare;
      }
    }
    final List<int> outShape = List<int>.from(outputTensor.shape);
    final TensorType inType = inputTensor.type;

    final int? h = _spatialSize(inShape, isHeight: true);
    final int? w = _spatialSize(inShape, isHeight: false);
    if (h == null || w == null) {
      throw StateError('Model giriş şekli desteklenmiyor: $inShape');
    }

    final img.Image resized = img.copyResize(decoded, width: w, height: h, interpolation: img.Interpolation.linear);
    final Object input = _buildInputNesting(
      shape: inShape,
      image: resized,
      tensorType: inType,
      preprocess: preprocess,
    );

    final Object output = _allocOutputBuffer(outShape, outputTensor.type);
    interpreter.run(input, output);

    List<double> scores = _flattenOutput(output, outShape);
    if (scores.isEmpty) {
      throw StateError('Model çıktısı boş.');
    }

    if (!_looksLikeProbabilities(scores)) {
      scores = _softmax(scores);
    }

    final int n = min(rawLabels.length, scores.length);
    if (rawLabels.length != scores.length) {
      _logger.w(
        'Sınıf sayısı (${rawLabels.length}) ile çıktı boyutu (${scores.length}) farklı; ilk $n eşleştiriliyor.',
      );
    }

    final List<int> order = List<int>.generate(n, (int i) => i);
    order.sort((int a, int b) => scores[b].compareTo(scores[a]));

    final int topIdx = order.first;
    final String rawTop = rawLabels[topIdx];
    final InferenceClassScoreModel top = InferenceClassScoreModel(
      label: formatLabel(rawTop),
      confidence: scores[topIdx].clamp(0.0, 1.0),
      rawKey: attachRawKey ? rawTop : null,
    );

    final List<InferenceClassScoreModel> alternatives = <InferenceClassScoreModel>[];
    for (int k = 1; k < order.length && alternatives.length < 4; k++) {
      final int idx = order[k];
      final String rawAlt = rawLabels[idx];
      alternatives.add(
        InferenceClassScoreModel(
          label: formatLabel(rawAlt),
          confidence: scores[idx].clamp(0.0, 1.0),
          rawKey: attachRawKey ? rawAlt : null,
        ),
      );
    }

    // DEBUG: top-5 sonuçları konsola yaz
    debugPrint('>>> TOP: ${top.label} (${(top.confidence * 100).toStringAsFixed(1)}%) rawKey=${top.rawKey}');
    for (int k = 0; k < alternatives.length; k++) {
      final InferenceClassScoreModel alt = alternatives[k];
      debugPrint('>>> ALT ${k + 1}: ${alt.label} (${(alt.confidence * 100).toStringAsFixed(1)}%) rawKey=${alt.rawKey}');
    }

    return InferenceResultModel(top: top, alternatives: alternatives);
  }

  static int? _spatialSize(List<int> shape, {required bool isHeight}) {
    if (shape.length == 4) {
      if (shape[1] == 3 || shape[1] == 1) {
        return isHeight ? _positiveOrNull(shape[2]) : _positiveOrNull(shape[3]);
      }
      if (shape[3] == 3 || shape[3] == 1) {
        return isHeight ? _positiveOrNull(shape[1]) : _positiveOrNull(shape[2]);
      }
    }
    return null;
  }

  static int? _positiveOrNull(int v) {
    if (v <= 0) {
      return null;
    }
    return v;
  }

  Object _buildInputNesting({
    required List<int> shape,
    required img.Image image,
    required TensorType tensorType,
    required MlPreprocessEnum preprocess,
  }) {
    if (shape.length != 4) {
      throw StateError('4 boyutlu giriş bekleniyordu: $shape');
    }
    final bool nchw = shape[1] == 3 || shape[1] == 1;
    final int h = nchw ? shape[2] : shape[1];
    final int w = nchw ? shape[3] : shape[2];
    final bool useFloat = tensorType == TensorType.float32;
    final bool useUint8 = tensorType == TensorType.uint8;
    final bool useInt8 = tensorType == TensorType.int8;

    if (!useFloat && !useUint8 && !useInt8) {
      throw StateError('Desteklenmeyen input tensor type: $tensorType');
    }

    num packCh(num v) {
      final double x = v.toDouble().clamp(0.0, 255.0);
      if (!useFloat) {
        // Quantized input: uint8/int8
        if (useUint8) {
          return x.round().clamp(0, 255);
        }
        // int8: [-128, 127] aralığı
        return (x.round() - 128).clamp(-128, 127);
      }
      if (preprocess == MlPreprocessEnum.raw0to255) {
        return x;
      }
      if (preprocess == MlPreprocessEnum.minus1to1) {
        return ((x - 127.5) / 127.5).clamp(-1.0, 1.0);
      }
      // unit0to1
      return (x / 255.0).clamp(0.0, 1.0);
    }

    if (nchw && shape[1] == 1) {
      return List<List<List<List<num>>>>.generate(
        1,
        (_) => List<List<List<num>>>.generate(
          1,
          (_) => List<List<num>>.generate(
            h,
            (int y) => List<num>.generate(
              w,
              (int x) {
                final dynamic px = image.getPixel(x, y);
                final double g = (px.r + px.g + px.b) / 3.0;
                return packCh(g);
              },
            ),
          ),
        ),
      );
    }

    if (nchw) {
      return List<List<List<List<num>>>>.generate(
        1,
        (_) => List<List<List<num>>>.generate(
          3,
          (int c) => List<List<num>>.generate(
            h,
            (int y) => List<num>.generate(
              w,
              (int x) {
                final dynamic px = image.getPixel(x, y);
                final num r = px.r;
                final num g = px.g;
                final num b = px.b;
                if (c == 0) {
                  return packCh(r);
                }
                if (c == 1) {
                  return packCh(g);
                }
                return packCh(b);
              },
            ),
          ),
        ),
      );
    }

    return List<List<List<List<num>>>>.generate(
      1,
      (_) => List<List<List<num>>>.generate(
        h,
        (int y) => List<List<num>>.generate(
          w,
          (int x) {
            final dynamic px = image.getPixel(x, y);
            return <num>[
              packCh(px.r),
              packCh(px.g),
              packCh(px.b),
            ];
          },
        ),
      ),
    );
  }

  Object _allocOutputBuffer(List<int> shape, TensorType type) {
    final bool isFloat = type == TensorType.float32;
    final bool isUint8 = type == TensorType.uint8;
    final bool isInt8 = type == TensorType.int8;
    if (!isFloat && !isUint8 && !isInt8) {
      throw StateError('Desteklenmeyen output tensor type: $type');
    }

    if (shape.length == 2) {
      final int a = shape[0] < 1 ? 1 : shape[0];
      final int b = shape[1];
      if (isFloat) {
        return List<List<double>>.generate(a, (_) => List<double>.filled(b, 0.0));
      }
      return List<List<int>>.generate(a, (_) => List<int>.filled(b, 0));
    }
    if (shape.length == 1) {
      if (isFloat) {
        return List<double>.filled(shape[0], 0.0);
      }
      return List<int>.filled(shape[0], 0);
    }
    throw StateError('Çıktı şekli desteklenmiyor: $shape');
  }

  List<double> _flattenOutput(Object output, List<int> shape) {
    if (shape.length == 2) {
      final List<dynamic> row = (output as List<dynamic>)[0] as List<dynamic>;
      return row.map((dynamic e) => (e as num).toDouble()).toList();
    }
    if (shape.length == 1) {
      final List<dynamic> row = output as List<dynamic>;
      return row.map((dynamic e) => (e as num).toDouble()).toList();
    }
    return <double>[];
  }

  bool _looksLikeProbabilities(List<double> s) {
    if (s.isEmpty) {
      return false;
    }
    final double sum = s.fold<double>(0, (double a, double b) => a + b);
    if ((sum - 1.0).abs() > 0.08) {
      return false;
    }
    for (final double e in s) {
      if (e < -0.01 || e > 1.01) {
        return false;
      }
    }
    return true;
  }

  List<double> _softmax(List<double> logits) {
    if (logits.isEmpty) {
      return logits;
    }
    final double m = logits.reduce(max);
    final List<double> ex = logits.map((double e) => exp(e - m)).toList();
    final double s = ex.fold<double>(0, (double a, double b) => a + b);
    if (s <= 0) {
      return logits;
    }
    return ex.map((double e) => e / s).toList();
  }

  void close() {
    _speciesInterpreter?.close();
    _diseaseInterpreter?.close();
    _speciesInterpreter = null;
    _diseaseInterpreter = null;
    _initFuture = null;
  }
}
