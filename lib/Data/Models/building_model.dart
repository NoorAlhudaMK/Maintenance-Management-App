class BuildingModel {
  final int id;
  final String name;
  final String code;
  final String address;
  final double latitude;
  final double longitude;

  BuildingModel({
    required this.id,
    required this.name,
    required this.code,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory BuildingModel.fromJson(Map<String, dynamic> json) {
    return BuildingModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}