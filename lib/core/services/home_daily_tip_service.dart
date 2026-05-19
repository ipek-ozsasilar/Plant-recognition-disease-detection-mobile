import 'package:bitirme_mobile/core/enums/home_daily_tip_kind_enum.dart';
import 'package:bitirme_mobile/models/home_daily_tip_context_model.dart';
import 'package:bitirme_mobile/models/plant_scan_model.dart';

/// Geçmiş taramalardan ipucu bağlamı ve yedek (sabit) kategori.
final class HomeDailyTipResult {
  const HomeDailyTipResult({
    required this.kind,
    this.focusSpeciesLabel,
  });

  final HomeDailyTipKindEnum kind;
  final String? focusSpeciesLabel;
}

final class HomeDailyTipResolved {
  const HomeDailyTipResolved({
    this.context,
    required this.fallback,
  });

  final HomeDailyTipContextModel? context;
  final HomeDailyTipResult fallback;
}

class HomeDailyTipService {
  const HomeDailyTipService();

  static const int _lookbackDays = 5;

  HomeDailyTipResolved resolve({
    required List<PlantScanModel> scans,
    required Set<String> knownDiseaseKeys,
  }) {
    final DateTime cutoff = DateTime.now().subtract(const Duration(days: _lookbackDays));
    final List<PlantScanModel> recent = scans
        .where((PlantScanModel s) => s.createdAt.isAfter(cutoff))
        .toList(growable: false);

    if (recent.isEmpty) {
      return const HomeDailyTipResolved(
        fallback: HomeDailyTipResult(kind: HomeDailyTipKindEnum.defaultPhoto),
      );
    }

    final Map<String, int> diseaseCounts = <String, int>{};
    final Map<String, int> speciesCounts = <String, int>{};
    final Set<String> distinctDiseases = <String>{};
    int healthSum = 0;

    for (final PlantScanModel scan in recent) {
      final String disease = scan.diseaseKey.trim().toLowerCase();
      if (!knownDiseaseKeys.contains(disease)) {
        continue;
      }
      diseaseCounts[disease] = (diseaseCounts[disease] ?? 0) + 1;
      distinctDiseases.add(disease);
      speciesCounts[scan.speciesLabel] = (speciesCounts[scan.speciesLabel] ?? 0) + 1;
      healthSum += scan.healthScore;
    }

    if (diseaseCounts.isEmpty) {
      return const HomeDailyTipResolved(
        fallback: HomeDailyTipResult(kind: HomeDailyTipKindEnum.defaultPhoto),
      );
    }

    final String? focusSpecies = _dominantKey(speciesCounts);
    final String dominantDisease = _dominantKey(diseaseCounts) ?? 'healthy';
    final int avgHealth = (healthSum / recent.length).round();

    final HomeDailyTipContextModel context = HomeDailyTipContextModel(
      recentScanCount: recent.length,
      dominantSpeciesLabel: focusSpecies,
      dominantDiseaseKey: dominantDisease,
      diseaseCounts: Map<String, int>.unmodifiable(diseaseCounts),
      speciesCounts: Map<String, int>.unmodifiable(speciesCounts),
      averageHealthScore: avgHealth,
      distinctDiseaseCount: distinctDiseases.length,
    );

    if (distinctDiseases.length >= 3) {
      return HomeDailyTipResolved(
        context: context,
        fallback: HomeDailyTipResult(
          kind: HomeDailyTipKindEnum.mixedRisk,
          focusSpeciesLabel: focusSpecies,
        ),
      );
    }

    return HomeDailyTipResolved(
      context: context,
      fallback: HomeDailyTipResult(
        kind: _kindForDisease(dominantDisease),
        focusSpeciesLabel: focusSpecies,
      ),
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
