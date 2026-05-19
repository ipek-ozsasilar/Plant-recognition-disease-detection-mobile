import 'package:bitirme_mobile/core/services/home_daily_tip_service.dart';

/// Ana sayfa günün ipucu: AI metni veya yedek kural tabanlı kategori.
final class HomeDailyTipState {
  const HomeDailyTipState({
    required this.fallback,
    this.aiBody,
  });

  final String? aiBody;
  final HomeDailyTipResult fallback;

  bool get isFromAi => aiBody != null && aiBody!.trim().isNotEmpty;
}
