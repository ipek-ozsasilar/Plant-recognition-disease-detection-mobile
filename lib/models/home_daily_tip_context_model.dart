/// AI günün ipucu isteği için tarama özeti.
final class HomeDailyTipContextModel {
  const HomeDailyTipContextModel({
    required this.recentScanCount,
    required this.diseaseCounts,
    required this.speciesCounts,
    required this.averageHealthScore,
    required this.distinctDiseaseCount,
    this.dominantSpeciesLabel,
    this.dominantDiseaseKey,
  });

  final int recentScanCount;
  final String? dominantSpeciesLabel;
  final String? dominantDiseaseKey;
  final Map<String, int> diseaseCounts;
  final Map<String, int> speciesCounts;
  final int averageHealthScore;
  final int distinctDiseaseCount;

  Map<String, Object?> toApiJson() {
    return <String, Object?>{
      'recent_scan_count': recentScanCount,
      'dominant_species_label': dominantSpeciesLabel,
      'dominant_disease_key': dominantDiseaseKey,
      'disease_counts': diseaseCounts,
      'species_counts': speciesCounts,
      'average_health_score': averageHealthScore,
      'distinct_disease_count': distinctDiseaseCount,
    };
  }

  String cacheFingerprint() {
    return Object.hash(
      recentScanCount,
      dominantSpeciesLabel,
      dominantDiseaseKey,
      diseaseCounts,
      speciesCounts,
      averageHealthScore,
      distinctDiseaseCount,
    ).toString();
  }
}
