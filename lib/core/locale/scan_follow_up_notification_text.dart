import 'package:bitirme_mobile/core/enums/notification_follow_up_enum.dart';
import 'package:bitirme_mobile/l10n/app_localizations.dart';

String scanFollowUpBody({
  required AppLocalizations l10n,
  required String plantName,
  required int healthScore,
}) {
  final NotificationFollowUpEnum plan = NotificationFollowUpEnum.forHealthScore(healthScore);
  switch (plan) {
    case NotificationFollowUpEnum.healthy:
      return l10n.notificationFollowUpHealthy(plantName);
    case NotificationFollowUpEnum.mildRisk:
      return l10n.notificationFollowUpMild(plantName);
    case NotificationFollowUpEnum.mediumRisk:
      return l10n.notificationFollowUpMedium(plantName);
    case NotificationFollowUpEnum.urgent:
      return l10n.notificationFollowUpUrgent(plantName);
  }
}
