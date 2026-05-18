import 'package:equatable/equatable.dart';

final class HealthProgressState extends Equatable {
  const HealthProgressState({
    required this.selectedPlantId,
  });

  /// Evimdeki bitki kaydı (fiziksel saksı); tür değil.
  final String? selectedPlantId;

  HealthProgressState copyWith({String? selectedPlantId}) {
    return HealthProgressState(
      selectedPlantId: selectedPlantId,
    );
  }

  @override
  List<Object?> get props => <Object?>[selectedPlantId];
}
