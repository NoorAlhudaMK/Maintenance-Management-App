class MaintenanceStatusModel {
  final int id;
  final String name;
  final String code;
  final int sequence;

  MaintenanceStatusModel({
    required this.id,
    required this.name,
    required this.code,
    required this.sequence,
  });

  factory MaintenanceStatusModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceStatusModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      sequence: json['sequence'] ?? 0,
    );
  }
}