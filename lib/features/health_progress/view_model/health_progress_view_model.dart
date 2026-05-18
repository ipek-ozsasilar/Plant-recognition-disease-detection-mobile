import 'package:bitirme_mobile/features/health_progress/provider/health_progress_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class HealthProgressViewModel {
  HealthProgressViewModel({required this.ref});

  final WidgetRef ref;

  void selectPlant(String? plantId) {
    ref.read(healthProgressProvider.notifier).selectPlant(plantId);
  }
}
