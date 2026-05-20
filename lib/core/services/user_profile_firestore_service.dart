import 'dart:typed_data';

import 'package:bitirme_mobile/core/enums/firestore_collection_enum.dart';
import 'package:bitirme_mobile/core/services/app_logger.dart';
import 'package:bitirme_mobile/core/services/firebase_storage_service.dart';
import 'package:bitirme_mobile/models/user_profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// [users/{uid}] belgesinde profil okuma/yazma.
class UserProfileFirestoreService {
  UserProfileFirestoreService({
    required AppLogger logger,
    required FirebaseStorageService storage,
  })  : _logger = logger,
        _storage = storage;

  final AppLogger _logger;
  final FirebaseStorageService _storage;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserProfileModel?> getProfile({required String uid}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snap = await _db
          .collection(FirestoreCollectionEnum.users.value)
          .doc(uid)
          .get();
      if (!snap.exists || snap.data() == null) {
        return null;
      }
      return UserProfileModel.fromJson(uid, snap.data());
    } catch (e, st) {
      _logger.e('Firestore get user profile', e, st);
      return null;
    }
  }

  Future<void> upsertFromFirebaseUser(
    User user, {
    required String authProvider,
  }) async {
    try {
      final String uid = user.uid;
      final String email = user.email ?? '';
      final String displayName = user.displayName ??
          (email.contains('@') ? email.split('@').first : email);
      final DocumentReference<Map<String, dynamic>> ref =
          _db.collection(FirestoreCollectionEnum.users.value).doc(uid);
      final DocumentSnapshot<Map<String, dynamic>> snap = await ref.get();
      final Map<String, dynamic> data = <String, dynamic>{
        'email': email,
        'displayName': displayName,
        'authProvider': authProvider,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (user.photoURL != null && user.photoURL!.isNotEmpty) {
        final String? existingPhoto = snap.data()?['photoUrl'] as String?;
        if (existingPhoto == null || existingPhoto.isEmpty) {
          data['photoUrl'] = user.photoURL;
        }
      }
      if (!snap.exists) {
        data['createdAt'] = FieldValue.serverTimestamp();
      }
      await ref.set(data, SetOptions(merge: true));
    } catch (e, st) {
      _logger.e('Firestore user upsert', e, st);
    }
  }

  Future<void> updateProfile({
    required String uid,
    String? displayName,
    String? email,
    String? phone,
    String? bio,
    String? photoUrl,
  }) async {
    try {
      final Map<String, dynamic> data = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (displayName != null) {
        data['displayName'] = displayName;
      }
      if (email != null) {
        data['email'] = email;
      }
      if (phone != null) {
        data['phone'] = phone;
      }
      if (bio != null) {
        data['bio'] = bio;
      }
      if (photoUrl != null) {
        data['photoUrl'] = photoUrl;
      }
      await _db
          .collection(FirestoreCollectionEnum.users.value)
          .doc(uid)
          .set(data, SetOptions(merge: true));
    } catch (e, st) {
      _logger.e('Firestore update user profile', e, st);
      rethrow;
    }
  }

  Future<String?> uploadProfilePhoto({
    required String uid,
    required Uint8List bytes,
  }) async {
    try {
      return _storage.uploadJpegBytes(
        path: 'users/$uid/profile.jpg',
        bytes: bytes,
      );
    } catch (e, st) {
      _logger.e('Profile photo upload', e, st);
      return null;
    }
  }
}
