import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/app_locale_mode.dart';
import 'package:bitirme_mobile/core/locale/app_locale_provider.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/core/services/notification_service.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/core/theme/theme_mode_provider.dart';
import 'package:bitirme_mobile/core/widgets/appbar/conditional_back_leading.dart';
import 'package:bitirme_mobile/core/widgets/surface/soft_elevation_card.dart';
import 'package:bitirme_mobile/features/profile/sub_view/profile_settings_tile.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Dil seçenekleri (ayarlar segmenti).
enum _LocaleSegment { system, turkish, english }

/// Tema, dil ve bildirimler.
class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  static Set<_LocaleSegment> _selectedLocale(AppLocaleMode mode) {
    return switch (mode) {
      AppLocaleUnset() => <_LocaleSegment>{_LocaleSegment.turkish},
      AppLocaleFollowSystem() => <_LocaleSegment>{_LocaleSegment.system},
      AppLocaleFixed(:final Locale locale) =>
        locale.languageCode == 'en'
            ? <_LocaleSegment>{_LocaleSegment.english}
            : <_LocaleSegment>{_LocaleSegment.turkish},
    };
  }

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  bool? _notificationsEnabled;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final bool enabled = await sl<NotificationService>().isEnabled();
    if (mounted) {
      setState(() => _notificationsEnabled = enabled);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeMode mode = ref.watch(themeModeProvider);
    final AppLocaleMode localeMode = ref.watch(appLocaleProvider);
    final AppLocaleNotifier localeNotifier = ref.read(
      appLocaleProvider.notifier,
    );
    final NotificationService notifications = sl<NotificationService>();
    final TextTheme tt = Theme.of(context).textTheme;
    final double pad = WidgetSizesEnum.cardRadius.value * 1.15;

    return Scaffold(
      backgroundColor: context.palSurface,
      appBar: appBarWithConditionalBack(
        context: context,
        title: Text(context.l10n.settingsTitle),
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
            context.l10n.settingsHeadline,
            style: tt.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: context.palOnSurface,
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.divider.value * 8),
          Text(
            context.l10n.settingsSubtitle,
            style: tt.bodyLarge?.copyWith(
              color: context.palMuted,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.35),
          _SettingsSectionTitle(text: context.l10n.languageLabel),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.75),
          SoftElevationCard(
            onTap: null,
            padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 0.95),
            child: SegmentedButton<_LocaleSegment>(
              style: _settingsSegmentStyle(),
              showSelectedIcon: false,
              segments: <ButtonSegment<_LocaleSegment>>[
                ButtonSegment<_LocaleSegment>(
                  value: _LocaleSegment.system,
                  label: _segmentLabel(context, context.l10n.languageSystem),
                ),
                ButtonSegment<_LocaleSegment>(
                  value: _LocaleSegment.turkish,
                  label: _segmentLabel(context, context.l10n.languageTurkish),
                ),
                ButtonSegment<_LocaleSegment>(
                  value: _LocaleSegment.english,
                  label: _segmentLabel(context, context.l10n.languageEnglish),
                ),
              ],
              selected: SettingsView._selectedLocale(localeMode),
              onSelectionChanged: (Set<_LocaleSegment> next) {
                final _LocaleSegment v = next.first;
                if (v == _LocaleSegment.system) {
                  localeNotifier.setFollowSystem();
                } else if (v == _LocaleSegment.turkish) {
                  localeNotifier.setTurkish();
                } else {
                  localeNotifier.setEnglish();
                }
              },
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.35),
          _SettingsSectionTitle(text: context.l10n.themeLabel),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.75),
          SoftElevationCard(
            onTap: null,
            padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 0.95),
            child: SegmentedButton<ThemeMode>(
              style: _settingsSegmentStyle(),
              showSelectedIcon: false,
              segments: <ButtonSegment<ThemeMode>>[
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.system,
                  label: _segmentIconLabel(
                    context,
                    icon: Icons.brightness_auto,
                    text: context.l10n.themeSystem,
                  ),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.light,
                  label: _segmentIconLabel(
                    context,
                    icon: Icons.light_mode_outlined,
                    text: context.l10n.themeLight,
                  ),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.dark,
                  label: _segmentIconLabel(
                    context,
                    icon: Icons.dark_mode_outlined,
                    text: context.l10n.themeDark,
                  ),
                ),
              ],
              selected: <ThemeMode>{mode},
              onSelectionChanged: (Set<ThemeMode> next) {
                ref.read(themeModeProvider.notifier).setMode(next.first);
              },
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.35),
          _SettingsSectionTitle(text: context.l10n.settingsNotificationsSection),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.75),
          SoftElevationCard(
            onTap: null,
            padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 0.65),
            child: SwitchListTile(
              value: _notificationsEnabled ?? false,
              onChanged: (bool enabled) async {
                setState(() => _notificationsEnabled = enabled);
                await notifications.setEnabled(enabled);
                if (enabled) {
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
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.65),
          SoftElevationCard(
            onTap: null,
            padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value),
            child: Text(
              context.l10n.profileNotificationsDetail,
              style: tt.bodySmall?.copyWith(
                color: context.palMuted,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.35),
          _SettingsSectionTitle(text: context.l10n.settingsAnalysisSection),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.75),
          SoftElevationCard(
            onTap: null,
            padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(WidgetSizesEnum.divider.value * 10),
                  decoration: BoxDecoration(
                    color: context.palPrimarySoftBg,
                    borderRadius: BorderRadius.circular(
                      WidgetSizesEnum.chipRadius.value,
                    ),
                  ),
                  child: Icon(
                    Icons.memory_rounded,
                    color: context.palPrimary,
                    size: IconSizesEnum.large.value,
                  ),
                ),
                SizedBox(width: WidgetSizesEnum.cardRadius.value * 0.85),
                Expanded(
                  child: Text(
                    context.l10n.settingsAnalysisBody,
                    style: tt.bodyMedium?.copyWith(
                      color: context.palMuted,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 1.35),
          _SettingsSectionTitle(text: context.l10n.settingsShortcutsSection),
          SizedBox(height: WidgetSizesEnum.cardRadius.value * 0.75),
          SoftElevationCard(
            onTap: null,
            padding: EdgeInsets.symmetric(
              vertical: WidgetSizesEnum.divider.value * 6,
            ),
            child: Column(
              children: <Widget>[
                ProfileSettingsTile(
                  icon: Icons.menu_book_rounded,
                  title: context.l10n.guideTitle,
                  onTap: () => context.push(AppPaths.guide),
                ),
                Divider(
                  height: 1,
                  indent: WidgetSizesEnum.cardRadius.value,
                  endIndent: WidgetSizesEnum.cardRadius.value,
                  color: context.palOutline.withValues(alpha: 0.35),
                ),
                ProfileSettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: context.l10n.aboutTitle,
                  onTap: () => context.push(AppPaths.about),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSectionTitle extends StatelessWidget {
  const _SettingsSectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: context.palOnSurface,
          ),
    );
  }
}

ButtonStyle _settingsSegmentStyle() {
  return SegmentedButton.styleFrom(
    visualDensity: VisualDensity.compact,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    padding: EdgeInsets.symmetric(
      horizontal: WidgetSizesEnum.divider.value * 6,
      vertical: WidgetSizesEnum.divider.value * 10,
    ),
  );
}

Widget _segmentLabel(BuildContext context, String text) {
  return Text(
    text,
    maxLines: 1,
    softWrap: false,
    overflow: TextOverflow.visible,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: TextSizesEnum.caption.value,
      fontWeight: FontWeight.w700,
      height: 1.1,
      color: context.palOnSurface,
    ),
  );
}

Widget _segmentIconLabel(
  BuildContext context, {
  required IconData icon,
  required String text,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Icon(icon, size: IconSizesEnum.small.value),
      SizedBox(height: WidgetSizesEnum.divider.value * 4),
      _segmentLabel(context, text),
    ],
  );
}
