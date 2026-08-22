class PriorityModel {
  final String id;
  final String code;
  final String name;

  PriorityModel({required this.id, required this.code, required this.name});

  factory PriorityModel.fromJson(Map<String, dynamic> json) {
    return PriorityModel(
      id: json['id'].toString(),
      code: json['code'].toString(),
      name: json['name'],
    );
  }
}