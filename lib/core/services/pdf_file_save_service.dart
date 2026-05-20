import 'dart:io';

import 'package:bitirme_mobile/core/constants/preference_keys.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/core/services/notification_service.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef PdfDownloadNotificationBodyBuilder = String Function(String savedFileName);

/// PDF baytlarını cihaza kaydeder (Android: genel İndirilenler + bildirim).
final class PdfFileSaveService {
  PdfFileSaveService({required AppLogger logger}) : _logger = logger;

  static const MethodChannel _androidDownloads =
      MethodChannel('com.ipekozsasilar.bitirme_mobile/downloads');

  static const String _cacheSubdir = 'pdf_open';

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

      final String openPath;
      if (Platform.isAndroid) {
        await _saveToAndroidPublicDownloads(bytes, uniqueName);
        openPath = await _writeCacheCopy(bytes, uniqueName);
        await _rememberOpenPath(openPath);
        await sl<NotificationService>().showPdfDownloadComplete(
          savedPath: openPath,
          fileName: uniqueName,
          title: notificationTitle,
          body: notificationBodyForFile?.call(uniqueName),
        );
      } else {
        final Directory directory = await _resolveSaveDirectoryIos();
        final File file = File(p.join(directory.path, uniqueName));
        await file.writeAsBytes(bytes, flush: true);
        openPath = file.path;
      }

      return openPath;
    } catch (e, st) {
      _logger.e('pdf_save', e, st);
      rethrow;
    }
  }

  Future<void> _rememberOpenPath(String path) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(PreferenceKeys.pendingPdfOpenUri, path);
    } catch (e, st) {
      _logger.e('pdf_remember_open_path', e, st);
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

  /// Bildirim / open_filex için uygulama önbelleğindeki kopya (content:// değil).
  Future<String> _writeCacheCopy(Uint8List bytes, String fileName) async {
    final Directory pdfDir = await _cachePdfDirectory();
    final File file = File(p.join(pdfDir.path, fileName));
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  Future<Directory> _cachePdfDirectory() async {
    final Directory dir = await getTemporaryDirectory();
    final Directory pdfDir = Directory(p.join(dir.path, _cacheSubdir));
    if (!await pdfDir.exists()) {
      await pdfDir.create(recursive: true);
    }
    return pdfDir;
  }

  /// En son indirilen önbellek PDF yolu.
  Future<String?> latestCachePdfPath() async {
    try {
      final Directory pdfDir = await _cachePdfDirectory();
      final List<FileSystemEntity> entries = pdfDir.listSync();
      final List<File> pdfs = entries
          .whereType<File>()
          .where((File f) => f.path.toLowerCase().endsWith('.pdf'))
          .toList();
      if (pdfs.isEmpty) {
        return null;
      }
      pdfs.sort(
        (File a, File b) =>
            b.lastModifiedSync().compareTo(a.lastModifiedSync()),
      );
      return pdfs.first.path;
    } catch (e, st) {
      _logger.e('pdf_latest_cache', e, st);
      return null;
    }
  }

  Future<Directory> _resolveSaveDirectoryIos() async {
    final Directory docs = await getApplicationDocumentsDirectory();
    if (!await docs.exists()) {
      await docs.create(recursive: true);
    }
    return docs;
  }

  Future<String> _resolveOpenablePath(String pathOrUri) async {
    if (pathOrUri.startsWith('content://')) {
      final String? cache = await latestCachePdfPath();
      if (cache != null) {
        return cache;
      }
      return pathOrUri;
    }
    final File file = File(pathOrUri);
    if (await file.exists()) {
      return pathOrUri;
    }
    final String? cache = await latestCachePdfPath();
    if (cache != null) {
      _logger.w('pdf_open_fallback', 'Missing $pathOrUri, using $cache');
      return cache;
    }
    return pathOrUri;
  }

  /// Kaydedilen PDF'i varsayılan görüntüleyici ile açar.
  Future<void> openSavedPdf(String pathOrUri) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return;
    }

    final String resolved = await _resolveOpenablePath(pathOrUri);

    if (resolved.startsWith('content://')) {
      if (!Platform.isAndroid) {
        return;
      }
      await _openViaAndroidChannel(resolved);
      return;
    }

    final File file = File(resolved);
    if (!await file.exists()) {
      _logger.e('pdf_open', 'Dosya yok: $resolved', null);
      return;
    }

    final OpenResult primary = await OpenFilex.open(resolved);
    if (primary.type == ResultType.done) {
      return;
    }

    _logger.w('pdf_open_filex', '${primary.type}: ${primary.message}');

    if (Platform.isAndroid) {
      await _openViaAndroidChannel(resolved);
    }
  }

  Future<void> _openViaAndroidChannel(String uriOrPath) async {
    try {
      await _androidDownloads.invokeMethod<void>('openPdf', <String, String>{
        'uri': uriOrPath,
      });
    } on MissingPluginException catch (e, st) {
      _logger.e(
        'pdf_open',
        'openPdf kanalı yok — flutter clean && flutter run. $e',
        st,
      );
      rethrow;
    } catch (e, st) {
      _logger.e('pdf_open_android', e, st);
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
