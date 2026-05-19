/// SharedPreferences anahtarları.
abstract final class PreferenceKeys {
  static const String languageSelectionDone = 'language_selection_done';
  static const String localeCode = 'app_locale_code';
  static const String notificationsEnabled = 'notifications_enabled';

  /// İlk ana sayfa girişinde sistem bildirim izni istendi mi.
  static const String notificationInitialPromptDone = 'notification_initial_prompt_done';

  static const String dailyTipCacheDay = 'daily_tip_cache_day';
  static const String dailyTipCacheLocale = 'daily_tip_cache_locale';
  static const String dailyTipCacheBody = 'daily_tip_cache_body';
}
