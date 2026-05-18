import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Firestore `users/{uid}` profil belgesi.
class UserProfileModel extends Equatable {
  const UserProfileModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.authProvider,
    required this.createdAt,
    this.photoUrl,
    this.phone,
    this.bio,
    this.updatedAt,
  });

  final String uid;
  final String email;
  final String displayName;
  final String authProvider;
  final DateTime createdAt;
  final String? photoUrl;
  final String? phone;
  final String? bio;
  final DateTime? updatedAt;

  UserProfileModel copyWith({
    String? displayName,
    String? photoUrl,
    String? phone,
    String? bio,
    DateTime? updatedAt,
  }) {
    return UserProfileModel(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      authProvider: authProvider,
      createdAt: createdAt,
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'email': email,
      'displayName': displayName,
      'authProvider': authProvider,
      'createdAt': Timestamp.fromDate(createdAt),
      'photoUrl': photoUrl,
      'phone': phone,
      'bio': bio,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : FieldValue.serverTimestamp(),
    };
  }

  static UserProfileModel? fromJson(String uid, Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    final String email = json['email'] as String? ?? '';
    final String displayName = json['displayName'] as String? ?? '';
    final String authProvider = json['authProvider'] as String? ?? 'email';
    final DateTime createdAt =
        (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();

    return UserProfileModel(
      uid: uid,
      email: email,
      displayName: displayName,
      authProvider: authProvider,
      createdAt: createdAt,
      photoUrl: json['photoUrl'] as String?,
      phone: json['phone'] as String?,
      bio: json['bio'] as String?,
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  @override
  List<Object?> get props => <Object?>[
        uid,
        email,
        displayName,
        authProvider,
        createdAt,
        photoUrl,
        phone,
        bio,
        updatedAt,
      ];
}
