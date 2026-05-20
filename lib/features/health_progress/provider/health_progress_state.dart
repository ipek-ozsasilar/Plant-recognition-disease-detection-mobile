import 'package:bitirme_mobile/core/enums/chart_window_enum.dart';
import 'package:equatable/equatable.dart';

final class HealthProgressState extends Equatable {
  const HealthProgressState({
    required this.selectedSpeciesLabel,
    required this.chartWindow,
  });

  /// Ham tür etiketi (`plantnet__…`); grafik bu türdeki tüm taramaları birleştirir.
  final String? selectedSpeciesLabel;
  final ChartWindowEnum chartWindow;

  HealthProgressState copyWith({
    String? selectedSpeciesLabel,
    ChartWindowEnum? chartWindow,
  }) {
    return HealthProgressState(
      selectedSpeciesLabel: selectedSpeciesLabel ?? this.selectedSpeciesLabel,
      chartWindow: chartWindow ?? this.chartWindow,
    );
  }

  @override
  List<Object?> get props => <Object?>[selectedSpeciesLabel, chartWindow];
}
