import 'package:bitirme_mobile/core/enums/firestore_collection_enum.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/models/plant_scan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Tarama geçmişi: [scans] koleksiyonu. Her kayıt [plants] içindeki bir bitkiye bağlıdır.
class PlantScansFirestoreService {
  PlantScansFirestoreService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Görseli olmayan eski tarama kayıtlarını siler (Geçmiş / Sağlık ilerlemesi aynı koleksiyonu kullanır).
  Future<int> purgeScansWithoutImage({required String ownerUid}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snap = await _db
          .collection(FirestoreCollectionEnum.scans.value)
          .where('ownerUid', isEqualTo: ownerUid)
          .get();

      final List<DocumentReference<Map<String, dynamic>>> toDelete =
          <DocumentReference<Map<String, dynamic>>>[];

      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in snap.docs) {
        final PlantScanModel? scan = PlantScanModel.fromJson(
          <String, dynamic>{...doc.data(), 'id': doc.id},
        );
        if (scan != null && !scan.hasStoredImage) {
          toDelete.add(doc.reference);
        }
      }

      if (toDelete.isEmpty) {
        return 0;
      }

      const int batchLimit = 400;
      for (int i = 0; i < toDelete.length; i += batchLimit) {
        final WriteBatch batch = _db.batch();
        final int end = (i + batchLimit < toDelete.length)
            ? i + batchLimit
            : toDelete.length;
        for (int j = i; j < end; j++) {
          batch.delete(toDelete[j]);
        }
        await batch.commit();
      }

      _logger.i('Purged ${toDelete.length} scans without image for $ownerUid');
      return toDelete.length;
    } catch (e, st) {
      _logger.e('Firestore purge scans without image', e, st);
      return 0;
    }
  }

  /// Kullanıcının son taramalarını listeler (limitli).
  Future<List<PlantScanModel>> listUserScans({
    required String ownerUid,
    int limit = 60,
  }) async {
    await purgeScansWithoutImage(ownerUid: ownerUid);
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
                PlantScanModel.fromJson(
                  <String, dynamic>{...d.data(), 'id': d.id},
                ),
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
    await purgeScansWithoutImage(ownerUid: ownerUid);
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
                PlantScanModel.fromJson(
                  <String, dynamic>{...d.data(), 'id': d.id},
                ),
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
