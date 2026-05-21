import 'package:equatable/equatable.dart';

/// Görüntü üzerinde normalize (0–1) dikdörtgen bölge.
class PlantRegionModel extends Equatable {
  const PlantRegionModel({
    required this.id,
    required this.nx,
    required this.ny,
    required this.nw,
    required this.nh,
  });

  final String id;
  final double nx;
  final double ny;
  final double nw;
  final double nh;

  PlantRegionModel copyWith({
    String? id,
    double? nx,
    double? ny,
    double? nw,
    double? nh,
  }) {
    return PlantRegionModel(
      id: id ?? this.id,
      nx: nx ?? this.nx,
      ny: ny ?? this.ny,
      nw: nw ?? this.nw,
      nh: nh ?? this.nh,
    );
  }

  Map<String, Object?> toJson() => <String, Object?>{
        'id': id,
        'nx': nx,
        'ny': ny,
        'nw': nw,
        'nh': nh,
      };

  static PlantRegionModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return PlantRegionModel(
      id: json['id'] as String? ?? '',
      nx: (json['nx'] as num?)?.toDouble() ?? 0,
      ny: (json['ny'] as num?)?.toDouble() ?? 0,
      nw: (json['nw'] as num?)?.toDouble() ?? 0,
      nh: (json['nh'] as num?)?.toDouble() ?? 0,
    );
  }

  static List<PlantRegionModel> listFromJson(dynamic raw) {
    if (raw is! List<dynamic>) {
      return <PlantRegionModel>[];
    }
    final List<PlantRegionModel> out = <PlantRegionModel>[];
    for (final dynamic e in raw) {
      if (e is Map<String, dynamic>) {
        final PlantRegionModel? r = fromJson(e);
        if (r != null) {
          out.add(r);
        }
      }
    }
    return out;
  }

  static List<Map<String, Object?>> listToJson(List<PlantRegionModel> regions) =>
      regions.map((PlantRegionModel r) => r.toJson()).toList();

  @override
  List<Object?> get props => <Object?>[id, nx, ny, nw, nh];
}
