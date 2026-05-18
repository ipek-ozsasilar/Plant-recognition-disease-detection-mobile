import 'package:bitirme_mobile/core/enums/home_daily_tip_kind_enum.dart';
import 'package:bitirme_mobile/core/locale/species_class_display.dart';
import 'package:bitirme_mobile/core/services/home_daily_tip_service.dart';
import 'package:bitirme_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

String homeDailyTipBodyForResult({
  required BuildContext context,
  required AppLocalizations l10n,
  required HomeDailyTipResult result,
}) {
  final String? species = result.focusSpeciesLabel;
  final String speciesName = species != null
      ? speciesClassDisplayForRaw(context, species)
      : '';

  switch (result.kind) {
    case HomeDailyTipKindEnum.defaultPhoto:
      return l10n.homeTipBody;
    case HomeDailyTipKindEnum.blight:
      return speciesName.isEmpty ? l10n.homeTipBlight : l10n.homeTipBlightFor(speciesName);
    case HomeDailyTipKindEnum.mold:
      return speciesName.isEmpty ? l10n.homeTipMold : l10n.homeTipMoldFor(speciesName);
    case HomeDailyTipKindEnum.powderyMildew:
      return speciesName.isEmpty
          ? l10n.homeTipPowderyMildew
          : l10n.homeTipPowderyMildewFor(speciesName);
    case HomeDailyTipKindEnum.rust:
      return speciesName.isEmpty ? l10n.homeTipRust : l10n.homeTipRustFor(speciesName);
    case HomeDailyTipKindEnum.healthy:
      return speciesName.isEmpty ? l10n.homeTipHealthy : l10n.homeTipHealthyFor(speciesName);
    case HomeDailyTipKindEnum.mixedRisk:
      return speciesName.isEmpty ? l10n.homeTipMixedRisk : l10n.homeTipMixedRiskFor(speciesName);
  }
}
