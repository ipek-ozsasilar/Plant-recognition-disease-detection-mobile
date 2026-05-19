import 'package:equatable/equatable.dart';

final class HealthProgressState extends Equatable {
  const HealthProgressState({
    required this.selectedSpeciesLabel,
  });

  /// Ham tür etiketi (`plantnet__…`); grafik bu türdeki tüm taramaları birleştirir.
  final String? selectedSpeciesLabel;

  HealthProgressState copyWith({String? selectedSpeciesLabel}) {
    return HealthProgressState(
      selectedSpeciesLabel: selectedSpeciesLabel,
    );
  }

  @override
  List<Object?> get props => <Object?>[selectedSpeciesLabel];
}
