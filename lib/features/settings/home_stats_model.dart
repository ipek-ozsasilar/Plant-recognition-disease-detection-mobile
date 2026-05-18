class HomeStatsModel {
  factory HomeStatsModel.empty() {
    return const HomeStatsModel(
      totalScans: 0,
      uniqueSpeciesCount: 0,
      alertCount: 0,
    );
  }
  const HomeStatsModel({
    required this.totalScans,
    required this.uniqueSpeciesCount,
    required this.alertCount,
  });

  final int totalScans;
  final int uniqueSpeciesCount;
  final int alertCount;
}
