import 'package:bitirme_mobile/core/enums/inference_threshold_enum.dart';
import 'package:bitirme_mobile/core/utils/confidence_format.dart';
import 'package:bitirme_mobile/l10n/app_localizations.dart';
import 'package:bitirme_mobile/models/inference_result_model.dart';
import 'package:bitirme_mobile/models/plant_scan_model.dart';

/// Geçmişe kayıtta hastalık tanınmadığında saklanan anahtar.
const String kStoredDiseaseKeyUnknown = 'unknown';

bool _isUnknownLikeKey(String key) {
  final String normalized = key.trim().toLowerCase();
  if (normalized.isEmpty) {
    return true;
  }
  if (normalized == kStoredDiseaseKeyUnknown || normalized.contains('unknown')) {
    return true;
  }
  if (normalized.contains('tanınmadı') || normalized.contains('taninmadi')) {
    return true;
  }
  return false;
}

bool isDiseaseConfidenceUnrecognized(double diseaseConfidenceUnit) {
  return confidenceToUnit(diseaseConfidenceUnit) <
      InferenceThresholdEnum.unrecognizedGlobal.value;
}

/// Canlı tahmin çıktısı tanınmadı sayılır mı?
bool isDiseaseInferenceUnrecognized(InferenceResultModel disease) {
  if (isDiseaseConfidenceUnrecognized(disease.top.confidence)) {
    return true;
  }
  final String raw = (disease.top.rawKey ?? disease.top.label).trim();
  return _isUnknownLikeKey(raw);
}

/// Firestore kaydı geçmişte "Hastalık bilinmiyor" olarak gösterilmeli mi?
bool isStoredDiseaseUnknown(PlantScanModel scan) {
  if (_isUnknownLikeKey(scan.diseaseKey)) {
    return true;
  }
  if (scan.diseaseConfidence <= 0) {
    return true;
  }
  return isDiseaseConfidenceUnrecognized(scan.diseaseConfidence);
}

/// Geçmiş, ana sayfa ve PDF için hastalık satırı.
String diseaseDisplayForScan(PlantScanModel scan, AppLocalizations l10n) {
  if (isStoredDiseaseUnknown(scan)) {
    return l10n.historyDiseaseUnknown;
  }
  return diseaseClassKeyToDisplay(scan.diseaseKey, l10n);
}

/// Özet ekranında hastalık satırı (tanınmadıysa geçmiş ile aynı metin).
String diseaseDisplayForInference(
  InferenceClassScoreModel top,
  AppLocalizations l10n, {
  required bool unrecognized,
}) {
  if (unrecognized) {
    return l10n.historyDiseaseUnknown;
  }
  final String raw = (top.rawKey ?? top.label).trim();
  return diseaseClassKeyToDisplay(raw, l10n);
}

/// Model çıktısından Firestore `diseaseKey` değeri.
String diseaseKeyForScanStorage({
  required bool diseaseUnrecognized,
  required String modelLabel,
}) {
  final String raw = modelLabel.trim();
  if (diseaseUnrecognized || _isUnknownLikeKey(raw)) {
    return kStoredDiseaseKeyUnknown;
  }
  return raw;
}

/// [disease_class_names_5class.json] anahtarını arayüz metnine çevirir.
String diseaseClassKeyToDisplay(String key, AppLocalizations l10n) {
  final String normalized = key.trim().toLowerCase();
  if (_isUnknownLikeKey(normalized)) {
    return l10n.historyDiseaseUnknown;
  }
  switch (normalized) {
    case 'blight':
      return l10n.inferenceDiseaseBlight;
    case 'chlorosis_yellowing':
      return l10n.inferenceDiseaseChlorosisYellowing;
    case 'healthy':
      return l10n.inferenceDiseaseHealthy;
    case 'leaf_damage':
      return l10n.inferenceDiseaseLeafDamage;
    case 'leaf_disease':
    case 'leaf_spot':
      return l10n.inferenceDiseaseLeafSpot;
    case 'mold':
      return l10n.inferenceDiseaseMold;
    case 'pest_damage':
      return l10n.inferenceDiseasePestDamage;
    case 'powdery_mildew':
      return l10n.inferenceDiseasePowderyMildew;
    case 'rot':
      return l10n.inferenceDiseaseRot;
    case 'rust':
      return l10n.inferenceDiseaseRust;
    case 'scab':
      return l10n.inferenceDiseaseScab;
    case 'viral_mosaic':
      return l10n.inferenceDiseaseViralMosaic;
    default:
      return key.replaceAll('_', ' ');
  }
}

/// Geçmişte Türkçe metin saklanmış kayıtlar için: anahtar biçimindeyse çevir.
String displayStoredDiseaseLabel(String stored, AppLocalizations l10n) {
  if (_isUnknownLikeKey(stored)) {
    return l10n.historyDiseaseUnknown;
  }
  if (RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(stored.trim())) {
    return diseaseClassKeyToDisplay(stored, l10n);
  }
  return stored;
}
