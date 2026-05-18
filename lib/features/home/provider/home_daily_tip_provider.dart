import 'package:bitirme_mobile/core/enums/home_daily_tip_kind_enum.dart';
import 'package:bitirme_mobile/core/services/home_daily_tip_service.dart';
import 'package:bitirme_mobile/core/services/ml_metadata_loader.dart';
import 'package:bitirme_mobile/core/services/scan_identification_filter.dart';
import 'package:bitirme_mobile/features/history/provider/history_firestore_provider.dart';
import 'package:bitirme_mobile/models/plant_scan_model.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<HomeDailyTipResult> homeDailyTipProvider = Provider<HomeDailyTipResult>((Ref ref) {
  final AsyncValue<List<PlantScanModel>> history = ref.watch(historyFirestoreProvider);
  final Set<String> knownDiseases = knownDiseaseKeysFromList(
    sl<MlMetadataLoader>().diseaseClassKeys,
  );

  return history.maybeWhen(
    data: (List<PlantScanModel> scans) => const HomeDailyTipService().resolve(
      scans: scans,
      knownDiseaseKeys: knownDiseases,
    ),
    orElse: () => const HomeDailyTipResult(
      kind: HomeDailyTipKindEnum.defaultPhoto,
    ),
  );
});
