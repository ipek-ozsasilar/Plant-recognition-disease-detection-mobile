import 'dart:typed_data';

import 'package:bitirme_mobile/core/services/firebase_auth_error_mapper.dart';
import 'package:bitirme_mobile/core/services/user_profile_firestore_service.dart';
import 'package:bitirme_mobile/features/auth/provider/auth_provider.dart';
import 'package:bitirme_mobile/l10n/app_localizations.dart';
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
    required String email,
    required String phone,
    required String bio,
    required AppLocalizations l10n,
  }) async {
    final String? uid = ref.read(authProvider).uid;
    if (uid == null) {
      return null;
    }
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final UserProfileModel? profile = await _service.getProfile(uid: uid);
      final bool isGoogleAccount = profile?.authProvider == 'google';
      final String trimmedName = displayName.trim();
      final String trimmedEmail = email.trim();
      final String trimmedPhone = phone.trim();
      final String trimmedBio = bio.trim();

      if (trimmedEmail.isEmpty) {
        return l10n.errorAuthInvalidEmail;
      }

      if (user != null) {
        final String currentEmail = user.email ?? '';
        if (trimmedEmail != currentEmail) {
          if (isGoogleAccount) {
            return l10n.profileEmailGoogleHint;
          }
          await user.verifyBeforeUpdateEmail(trimmedEmail);
        }
        if (trimmedName.isNotEmpty) {
          await user.updateDisplayName(trimmedName);
        }
        await user.reload();
      }

      await _service.updateProfile(
        uid: uid,
        displayName: trimmedName,
        email: trimmedEmail,
        phone: trimmedPhone,
        bio: trimmedBio,
      );

      final String sessionEmail =
          user?.email ?? trimmedEmail;
      await ref.read(authProvider.notifier).saveSession(
            uid: uid,
            email: sessionEmail,
            name: trimmedName,
          );
      await reload();
      return null;
    } on FirebaseAuthException catch (e) {
      return firebaseAuthCodeToMessage(e.code, l10n);
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
