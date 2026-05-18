import 'package:bitirme_mobile/core/enums/firestore_collection_enum.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/models/plant_scan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Tarama geçmişi: [scans] koleksiyonu. Her kayıt [plants] içindeki bir bitkiye bağlıdır.
class PlantScansFirestoreService {
  PlantScansFirestoreService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Kullanıcının son taramalarını listeler (limitli).
  Future<List<PlantScanModel>> listUserScans({
    required String ownerUid,
    int limit = 60,
  }) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snap = await _db
          .collection(FirestoreCollectionEnum.scans.value)
          .where('ownerUid', isEqualTo: ownerUid)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();
      return snap.docs
          .map(
            (QueryDocumentSnapshot<Map<String, dynamic>> d) =>
                PlantScanModel.fromJson(d.data()),
          )
          .whereType<PlantScanModel>()
          .toList(growable: false);
    } catch (e, st) {
      _logger.e('Firestore list user scans', e, st);
      return <PlantScanModel>[];
    }
  }

  Future<List<PlantScanModel>> listScans({
    required String ownerUid,
    required String plantId,
    int limit = 60,
  }) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snap = await _db
          .collection(FirestoreCollectionEnum.scans.value)
          .where('ownerUid', isEqualTo: ownerUid)
          .where('plantId', isEqualTo: plantId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();
      return snap.docs
          .map(
            (QueryDocumentSnapshot<Map<String, dynamic>> d) =>
                PlantScanModel.fromJson(d.data()),
          )
          .whereType<PlantScanModel>()
          .toList(growable: false);
    } catch (e, st) {
      _logger.e('Firestore list scans', e, st);
      return <PlantScanModel>[];
    }
  }

  /// Yeni bir tarama kaydeder ve eşzamanlı olarak [plants] koleksiyonundaki
  /// ilgili bitkinin son sağlık skorunu ve tarihini günceller.
  Future<void> addScan(PlantScanModel scan) async {
    try {
      final WriteBatch batch = _db.batch();

      // 1. Tarama kaydını oluştur
      final DocumentReference<Map<String, dynamic>> scanRef = _db
          .collection(FirestoreCollectionEnum.scans.value)
          .doc(scan.id);
      batch.set(scanRef, scan.toJson());

      if (scan.plantId.isNotEmpty) {
        final DocumentReference<Map<String, dynamic>> plantRef = _db
            .collection(FirestoreCollectionEnum.plants.value)
            .doc(scan.plantId);

        batch.set(
          plantRef,
          <String, dynamic>{
            'lastHealthScore': scan.healthScore,
            'lastScanDate': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
            'speciesLabel': scan.speciesLabel,
            if (scan.imageUrl != null && scan.imageUrl!.isNotEmpty)
              'photoUrl': scan.imageUrl,
          },
          SetOptions(merge: true),
        );
      }

      await batch.commit();
      _logger.i('Scan added and plant updated: ${scan.id}');
    } catch (e, st) {
      _logger.e('Firestore add scan', e, st);
      rethrow;
    }
  }
}
