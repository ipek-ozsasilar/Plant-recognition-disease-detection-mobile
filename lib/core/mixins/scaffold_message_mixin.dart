import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
import 'package:flutter/material.dart';

/// Snackbar göstermek için [ScaffoldMessenger] yardımcısı.
void showAppSnackBarForContext(
  BuildContext context, {
  required String message,
  bool isError = false,
}) {
  final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  final ColorScheme cs = Theme.of(context).colorScheme;
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(
        horizontal: WidgetSizesEnum.bottomNavHorizontalPadding.value,
        vertical: WidgetSizesEnum.bottomNavBottomPadding.value,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
      ),
      content: Text(
        message,
        style: TextStyle(
          fontSize: TextSizesEnum.body.value,
          fontWeight: FontWeight.w600,
          color: isError ? Colors.white : cs.onPrimary,
        ),
      ),
      backgroundColor: isError ? ColorName.error : cs.primary,
    ),
  );
}

mixin ScaffoldMessageMixin {
  void showAppSnackBar(
    BuildContext context, {
    required String message,
    bool isError = false,
  }) {
    showAppSnackBarForContext(context, message: message, isError: isError);
  }
}
