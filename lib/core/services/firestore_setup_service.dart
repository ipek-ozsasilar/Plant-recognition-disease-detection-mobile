import 'package:bitirme_mobile/core/enums/firestore_collection_enum.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Firestore database yapısını başlatır ve test verisi ekler.
class FirestoreSetupService {
  FirestoreSetupService({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// İlk kez login olan kullanıcı için Firestore yapısını hazırlar.
  Future<void> initializeUserData({
    required String uid,
    required String email,
    required String displayName,
  }) async {
    try {
      _logger.i('Firestore user initialization starting for uid: $uid');

      // Okuma (get) kontrolünü kaldırıyoruz.
      // _createUserProfile içindeki set(merge: true) işlemi zaten güvenli.

      // 2. User profil oluştur
      await _createUserProfile(uid, email, displayName);

      _logger.i('Firestore user profile initialized for: $uid');
    } catch (e, st) {
      _logger.e('Firestore initialization failed', e, st);
      rethrow;
    }
  }

  /// Kullanıcı profil belgesi oluşturur.
  Future<void> _createUserProfile(
    String uid,
    String email,
    String displayName,
  ) async {
    try {
      // createdAt değerini sadece döküman yoksa eklemek için
      // serverTimestamp() kullanan set(merge: true) yapısı uygundur.
      await _db
          .collection(FirestoreCollectionEnum.users.value)
          .doc(uid)
          .set(<String, dynamic>{
            'email': email,
            'displayName': displayName,
            'authProvider': _auth.currentUser?.providerData.isNotEmpty == true
                ? _auth.currentUser!.providerData.first.providerId
                : 'email',
            'photoUrl': _auth.currentUser?.photoURL,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      // Not: Eğer her girişte 'createdAt' bilgisini de set ederseniz merge:true olsa bile üzerine yazar.
      // Gerçekten döküman var mı yok mu kontrolü yapmak için 'get()' gerekir,
      // bu da yukarıdaki Rules (Kural) hatasını çözmeden çalışmaz.
      _logger.i('User profile synced: $uid');
    } catch (e, st) {
      _logger.e('Failed to create user profile', e, st);
      rethrow;
    }
  }

  /// Tüm kullanıcı verilerini siler (debug/test için).
  Future<void> deleteAllUserData({required String uid}) async {
    try {
      _logger.w('Deleting all data for user: $uid');

      // Plants sil
      final plants = await _db
          .collection(FirestoreCollectionEnum.plants.value)
          .where('ownerUid', isEqualTo: uid)
          .get();
      for (final doc in plants.docs) {
        await doc.reference.delete();
      }

      final QuerySnapshot<Map<String, dynamic>> scans = await _db
          .collection(FirestoreCollectionEnum.scans.value)
          .where('ownerUid', isEqualTo: uid)
          .get();
      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in scans.docs) {
        await doc.reference.delete();
      }

      // User sil
      await _db
          .collection(FirestoreCollectionEnum.users.value)
          .doc(uid)
          .delete();

      _logger.i('All user data deleted');
    } catch (e, st) {
      _logger.e('Failed to delete user data', e, st);
      rethrow;
    }
  }
}
