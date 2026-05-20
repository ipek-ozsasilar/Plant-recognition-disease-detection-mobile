import 'package:bitirme_mobile/l10n/app_localizations.dart';

/// [FirebaseAuthException.code] için kullanıcıya gösterilecek mesaj.
String firebaseAuthCodeToMessage(String code, AppLocalizations l10n) {
  switch (code) {
    case 'email-already-in-use':
      return l10n.errorAuthEmailInUse;
    case 'weak-password':
      return l10n.errorAuthWeakPassword;
    case 'invalid-email':
      return l10n.errorAuthInvalidEmail;
    case 'user-not-found':
      return l10n.errorAuthUserNotFound;
    case 'wrong-password':
      return l10n.errorAuthWrongPassword;
    case 'invalid-credential':
    case 'invalid-login-credentials':
      return l10n.errorAuthInvalidCredential;
    case 'user-disabled':
      return l10n.errorAuthUserDisabled;
    case 'too-many-requests':
      return l10n.errorAuthTooManyRequests;
    case 'operation-not-allowed':
      return l10n.errorAuthOperationNotAllowed;
    case 'requires-recent-login':
      return l10n.errorAuthRequiresRecentLogin;
    default:
      return l10n.errorAuth;
  }
}
