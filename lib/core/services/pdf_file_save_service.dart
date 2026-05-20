import 'dart:io';

import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/core/services/notification_service.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

typedef PdfDownloadNotificationBodyBuilder = String Function(String savedFileName);

/// PDF baytlarını cihaza kaydeder (Android: genel İndirilenler + bildirim).
final class PdfFileSaveService {
  PdfFileSaveService({required AppLogger logger}) : _logger = logger;

  static const MethodChannel _androidDownloads =
      MethodChannel('com.ipekozsasilar.bitirme_mobile/downloads');

  final AppLogger _logger;

  Future<String> saveToDevice({
    required Uint8List bytes,
    required String filename,
    String? notificationTitle,
    PdfDownloadNotificationBodyBuilder? notificationBodyForFile,
  }) async {
    try {
      final String safeName =
          filename.toLowerCase().endsWith('.pdf') ? filename : '$filename.pdf';
      final String uniqueName = _uniqueFilename(safeName);

      final String savedPath;
      if (Platform.isAndroid) {
        savedPath = await _saveToAndroidPublicDownloads(bytes, uniqueName);
        await sl<NotificationService>().showPdfDownloadComplete(
          savedPath: savedPath,
          fileName: uniqueName,
          title: notificationTitle,
          body: notificationBodyForFile?.call(uniqueName),
        );
      } else {
        final Directory directory = await _resolveSaveDirectoryIos();
        final File file = File(p.join(directory.path, uniqueName));
        await file.writeAsBytes(bytes, flush: true);
        savedPath = file.path;
      }

      return savedPath;
    } catch (e, st) {
      _logger.e('pdf_save', e, st);
      rethrow;
    }
  }

  Future<String> _saveToAndroidPublicDownloads(
    Uint8List bytes,
    String fileName,
  ) async {
    final String? path = await _androidDownloads.invokeMethod<String>(
      'savePdf',
      <String, Object>{
        'bytes': bytes,
        'fileName': fileName,
      },
    );
    if (path == null || path.isEmpty) {
      throw StateError('Android savePdf returned empty path');
    }
    return path;
  }

  Future<Directory> _resolveSaveDirectoryIos() async {
    final Directory docs = await getApplicationDocumentsDirectory();
    if (!await docs.exists()) {
      await docs.create(recursive: true);
    }
    return docs;
  }

  /// Kaydedilen PDF'i varsayılan görüntüleyici ile açar (bildirim tıklaması).
  Future<void> openSavedPdf(String pathOrUri) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return;
    }

    final OpenResult primary = await OpenFilex.open(pathOrUri);
    if (primary.type == ResultType.done) {
      return;
    }

    _logger.w('pdf_open_filex', '${primary.type}: ${primary.message}');

    if (!Platform.isAndroid) {
      return;
    }

    try {
      await _androidDownloads.invokeMethod<void>('openPdf', <String, String>{
        'uri': pathOrUri,
      });
    } on MissingPluginException catch (e, st) {
      _logger.e(
        'pdf_open',
        'openPdf kanalı yok — uygulamayı tamamen kapatıp yeniden derleyin (flutter clean && flutter run). $e',
        st,
      );
      rethrow;
    }
  }

  String _uniqueFilename(String filename) {
    final int dot = filename.lastIndexOf('.');
    final String base = dot > 0 ? filename.substring(0, dot) : filename;
    final String ext = dot > 0 ? filename.substring(dot) : '.pdf';
    final int stamp = DateTime.now().millisecondsSinceEpoch;
    return '${base}_$stamp$ext';
  }
}
