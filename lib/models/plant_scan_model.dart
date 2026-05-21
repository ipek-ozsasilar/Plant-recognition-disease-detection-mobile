import 'package:bitirme_mobile/models/plant_region_model.dart';
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
    this.thumbnailUrl,
    this.regionMarkers,
    this.regionIndex,
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

  /// Tam fotoğraf (çoklu bölgede) veya tek bölge kırpımı.
  final String? imageUrl;

  /// Liste küçük görseli; çoklu bölgede kırpılmış bölge fotoğrafı.
  final String? thumbnailUrl;

  /// Çoklu bölge seçiminde tüm dikdörtgenler (normalize).
  final List<PlantRegionModel>? regionMarkers;

  /// Bu kaydın hangi bölgeye ait olduğu (0 tabanlı).
  final int? regionIndex;

  final String? notes;

  bool get hasRegionOverlay =>
      regionMarkers != null && regionMarkers!.isNotEmpty;

  /// Geçmiş / detayda tam fotoğraf.
  String? get fullImageUrl => imageUrl;

  /// Liste önizlemesi.
  String? get listThumbnailUrl =>
      thumbnailUrl != null && thumbnailUrl!.isNotEmpty ? thumbnailUrl : imageUrl;

  /// Firebase Storage / Firestore görsel alanı dolu mu.
  bool get hasStoredImage {
    final String? full = imageUrl?.trim();
    final String? thumb = thumbnailUrl?.trim();
    return (full != null && full.isNotEmpty) ||
        (thumb != null && thumb.isNotEmpty);
  }

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
      if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty)
        'thumbnailUrl': thumbnailUrl,
      if (regionMarkers != null && regionMarkers!.isNotEmpty)
        'regionMarkers': PlantRegionModel.listToJson(regionMarkers!),
      if (regionIndex != null) 'regionIndex': regionIndex,
      'notes': notes,
    };
  }

  static String? _optionalString(Map<String, dynamic> json, String key) {
    final String? v = json[key] as String?;
    if (v == null || v.trim().isEmpty) {
      return null;
    }
    return v.trim();
  }

  static String? _imageUrlFromJson(Map<String, dynamic> json) {
    final String? direct = _optionalString(json, 'imageUrl');
    if (direct != null) {
      return direct;
    }
    return _optionalString(json, 'photoUrl');
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

    final DateTime createdAt =
        (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
    final List<PlantRegionModel> markers =
        PlantRegionModel.listFromJson(json['regionMarkers']);

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
      thumbnailUrl: _optionalString(json, 'thumbnailUrl'),
      regionMarkers: markers.isEmpty ? null : markers,
      regionIndex: (json['regionIndex'] as num?)?.toInt(),
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
        thumbnailUrl,
        regionMarkers,
        regionIndex,
        notes,
      ];
}
