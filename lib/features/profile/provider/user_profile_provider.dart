import 'dart:typed_data';

import 'package:bitirme_mobile/core/services/user_profile_firestore_service.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/models/user_profile_model.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AsyncNotifierProvider<UserProfileNotifier, UserProfileModel?> userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfileModel?>(UserProfileNotifier.new);

final class UserProfileNotifier extends AsyncNotifier<UserProfileModel?> {
  UserProfileFirestoreService get _service => sl<UserProfileFirestoreService>();

  @override
  Future<UserProfileModel?> build() async {
    final String? uid = ref.watch(authProvider).uid;
    if (uid == null || uid.isEmpty) {
      return null;
    }
    return _service.getProfile(uid: uid);
  }

  Future<void> reload() async {
    state = const AsyncLoading<UserProfileModel?>();
    state = AsyncData<UserProfileModel?>(await build());
  }

  Future<String?> updatePersonalInfo({
    required String displayName,
    required String phone,
    required String bio,
  }) async {
    final String? uid = ref.read(authProvider).uid;
    if (uid == null) {
      return null;
    }
    try {
      await _service.updateProfile(
        uid: uid,
        displayName: displayName.trim(),
        phone: phone.trim(),
        bio: bio.trim(),
      );
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null && displayName.trim().isNotEmpty) {
        await user.updateDisplayName(displayName.trim());
        await user.reload();
      }
      await ref.read(authProvider.notifier).saveSession(
            uid: uid,
            email: ref.read(authProvider).email ?? '',
            name: displayName.trim(),
          );
      await reload();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateProfilePhoto(Uint8List bytes) async {
    final String? uid = ref.read(authProvider).uid;
    if (uid == null) {
      return null;
    }
    try {
      final String? url = await _service.uploadProfilePhoto(uid: uid, bytes: bytes);
      if (url == null || url.isEmpty) {
        return 'upload_failed';
      }
      await _service.updateProfile(uid: uid, photoUrl: url);
      await reload();
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
