import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/services/notification_service.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tarama takibi ve risk bildirimleri.
class ProfileNotificationsView extends ConsumerStatefulWidget {
  const ProfileNotificationsView({super.key});

  @override
  ConsumerState<ProfileNotificationsView> createState() =>
      _ProfileNotificationsViewState();
}

class _ProfileNotificationsViewState extends ConsumerState<ProfileNotificationsView> {
  bool? _enabled;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bool status = await sl<NotificationService>().isEnabled();
    if (mounted) {
      setState(() => _enabled = status);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;
    final NotificationService notifications = sl<NotificationService>();

    return Scaffold(
      backgroundColor: context.palSurface,
      appBar: AppBar(
        title: Text(context.l10n.profileNotificationSettings),
        leading: const BackButton(),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          pad,
          pad,
          pad,
          WidgetSizesEnum.bottomNavHeight.value,
        ),
        children: <Widget>[
          Text(
            context.l10n.profileNotificationsIntro,
            style: tt.bodyLarge?.copyWith(
              color: context.palMuted,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          SoftElevationCard(
            onTap: null,
            padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 0.65),
            child: SwitchListTile(
              value: _enabled ?? false,
              onChanged: (bool v) async {
                setState(() => _enabled = v);
                await notifications.setEnabled(v);
                if (v) {
                  await notifications.requestPermissions();
                } else {
                  await notifications.cancelAll();
                }
              },
              title: Text(
                context.l10n.notificationsLabel,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: context.palOnSurface,
                ),
              ),
              subtitle: Text(
                context.l10n.notificationsSubtitle,
                style: TextStyle(color: context.palMuted, height: 1.35),
              ),
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value),
          SoftElevationCard(
            onTap: null,
            padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value),
            child: Text(
              context.l10n.profileNotificationsDetail,
              style: tt.bodyMedium?.copyWith(
                color: context.palMuted,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
