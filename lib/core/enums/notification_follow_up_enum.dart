/// Tarama sonrası yerel takip bildirimi gecikmesi (gün).
enum NotificationFollowUpEnum {
  healthy(85, 7),
  mildRisk(70, 5),
  mediumRisk(55, 3),
  urgent(0, 1);

  const NotificationFollowUpEnum(this.minHealthScore, this.delayDays);

  final int minHealthScore;
  final int delayDays;

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
