import 'package:bitirme_mobile/core/enums/home_daily_tip_kind_enum.dart';
import 'package:bitirme_mobile/models/plant_scan_model.dart';

/// Geçmiş taramalardan günün ipucu kategorisini seçer (AI yok).
final class HomeDailyTipResult {
  const HomeDailyTipResult({
    required this.kind,
    this.focusSpeciesLabel,
  });

  final HomeDailyTipKindEnum kind;

  /// En sık görülen tür etiketi (`plantnet__…`); UI’da lokalize gösterilir.
  final String? focusSpeciesLabel;
}

class HomeDailyTipService {
  const HomeDailyTipService();

  static const int _lookbackDays = 60;
  static const int _minScansForPersonal = 2;

  HomeDailyTipResult resolve({
    required List<PlantScanModel> scans,
    required Set<String> knownDiseaseKeys,
  }) {
    final DateTime cutoff = DateTime.now().subtract(const Duration(days: _lookbackDays));
    final List<PlantScanModel> recent = scans
        .where((PlantScanModel s) => s.createdAt.isAfter(cutoff))
        .toList(growable: false);

    if (recent.length < _minScansForPersonal) {
      return const HomeDailyTipResult(kind: HomeDailyTipKindEnum.defaultPhoto);
    }

    final Map<String, int> diseaseCounts = <String, int>{};
    final Map<String, int> speciesCounts = <String, int>{};
    final Set<String> distinctDiseases = <String>{};

    for (final PlantScanModel scan in recent) {
      final String disease = scan.diseaseKey.trim().toLowerCase();
      if (!knownDiseaseKeys.contains(disease)) {
        continue;
      }
      diseaseCounts[disease] = (diseaseCounts[disease] ?? 0) + 1;
      distinctDiseases.add(disease);
      speciesCounts[scan.speciesLabel] = (speciesCounts[scan.speciesLabel] ?? 0) + 1;
    }

    if (diseaseCounts.isEmpty) {
      return const HomeDailyTipResult(kind: HomeDailyTipKindEnum.defaultPhoto);
    }

    final String? focusSpecies = _dominantKey(speciesCounts);
    final String dominantDisease = _dominantKey(diseaseCounts) ?? 'healthy';

    if (distinctDiseases.length >= 3) {
      return HomeDailyTipResult(
        kind: HomeDailyTipKindEnum.mixedRisk,
        focusSpeciesLabel: focusSpecies,
      );
    }

    final HomeDailyTipKindEnum kind = _kindForDisease(dominantDisease);
    return HomeDailyTipResult(
      kind: kind,
      focusSpeciesLabel: focusSpecies,
    );
  }

  HomeDailyTipKindEnum _kindForDisease(String diseaseKey) {
    switch (diseaseKey) {
      case 'blight':
        return HomeDailyTipKindEnum.blight;
      case 'mold':
        return HomeDailyTipKindEnum.mold;
      case 'powdery_mildew':
        return HomeDailyTipKindEnum.powderyMildew;
      case 'rust':
        return HomeDailyTipKindEnum.rust;
      case 'healthy':
        return HomeDailyTipKindEnum.healthy;
      default:
        return HomeDailyTipKindEnum.defaultPhoto;
    }
  }

  String? _dominantKey(Map<String, int> counts) {
    if (counts.isEmpty) {
      return null;
    }
    String? bestKey;
    int bestCount = -1;
    for (final MapEntry<String, int> e in counts.entries) {
      if (e.value > bestCount) {
        bestCount = e.value;
        bestKey = e.key;
      }
    }
    return bestKey;
  }
}
