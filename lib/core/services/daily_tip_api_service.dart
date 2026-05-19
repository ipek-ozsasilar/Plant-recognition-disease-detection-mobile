import 'dart:convert';

import 'package:bitirme_mobile/core/env/env.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/core/services/daily_tip_cache_service.dart';
import 'package:bitirme_mobile/models/home_daily_tip_context_model.dart';
import 'package:http/http.dart' as http;

/// Günün ipucu: doğrudan OpenAI API (ayrı sunucu yok).
class DailyTipApiService {
  DailyTipApiService({
    required AppLogger logger,
    required DailyTipCacheService cache,
  })  : _logger = logger,
        _cache = cache;

  final AppLogger _logger;
  final DailyTipCacheService _cache;

  static const String _openAiChatUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String?> fetchTip({
    required String localeCode,
    required HomeDailyTipContextModel context,
  }) async {
    if (!Env.useAiDailyTip) {
      return null;
    }

    final String? cached = await _cache.readForToday(localeCode: localeCode);
    if (cached != null) {
      return cached;
    }

    if (Env.useMockDailyTip) {
      final String mock = _mockTip(localeCode: localeCode, context: context);
      await _cache.writeForToday(localeCode: localeCode, body: mock);
      return mock;
    }

    final String apiKey = Env.openAiApiKey.trim();
    if (apiKey.isEmpty) {
      _logger.w('daily_tip_openai_key_missing');
      return null;
    }

    try {
      final http.Response response = await http
          .post(
            Uri.parse(_openAiChatUrl),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $apiKey',
            },
            body: jsonEncode(<String, Object?>{
              'model': Env.openAiModel,
              'messages': _buildMessages(localeCode: localeCode, context: context),
              'max_tokens': 180,
              'temperature': 0.7,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        _logger.w('daily_tip_openai_status', response.statusCode);
        _logger.w('daily_tip_openai_body', response.body);
        return null;
      }

      final Object? decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }
      final List<dynamic>? choices = decoded['choices'] as List<dynamic>?;
      if (choices == null || choices.isEmpty) {
        return null;
      }
      final Object? first = choices.first;
      if (first is! Map<String, dynamic>) {
        return null;
      }
      final Map<String, dynamic>? message = first['message'] as Map<String, dynamic>?;
      final String? content = message?['content'] as String?;
      if (content == null || content.trim().isEmpty) {
        return null;
      }
      final String trimmed = content.trim();
      await _cache.writeForToday(localeCode: localeCode, body: trimmed);
      return trimmed;
    } catch (e, st) {
      _logger.e('daily_tip_openai', e, st);
      return null;
    }
  }

  List<Map<String, String>> _buildMessages({
    required String localeCode,
    required HomeDailyTipContextModel context,
  }) {
    final bool turkish = localeCode.toLowerCase().startsWith('tr');
    final String lang = turkish ? 'Turkish' : 'English';
    final String contextJson = jsonEncode(context.toApiJson());

    return <Map<String, String>>[
      <String, String>{
        'role': 'system',
        'content':
            'You are a concise home gardening assistant for a mobile plant health app. '
            'Reply in $lang only. Give one practical tip in 2-3 short sentences (max 280 characters). '
            'Base advice on the scan statistics provided. '
            'Do not mention AI, models, or JSON. No bullet lists.',
      },
      <String, String>{
        'role': 'user',
        'content':
            'User\'s last 5 days of plant scans (summary):\n$contextJson\n\n'
            'Write today\'s personalized care tip.',
      },
    ];
  }

  String _mockTip({
    required String localeCode,
    required HomeDailyTipContextModel context,
  }) {
    final String disease = context.dominantDiseaseKey ?? 'healthy';
    final String species = context.dominantSpeciesLabel ?? '';
    if (localeCode == 'en') {
      if (species.isNotEmpty) {
        return 'Based on your recent scans (${context.recentScanCount}), focus on '
            '$species: watch for $disease signs and adjust watering and airflow.';
      }
      return 'Based on your recent scans, keep monitoring leaves and maintain '
          'steady light and ventilation.';
    }
    if (species.isNotEmpty) {
      return 'Son ${context.recentScanCount} taramanıza göre $species için '
          '$disease riskine dikkat edin; sulama ve havalandırmayı gözden geçirin.';
    }
    return 'Son taramalarınıza göre yaprakları düzenli kontrol edin; '
        'ışık ve havalandırmayı dengede tutun.';
  }
}
