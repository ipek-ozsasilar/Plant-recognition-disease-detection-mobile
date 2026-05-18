import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/models/plant_model.dart';
import 'package:flutter/material.dart';

/// Kayıt hedefi: mevcut bitki veya yeni saksı.
final class ScanPlantPickerOutcome {
  const ScanPlantPickerOutcome.existing(this.plant) : createNew = false;

  const ScanPlantPickerOutcome.newPlant() : plant = null, createNew = true;

  final PlantModel? plant;
  final bool createNew;
}

/// Tarama kaydında aynı türden hangi fiziksel bitkiye yazılacağını seçtirir.
Future<ScanPlantPickerOutcome?> showScanPlantPickerSheet({
  required BuildContext context,
  required List<PlantModel> existingPlants,
}) {
  return showModalBottomSheet<ScanPlantPickerOutcome>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: context.palSurfaceCard,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(WidgetSizesEnum.cardRadius.value * 1.2),
      ),
    ),
    builder: (BuildContext ctx) {
      final double bottomInset = MediaQuery.paddingOf(ctx).bottom;
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            WidgetSizesEnum.cardRadius.value,
            WidgetSizesEnum.divider.value * 4,
            WidgetSizesEnum.cardRadius.value,
            bottomInset + WidgetSizesEnum.cardRadius.value,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                ctx.l10n.scanSaveToPlantTitle,
                style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: ctx.palOnSurface,
                    ),
              ),
              SizedBox(height: WidgetSizesEnum.divider.value * 6),
              Text(
                ctx.l10n.scanSavePickPlantSubtitle,
                style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                      color: ctx.palMuted,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
              ),
              SizedBox(height: WidgetSizesEnum.cardRadius.value),
              ...existingPlants.map(
                (PlantModel plant) => ListTile(
                  leading: Icon(Icons.local_florist_rounded, color: ctx.palPrimary),
                  title: Text(
                    plant.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: ctx.palOnSurface,
                    ),
                  ),
                  onTap: () => Navigator.of(ctx).pop(
                    ScanPlantPickerOutcome.existing(plant),
                  ),
                ),
              ),
              SizedBox(height: WidgetSizesEnum.divider.value * 4),
              FilledButton.icon(
                onPressed: () => Navigator.of(ctx).pop(
                  const ScanPlantPickerOutcome.newPlant(),
                ),
                icon: const Icon(Icons.add_rounded),
                label: Text(ctx.l10n.scanSaveNewPlant),
                style: FilledButton.styleFrom(
                  backgroundColor: ctx.palPrimary,
                  foregroundColor: ctx.palOnPrimary,
                  padding: EdgeInsets.symmetric(
                    vertical: WidgetSizesEnum.cardRadius.value * 0.75,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
