import 'package:bitirme_mobile/core/constants/preference_keys.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Günün ipucu AI yanıtını takvim gününe göre önbelleğe alır (gece 00:00 sonrası yenilenir).
class DailyTipCacheService {
  DailyTipCacheService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;

  /// Aynı gün + dil için önbellek geçerli mi (yeni tarama olsa bile tekrar AI çağrılmaz).
  Future<String?> readForToday({required String localeCode}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? day = prefs.getString(PreferenceKeys.dailyTipCacheDay);
      final String? locale = prefs.getString(PreferenceKeys.dailyTipCacheLocale);
      final String? body = prefs.getString(PreferenceKeys.dailyTipCacheBody);
      final String today = _todayKey();
      if (day == today &&
          locale == localeCode &&
          body != null &&
          body.trim().isNotEmpty) {
        return body.trim();
      }
      return null;
    } catch (e, st) {
      _logger.e('daily_tip_cache_read', e, st);
      return null;
    }
  }

  Future<void> writeForToday({
    required String localeCode,
    required String body,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(PreferenceKeys.dailyTipCacheDay, _todayKey());
      await prefs.setString(PreferenceKeys.dailyTipCacheLocale, localeCode);
      await prefs.setString(PreferenceKeys.dailyTipCacheBody, body.trim());
    } catch (e, st) {
      _logger.e('daily_tip_cache_write', e, st);
    }
  }

  /// Yerel saatte bir sonraki gece 00:00'a kadar bekleme süresi.
  Duration timeUntilNextMidnight() {
    final DateTime now = DateTime.now();
    final DateTime nextMidnight = DateTime(now.year, now.month, now.day + 1);
    return nextMidnight.difference(now);
  }

  String _todayKey() => DateFormat('yyyyMMdd').format(DateTime.now());
}
