import 'package:bitirme_mobile/core/enums/chart_window_enum.dart';
import 'package:bitirme_mobile/features/health_progress/provider/health_progress_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final NotifierProvider<HealthProgressNotifier, HealthProgressState> healthProgressProvider =
    NotifierProvider<HealthProgressNotifier, HealthProgressState>(HealthProgressNotifier.new);

final class HealthProgressNotifier extends Notifier<HealthProgressState> {
  @override
  HealthProgressState build() {
    return const HealthProgressState(
      selectedSpeciesLabel: null,
      chartWindow: ChartWindowEnum.fourteen,
    );
  }

  void selectSpecies(String? speciesLabel) {
    state = state.copyWith(selectedSpeciesLabel: speciesLabel);
  }

  void selectChartWindow(ChartWindowEnum window) {
    state = state.copyWith(chartWindow: window);
  }
}
