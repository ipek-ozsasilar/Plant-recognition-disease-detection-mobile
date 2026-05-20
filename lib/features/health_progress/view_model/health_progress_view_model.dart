import 'package:bitirme_mobile/core/enums/chart_window_enum.dart';
import 'package:bitirme_mobile/features/health_progress/provider/health_progress_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class HealthProgressViewModel {
  HealthProgressViewModel({required this.ref});

  final WidgetRef ref;

  void selectSpecies(String? speciesLabel) {
    ref.read(healthProgressProvider.notifier).selectSpecies(speciesLabel);
  }

  void selectChartWindow(ChartWindowEnum window) {
    ref.read(healthProgressProvider.notifier).selectChartWindow(window);
  }
}
