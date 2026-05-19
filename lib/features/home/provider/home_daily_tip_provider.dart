import 'dart:async';

import 'package:bitirme_mobile/core/enums/home_daily_tip_kind_enum.dart';
import 'package:bitirme_mobile/core/locale/app_locale_code.dart';
import 'package:bitirme_mobile/core/locale/app_locale_mode.dart';
import 'package:bitirme_mobile/core/locale/app_locale_provider.dart';
import 'package:bitirme_mobile/core/services/daily_tip_api_service.dart';
import 'package:bitirme_mobile/core/services/daily_tip_cache_service.dart';
import 'package:bitirme_mobile/core/services/home_daily_tip_service.dart';
import 'package:bitirme_mobile/core/services/ml_metadata_loader.dart';
import 'package:bitirme_mobile/core/services/scan_identification_filter.dart';
import 'package:bitirme_mobile/features/history/provider/history_firestore_provider.dart';
import 'package:bitirme_mobile/features/home/provider/home_daily_tip_state.dart';
import 'package:bitirme_mobile/models/home_daily_tip_context_model.dart';
import 'package:bitirme_mobile/models/plant_scan_model.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AsyncNotifierProvider<HomeDailyTipNotifier, HomeDailyTipState> homeDailyTipProvider =
    AsyncNotifierProvider<HomeDailyTipNotifier, HomeDailyTipState>(HomeDailyTipNotifier.new);

class HomeDailyTipNotifier extends AsyncNotifier<HomeDailyTipState> {
  Timer? _midnightTimer;

  @override
  Future<HomeDailyTipState> build() async {
    ref.onDispose(_cancelMidnightTimer);
    ref.listen(appLocaleProvider, (_, __) => ref.invalidateSelf());
    _scheduleMidnightRefresh();

    final AsyncValue<List<PlantScanModel>> history = ref.watch(historyFirestoreProvider);
    final AppLocaleMode localeMode = ref.watch(appLocaleProvider);
    final String localeCode = appLocaleCodeFor(localeMode);
    final Set<String> knownDiseases = knownDiseaseKeysFromList(
      sl<MlMetadataLoader>().diseaseClassKeys,
    );

    return history.when(
      data: (List<PlantScanModel> scans) => _loadForScans(
        scans: scans,
        knownDiseaseKeys: knownDiseases,
        localeCode: localeCode,
      ),
      loading: () => const HomeDailyTipState(
        fallback: HomeDailyTipResult(kind: HomeDailyTipKindEnum.defaultPhoto),
      ),
      error: (_, __) => const HomeDailyTipState(
        fallback: HomeDailyTipResult(kind: HomeDailyTipKindEnum.defaultPhoto),
      ),
    );
  }

  void _scheduleMidnightRefresh() {
    _cancelMidnightTimer();
    final Duration wait = sl<DailyTipCacheService>().timeUntilNextMidnight();
    _midnightTimer = Timer(wait, () => ref.invalidateSelf());
  }

  void _cancelMidnightTimer() {
    _midnightTimer?.cancel();
    _midnightTimer = null;
  }

  Future<HomeDailyTipState> _loadForScans({
    required List<PlantScanModel> scans,
    required Set<String> knownDiseaseKeys,
    required String localeCode,
  }) async {
    final HomeDailyTipResolved resolved = const HomeDailyTipService().resolve(
      scans: scans,
      knownDiseaseKeys: knownDiseaseKeys,
    );

    final HomeDailyTipContextModel? context = resolved.context;
    if (context == null) {
      return HomeDailyTipState(fallback: resolved.fallback);
    }

    final String? aiBody = await sl<DailyTipApiService>().fetchTip(
      localeCode: localeCode,
      context: context,
    );

    return HomeDailyTipState(
      aiBody: aiBody,
      fallback: resolved.fallback,
    );
  }
}
