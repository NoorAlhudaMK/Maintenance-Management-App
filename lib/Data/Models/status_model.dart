class StatusModel {
  final int id;
  final String name;
  final String code;

  StatusModel({required this.id, required this.name, required this.code});

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
    );
  }
}