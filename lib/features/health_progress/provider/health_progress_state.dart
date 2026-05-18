import 'package:equatable/equatable.dart';

final class HealthProgressState extends Equatable {
  const HealthProgressState({
    required this.selectedSpeciesLabel,
  });

  /// Geçmiş taramalardaki ham tür anahtarı (`plantnet__…`).
  final String? selectedSpeciesLabel;

  HealthProgressState copyWith({String? selectedSpeciesLabel}) {
    return HealthProgressState(
      selectedSpeciesLabel: selectedSpeciesLabel,
    );
  }

  @override
  List<Object?> get props => <Object?>[selectedSpeciesLabel];
}

