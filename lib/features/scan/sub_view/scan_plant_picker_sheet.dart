import 'package:bitirme_mobile/core/enums/size_enum.dart';
import 'package:bitirme_mobile/core/locale/l10n_context.dart';
import 'package:bitirme_mobile/core/locale/species_class_display.dart';
import 'package:bitirme_mobile/core/theme/app_palette.dart';
import 'package:bitirme_mobile/gen/colors.gen.dart';
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
      final double maxHeight =
          MediaQuery.sizeOf(ctx).height * SheetSizesEnum.modalMaxHeightFraction.value;
      final double pad = WidgetSizesEnum.cardRadius.value;

      return SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              pad,
              WidgetSizesEnum.divider.value * 4,
              pad,
              bottomInset + pad,
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
                  (PlantModel plant) => Padding(
                    padding: EdgeInsets.only(
                      bottom: WidgetSizesEnum.cardRadius.value * 0.85,
                    ),
                    child: _PlantPickCard(
                      plant: plant,
                      onTap: () => Navigator.of(ctx).pop(
                        ScanPlantPickerOutcome.existing(plant),
                      ),
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
        ),
      );
    },
  );
}

class _PlantPickCard extends StatelessWidget {
  const _PlantPickCard({
    required this.plant,
    required this.onTap,
  });

  final PlantModel plant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final String species = speciesClassDisplayForRaw(context, plant.speciesLabel);
    final int? score = plant.lastHealthScore;
    final double photoHeight = ImageSizesEnum.plantPickerPhoto.value;

    return Material(
      color: context.palPrimarySoftBg,
      borderRadius: BorderRadius.circular(WidgetSizesEnum.cardRadius.value * 0.85),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: photoHeight,
              width: double.infinity,
              child: _PlantPhotoPreview(
                imageUrl: plant.photoUrl,
                borderRadius: BorderRadius.zero,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(WidgetSizesEnum.cardRadius.value * 0.75),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    plant.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: context.palOnSurface,
                        ),
                  ),
                  SizedBox(height: WidgetSizesEnum.divider.value * 4),
                  Text(
                    species,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: context.palMuted,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (score != null) ...<Widget>[
                    SizedBox(height: WidgetSizesEnum.divider.value * 3),
                    Text(
                      context.l10n.scanSavePlantLastHealth(score),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.palPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlantPhotoPreview extends StatelessWidget {
  const _PlantPhotoPreview({
    required this.imageUrl,
    required this.borderRadius,
  });

  final String? imageUrl;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final bool hasUrl = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: ColorName.primaryLight.withValues(alpha: 0.35),
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: hasUrl
            ? Image.network(
                imageUrl!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder(context),
              )
            : _placeholder(context),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return ColoredBox(
      color: context.palPrimarySoftBg,
      child: Center(
        child: Icon(
          Icons.local_florist_rounded,
          size: IconSizesEnum.xlarge.value * 1.4,
          color: context.palPrimary.withValues(alpha: 0.55),
        ),
      ),
    );
  }
}
