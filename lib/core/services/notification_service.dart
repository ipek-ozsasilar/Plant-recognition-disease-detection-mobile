import 'dart:async';
import 'dart:io';

import 'package:bitirme_mobile/core/constants/preference_keys.dart';
import 'package:bitirme_mobile/core/enums/notification_follow_up_enum.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/core/services/pdf_file_save_service.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Lokal bildirimler: tarama sonrası takip ve risk uyarıları.
class NotificationService {
  NotificationService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static const int _followUpIdBase = 12000;
  static const int _riskAlertId = 11002;
  static const int _pdfDownloadCompleteId = 11003;
  static const int _followUpHour = 10;
  static const int _followUpMinute = 0;

  Future<void> init() async {
    try {
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));
    } catch (e, st) {
      _logger.w('tz_init', e);
      _logger.e('tz_init', e, st);
    }

    try {
      const AndroidInitializationSettings androidInit =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
      const InitializationSettings settings =
          InitializationSettings(android: androidInit, iOS: iosInit);
      await _plugin.initialize(
        settings,
        onDidReceiveNotificationResponse: _handleNotificationResponse,
      );
      await _openPdfIfLaunchedFromNotification();
      await _drainPendingPdfOpen();
    } catch (e, st) {
      _logger.e('notifications_init', e, st);
    }
  }

  void _handleNotificationResponse(NotificationResponse response) {
    final String? payload = response.payload;
    if (payload != null && _isPdfOpenPayload(payload)) {
      unawaited(_openPdfPayload(payload));
      return;
    }
    unawaited(_drainPendingPdfOpen());
  }

  Future<void> _openPdfIfLaunchedFromNotification() async {
    try {
      final NotificationAppLaunchDetails? launchDetails =
          await _plugin.getNotificationAppLaunchDetails();
      if (launchDetails?.didNotificationLaunchApp != true) {
        return;
      }
      final String? payload = launchDetails?.notificationResponse?.payload;
      if (payload != null && _isPdfOpenPayload(payload)) {
        await _openPdfPayload(payload);
      }
    } catch (e, st) {
      _logger.e('notifications_pdf_launch', e, st);
    }
  }

  Future<void> _rememberPendingPdf(String uri) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(PreferenceKeys.pendingPdfOpenUri, uri);
    } catch (e, st) {
      _logger.e('notifications_pdf_remember', e, st);
    }
  }

  Future<void> _clearPendingPdf() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(PreferenceKeys.pendingPdfOpenUri);
    } catch (e, st) {
      _logger.e('notifications_pdf_clear', e, st);
    }
  }

  Future<void> _drainPendingPdfOpen() async {
    if (!Platform.isAndroid) {
      return;
    }
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? uri = prefs.getString(PreferenceKeys.pendingPdfOpenUri);
      if (uri == null || uri.isEmpty || !_isPdfOpenPayload(uri)) {
        return;
      }
      await _openPdfPayload(uri);
    } catch (e, st) {
      _logger.e('notifications_pdf_drain', e, st);
    }
  }

  bool _isPdfOpenPayload(String payload) {
    return payload.startsWith('content://') ||
        payload.endsWith('.pdf') ||
        payload.contains(RegExp(r'[\\/]Download[\\/]'));
  }

  Future<void> _openPdfPayload(String payload) async {
    if (!Platform.isAndroid) {
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 400));
    try {
      await sl<PdfFileSaveService>().openSavedPdf(payload);
      await _clearPendingPdf();
    } catch (e, st) {
      _logger.e('notifications_pdf_open', e, st);
    }
  }

  Future<bool> isEnabled() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool(PreferenceKeys.notificationsEnabled) ?? false;
    } catch (e, st) {
      _logger.e('notifications_enabled_read', e, st);
      return false;
    }
  }

  Future<void> setEnabled(bool enabled) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(PreferenceKeys.notificationsEnabled, enabled);
    } catch (e, st) {
      _logger.e('notifications_enabled_write', e, st);
    }
  }

  Future<void> requestPermissions() async {
    try {
      await _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      await _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } catch (e, st) {
      _logger.e('notifications_permissions', e, st);
    }
  }

  /// İlk kez ana uygulamaya girildiğinde izin ister; varsayılan olarak bildirimleri açar.
  Future<void> ensureInitialPermissionPrompt() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool done =
          prefs.getBool(PreferenceKeys.notificationInitialPromptDone) ?? false;
      if (done) {
        return;
      }
      await prefs.setBool(PreferenceKeys.notificationInitialPromptDone, true);
      await requestPermissions();
      await setEnabled(true);
    } catch (e, st) {
      _logger.e('notifications_initial_prompt', e, st);
    }
  }

  Future<void> cancelAll() async {
    try {
      await _plugin.cancelAll();
    } catch (e, st) {
      _logger.e('notifications_cancel_all', e, st);
    }
  }

  /// Bitki başına tek takip bildirimi; yeni taramada önceki iptal edilir.
  int notificationIdForPlant(String plantId) {
    return _followUpIdBase + (plantId.hashCode.abs() % 8000);
  }

  Future<void> cancelFollowUpForPlant(String plantId) async {
    try {
      await _plugin.cancel(notificationIdForPlant(plantId));
    } catch (e, st) {
      _logger.e('notifications_cancel_follow_up', e, st);
    }
  }

  Future<void> scheduleScanFollowUp({
    required String plantId,
    required String title,
    required String body,
    required int healthScore,
  }) async {
    try {
      final bool enabled = await isEnabled();
      if (!enabled) {
        return;
      }

      final NotificationFollowUpEnum plan =
          NotificationFollowUpEnum.forHealthScore(healthScore);
      await cancelFollowUpForPlant(plantId);

      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      final tz.TZDateTime when = kDebugMode
          ? now.add(Duration(minutes: plan.delayMinutesDebug))
          : _followUpAtTenAmAfterDays(now: now, delayDays: plan.delayDays);

      const AndroidNotificationDetails android = AndroidNotificationDetails(
        'scan_follow_up',
        'Scan follow-up',
        channelDescription: 'Reminders after you save a plant scan',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      );
      const DarwinNotificationDetails ios = DarwinNotificationDetails();
      const NotificationDetails details =
          NotificationDetails(android: android, iOS: ios);

      await _plugin.zonedSchedule(
        notificationIdForPlant(plantId),
        title,
        body,
        when,
        details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (e, st) {
      _logger.e('notifications_schedule_follow_up', e, st);
    }
  }

  tz.TZDateTime _followUpAtTenAmAfterDays({
    required tz.TZDateTime now,
    required int delayDays,
  }) {
    tz.TZDateTime when = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      _followUpHour,
      _followUpMinute,
    ).add(Duration(days: delayDays));
    if (when.isBefore(now)) {
      when = when.add(const Duration(days: 1));
    }
    return when;
  }

  /// PDF İndirilenler'e kaydedildiğinde sistem çubuğu bildirimi (Android).
  Future<void> showPdfDownloadComplete({
    required String savedPath,
    required String fileName,
    String? title,
    String? body,
  }) async {
    try {
      final String resolvedTitle = title ?? 'Download complete';
      final String resolvedBody =
          body ?? '$fileName saved to Downloads folder.';

      final AndroidNotificationDetails android = AndroidNotificationDetails(
        'pdf_downloads',
        'File downloads',
        channelDescription: 'PDF report saved to device',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        autoCancel: true,
        category: AndroidNotificationCategory.status,
      );
      const DarwinNotificationDetails ios = DarwinNotificationDetails();
      final NotificationDetails details =
          NotificationDetails(android: android, iOS: ios);

      await _rememberPendingPdf(savedPath);
      await _plugin.show(
        _pdfDownloadCompleteId,
        resolvedTitle,
        resolvedBody,
        details,
        payload: savedPath,
      );
    } catch (e, st) {
      _logger.e('notifications_pdf_download', e, st);
    }
  }

  Future<void> showRiskAlert({
    required String title,
    required String body,
  }) async {
    try {
      final bool enabled = await isEnabled();
      if (!enabled) {
        return;
      }
      const AndroidNotificationDetails android = AndroidNotificationDetails(
        'risk_alerts',
        'Risk alerts',
        channelDescription: 'Health risk warnings',
        importance: Importance.high,
        priority: Priority.high,
      );
      const DarwinNotificationDetails ios = DarwinNotificationDetails();
      const NotificationDetails details = NotificationDetails(android: android, iOS: ios);

      await _plugin.show(_riskAlertId, title, body, details);
    } catch (e, st) {
      _logger.e('notifications_risk_alert', e, st);
    }
  }
}
