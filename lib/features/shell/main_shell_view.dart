import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/navigation/scan_flow_launcher.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Yüzen alt bar + yumuşak gölgeli tarama FAB.
class MainShellView extends StatelessWidget {
  const MainShellView({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final double hPad = WidgetSizesEnum.bottomNavHorizontalPadding.value;
    final double bPad = WidgetSizesEnum.bottomNavBottomPadding.value;

    return Scaffold(
      extendBody: true,
      backgroundColor: context.palSurface,
      body: navigationShell,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: context.palPrimary.withValues(alpha: 0.4),
              blurRadius: WidgetSizesEnum.fabBlurRadius.value,
              offset: Offset(0, WidgetSizesEnum.fabYOffset.value),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: context.palPrimary,
          foregroundColor: context.palOnPrimary,
          elevation: WidgetSizesEnum.divider.value * 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WidgetSizesEnum.cardRadius.value * 1.35),
          ),
          onPressed: () => launchScanFlow(context),
          tooltip: context.l10n.navScan,
          child: Icon(Icons.photo_camera_rounded, size: IconSizesEnum.large.value),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        // Alttaki "gri boşluk" hissini engellemek için zemin rengi sabit.
        color: context.palSurface,
        child: SafeArea(
          top: false,
          minimum: EdgeInsets.only(bottom: bPad),
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 0),
            child: Material(
              elevation: 12,
              shadowColor: context.palPrimary.withValues(alpha: 0.22),
              surfaceTintColor: context.palPrimarySoftBg,
              color: context.palSurfaceCard,
              borderRadius: BorderRadius.circular(WidgetSizesEnum.cardRadius.value * 1.35),
              clipBehavior: Clip.antiAlias,
              child: BottomAppBar(
                height: WidgetSizesEnum.bottomNavHeight.value,
                elevation: 0,
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(
                  horizontal: WidgetSizesEnum.divider.value * 4,
                  vertical: WidgetSizesEnum.divider.value * 6,
                ),
                shape: const CircularNotchedRectangle(),
                notchMargin: WidgetSizesEnum.divider.value * 6,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: _NavIcon(
                        icon: Icons.home_rounded,
                        selected: navigationShell.currentIndex == 0,
                        label: context.l10n.navHome,
                        onTap: () => navigationShell.goBranch(0),
                      ),
                    ),
                    Expanded(
                      child: _NavIcon(
                        icon: Icons.history_rounded,
                        selected: navigationShell.currentIndex == 1,
                        label: context.l10n.navHistory,
                        onTap: () => navigationShell.goBranch(1),
                      ),
                    ),
                    SizedBox(width: WidgetSizesEnum.bottomNavFabCutoutWidth.value),
                    Expanded(
                      child: _NavIcon(
                        icon: Icons.show_chart_rounded,
                        selected: navigationShell.currentIndex == 2,
                        label: context.l10n.navProgress,
                        onTap: () => navigationShell.goBranch(2),
                      ),
                    ),
                    Expanded(
                      child: _NavIcon(
                        icon: Icons.menu_rounded,
                        selected: navigationShell.currentIndex == 3,
                        label: context.l10n.navMore,
                        onTap: () => navigationShell.goBranch(3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.icon,
    required this.selected,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color active = context.palPrimary;
    final Color idle = context.palMuted;
    return Tooltip(
      message: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(WidgetSizesEnum.divider.value * 8),
                decoration: BoxDecoration(
                  color: selected ? context.palPrimarySoftBg : Colors.transparent,
                  borderRadius: BorderRadius.circular(WidgetSizesEnum.chipRadius.value),
                ),
                child: Icon(
                  icon,
                  color: selected ? active : idle,
                  size: IconSizesEnum.large.value,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
