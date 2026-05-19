/// Tarama sonrası yerel takip bildirimi gecikmesi (gün; debug’da dakika).
enum NotificationFollowUpEnum {
  healthy(85, 7, 10),
  mildRisk(70, 5, 7),
  mediumRisk(55, 3, 5),
  urgent(0, 1, 2);

  const NotificationFollowUpEnum(
    this.minHealthScore,
    this.delayDays,
    this.delayMinutesDebug,
  );

  final int minHealthScore;
  final int delayDays;

  /// [kDebugMode] iken `scheduleScanFollowUp` bu dakikayı kullanır (test).
  final int delayMinutesDebug;

  static NotificationFollowUpEnum forHealthScore(int healthScore) {
    if (healthScore >= NotificationFollowUpEnum.healthy.minHealthScore) {
      return NotificationFollowUpEnum.healthy;
    }
    if (healthScore >= NotificationFollowUpEnum.mildRisk.minHealthScore) {
      return NotificationFollowUpEnum.mildRisk;
    }
    if (healthScore >= NotificationFollowUpEnum.mediumRisk.minHealthScore) {
      return NotificationFollowUpEnum.mediumRisk;
    }
    return NotificationFollowUpEnum.urgent;
  }
}
