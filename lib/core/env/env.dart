import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'API_BASE_URL', defaultValue: 'http://127.0.0.1:8000')
  static const String apiBaseUrl = _Env.apiBaseUrl;

  @EnviedField(varName: 'USE_MOCK_INFERENCE', defaultValue: 'false')
  static const String useMockInferenceRaw = _Env.useMockInferenceRaw;

  /// Mock kapalıyken: `true` → yerel TFLite (`assets/ml/`); `false` → HTTP API (`API_BASE_URL`).
  @EnviedField(varName: 'USE_LOCAL_TFLITE', defaultValue: 'true')
  static const String useLocalTfliteRaw = _Env.useLocalTfliteRaw;

  /// Firebase Console → Proje ayarları → Genel → Web uygulaması OAuth istemci kimliği
  @EnviedField(varName: 'GOOGLE_WEB_CLIENT_ID', defaultValue: '')
  static const String googleWebClientId = _Env.googleWebClientId;

  /// OpenAI — günün ipucu (`bitirme_mobile/.env`, git'e girmez).
  @EnviedField(varName: 'OPENAI_API_KEY', defaultValue: '')
  static const String openAiApiKey = _Env.openAiApiKey;

  @EnviedField(varName: 'OPENAI_MODEL', defaultValue: 'gpt-4o-mini')
  static const String openAiModel = _Env.openAiModel;

  /// `true` → günün ipucu OpenAI ile üretilir.
  @EnviedField(varName: 'USE_AI_DAILY_TIP', defaultValue: 'true')
  static const String useAiDailyTipRaw = _Env.useAiDailyTipRaw;

  /// `true` → OpenAI yerine yerel mock ipucu (test).
  @EnviedField(varName: 'USE_MOCK_DAILY_TIP', defaultValue: 'false')
  static const String useMockDailyTipRaw = _Env.useMockDailyTipRaw;

  static bool get useMockInference => useMockInferenceRaw.toLowerCase() == 'true';

  static bool get useLocalTflite => useLocalTfliteRaw.toLowerCase() == 'true';

  static bool get useAiDailyTip => useAiDailyTipRaw.toLowerCase() == 'true';

  static bool get useMockDailyTip => useMockDailyTipRaw.toLowerCase() == 'true';
}
