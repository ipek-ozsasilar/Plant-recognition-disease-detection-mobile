import 'package:bitirme_mobile/core/mixins/scaffold_message_mixin.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Tarama ekranını açar; kayıt başarılıysa önceki sayfada snackbar gösterir.
Future<void> launchScanFlow(BuildContext context) async {
  final String? message = await context.push<String>(AppPaths.scan);
  if (message == null || message.isEmpty || !context.mounted) {
    return;
  }
  showAppSnackBarForContext(context, message: message);
}
