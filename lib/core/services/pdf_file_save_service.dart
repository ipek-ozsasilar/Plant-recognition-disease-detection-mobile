import 'dart:io';
import 'dart:typed_data';

import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// PDF baytlarını cihaza kaydeder (Android: İndirilenler).
final class PdfFileSaveService {
  PdfFileSaveService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;

  Future<String> saveToDevice({
    required Uint8List bytes,
    required String filename,
  }) async {
    try {
      final String safeName =
          filename.toLowerCase().endsWith('.pdf') ? filename : '$filename.pdf';
      final String uniqueName = _uniqueFilename(safeName);
      final Directory directory = await _resolveSaveDirectory();
      final File file = File(p.join(directory.path, uniqueName));
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    } catch (e, st) {
      _logger.e('pdf_save', e, st);
      rethrow;
    }
  }

  Future<Directory> _resolveSaveDirectory() async {
    if (Platform.isAndroid) {
      final Directory? downloads = await getDownloadsDirectory();
      if (downloads != null) {
        if (!await downloads.exists()) {
          await downloads.create(recursive: true);
        }
        return downloads;
      }
    }
    final Directory docs = await getApplicationDocumentsDirectory();
    if (!await docs.exists()) {
      await docs.create(recursive: true);
    }
    return docs;
  }

  String _uniqueFilename(String filename) {
    final int dot = filename.lastIndexOf('.');
    final String base = dot > 0 ? filename.substring(0, dot) : filename;
    final String ext = dot > 0 ? filename.substring(dot) : '.pdf';
    final int stamp = DateTime.now().millisecondsSinceEpoch;
    return '${base}_$stamp$ext';
  }
}
