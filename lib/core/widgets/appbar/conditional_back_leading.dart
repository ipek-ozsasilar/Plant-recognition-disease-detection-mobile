import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Alt sekme kökleri: geri ile Ana Sayfa'ya dönülür.
const Set<String> _shellTabRootsWithHomeBack = <String>{
  AppPaths.history,
  AppPaths.healthProgress,
};

/// Üst yığında geri gidilebiliyorsa [BackButton]; sekme kökünde Ana Sayfa; değilse boş.
class ConditionalBackLeading extends StatelessWidget {
  const ConditionalBackLeading({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.canPop()) {
      return const BackButton();
    }

    final String location = GoRouterState.of(context).matchedLocation;
    if (_shellTabRootsWithHomeBack.contains(location)) {
      return IconButton(
        icon: const BackButtonIcon(),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: () => context.go(AppPaths.home),
      );
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
