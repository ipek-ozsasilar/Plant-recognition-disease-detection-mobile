import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Bir bitki için günlük/tekil tarama kaydı.
class PlantScanModel extends Equatable {
  const PlantScanModel({
    required this.id,
    required this.ownerUid,
    required this.plantId,
    required this.createdAt,
    required this.speciesLabel,
    required this.speciesConfidence,
    required this.diseaseKey,
    required this.diseaseConfidence,
    required this.healthScore,
    this.imageUrl,
    this.notes,
  });

  final String id;
  final String ownerUid;
  final String plantId;
  final DateTime createdAt;
  final String speciesLabel;
  final double speciesConfidence;
  final String diseaseKey;
  final double diseaseConfidence;

  /// 0..100 — grafik için tek metrik.
  final int healthScore;

  final String? imageUrl;
  final String? notes;

  /// Firebase Storage / Firestore `imageUrl` veya `photoUrl` dolu mu.
  bool get hasStoredImage =>
      imageUrl != null && imageUrl!.trim().isNotEmpty;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'ownerUid': ownerUid,
      'plantId': plantId,
      'createdAt': Timestamp.fromDate(createdAt),
      'speciesLabel': speciesLabel,
      'speciesConfidence': speciesConfidence,
      'diseaseKey': diseaseKey,
      'diseaseConfidence': diseaseConfidence,
      'healthScore': healthScore,
      'imageUrl': imageUrl,
      'notes': notes,
    };
  }

  static String? _imageUrlFromJson(Map<String, dynamic> json) {
    final String? direct = json['imageUrl'] as String?;
    if (direct != null && direct.trim().isNotEmpty) {
      return direct.trim();
    }
    final String? legacy = json['photoUrl'] as String?;
    if (legacy != null && legacy.trim().isNotEmpty) {
      return legacy.trim();
    }
    return null;
  }

  static PlantScanModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    final String? id = json['id'] as String?;
    final String? ownerUid = json['ownerUid'] as String?;
    final String? plantId = json['plantId'] as String?;

    if (id == null || ownerUid == null || plantId == null) {
      return null;
    }

    final DateTime createdAt = (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();

    return PlantScanModel(
      id: id,
      ownerUid: ownerUid,
      plantId: plantId,
      createdAt: createdAt,
      speciesLabel: json['speciesLabel'] as String? ?? '',
      speciesConfidence: (json['speciesConfidence'] as num?)?.toDouble() ?? 0,
      diseaseKey: json['diseaseKey'] as String? ?? '',
      diseaseConfidence: (json['diseaseConfidence'] as num?)?.toDouble() ?? 0,
      healthScore: (json['healthScore'] as num?)?.toInt() ?? 0,
      imageUrl: _imageUrlFromJson(json),
      notes: json['notes'] as String?,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        ownerUid,
        plantId,
        createdAt,
        speciesLabel,
        speciesConfidence,
        diseaseKey,
        diseaseConfidence,
        healthScore,
        imageUrl,
        notes,
      ];
}
