import 'package:bitirme_mobile/features/health_progress/provider/health_progress_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final NotifierProvider<HealthProgressNotifier, HealthProgressState> healthProgressProvider =
    NotifierProvider<HealthProgressNotifier, HealthProgressState>(HealthProgressNotifier.new);

final class HealthProgressNotifier extends Notifier<HealthProgressState> {
  @override
  HealthProgressState build() {
    return const HealthProgressState(selectedPlantId: null);
  }

  void selectPlant(String? plantId) {
    state = state.copyWith(selectedPlantId: plantId);
  }
}
