import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Üst yığında geri gidilebiliyorsa [BackButton], değilse boş (sekme kökü).
class ConditionalBackLeading extends StatelessWidget {
  const ConditionalBackLeading({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.canPop()) {
      return const BackButton();
    }
    return const SizedBox.shrink();
  }
}

/// [AppBar] için geri ok + otomatik leading kapalı.
PreferredSizeWidget appBarWithConditionalBack({
  required BuildContext context,
  required Widget title,
  List<Widget>? actions,
}) {
  return AppBar(
    leading: const ConditionalBackLeading(),
    automaticallyImplyLeading: false,
    title: title,
    actions: actions,
  );
}
