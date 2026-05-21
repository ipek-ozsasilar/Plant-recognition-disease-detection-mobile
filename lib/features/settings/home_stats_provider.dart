import 'package:bitirme_mobile/core/services/plant_scans_firestore_service.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/features/settings/home_stats_model.dart';
import 'package:bitirme_mobile/models/plant_scan_model.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Firestore'dan kullanıcı taramalarını çeker ve özet istatistikleri hesaplar.
final homeStatsProvider = FutureProvider<HomeStatsModel>((ref) async {
  final authState = ref.watch(authProvider);
  final uid = authState.uid;

  if (uid == null) return HomeStatsModel.empty();

  try {
    final scansService = sl<PlantScansFirestoreService>();
    // Son 100 taramayı baz alarak istatistik oluşturuyoruz
    final List<PlantScanModel> scans = await scansService.listUserScans(
      ownerUid: uid,
      limit: 100,
    );

    if (scans.isEmpty) return HomeStatsModel.empty();

    final int totalScans = scans.length;
    final Set<String> uniqueSpecies = scans
        .map((PlantScanModel e) => e.speciesLabel.trim())
        .where((String s) => s.isNotEmpty)
        .toSet();
    final Set<String> uniqueDiseases = scans
        .map((PlantScanModel e) => e.diseaseKey.trim())
        .where((String k) => k.isNotEmpty)
        .toSet();
    // Sağlık skoru 55'in altındakileri "Uyarı" olarak sayıyoruz
    final int alerts = scans.where((PlantScanModel e) => e.healthScore < 55).length;

    return HomeStatsModel(
      totalScans: totalScans,
      uniqueSpeciesCount: uniqueSpecies.length,
      uniqueDiseaseCount: uniqueDiseases.length,
      alertCount: alerts,
    );
  } catch (e) {
    return HomeStatsModel.empty();
  }
});
