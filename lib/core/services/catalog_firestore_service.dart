import 'package:bitirme_mobile/core/enums/firestore_collection_enum.dart';
import 'package:bitirme_mobile/core/services/disease_label_display.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/core/services/plantnet_species_name_repository.dart';
import 'package:bitirme_mobile/core/services/species_label_formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Model çıktılarındaki tür/hastalık anahtarlarını Firestore'da kataloglamak için servis.
///
/// Amaç: Kullanıcı tarama yaptıkça "species" ve "diseases" koleksiyonlarının otomatik dolması.
final class CatalogFirestoreService {
  CatalogFirestoreService({
    required AppLogger logger,
    required PlantnetSpeciesNameRepository plantnetNames,
  })  : _logger = logger,
        _plantnetNames = plantnetNames;

  final AppLogger _logger;
  final PlantnetSpeciesNameRepository _plantnetNames;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> ensureDisease({required String diseaseKey}) async {
    final String key = diseaseKey.trim();
    if (key.isEmpty || key == kStoredDiseaseKeyUnknown) {
      return;
    }
    try {
      final DocumentReference<Map<String, dynamic>> ref = _db
          .collection(FirestoreCollectionEnum.diseases.value)
          .doc(key);

      await ref.set(<String, dynamic>{
        'key': key,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e, st) {
      _logger.e('Firestore ensure disease', e, st);
    }
  }

  Future<void> ensureSpecies({required String rawLabel}) async {
    final String id = rawLabel.trim();
    if (id.isEmpty) {
      return;
    }
    try {
      final String source = id.contains('__') ? id.split('__').first : 'unknown';
      final String display = formatSpeciesRawLabel(
        id,
        plantnetMap: _plantnetNames.snapshot,
      );

      final DocumentReference<Map<String, dynamic>> ref =
          _db.collection(FirestoreCollectionEnum.species.value).doc(id);

      await ref.set(<String, dynamic>{
        'id': id,
        'rawLabel': id,
        'displayLabel': display,
        'source': source,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e, st) {
      _logger.e('Firestore ensure species', e, st);
    }
  }
}

