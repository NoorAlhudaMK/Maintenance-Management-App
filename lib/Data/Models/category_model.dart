class CategoryModel {
  final int id;
  final String name;
  final int teamId;

  CategoryModel({
    required this.id,
    required this.name,
    required this.teamId,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      teamId: json['team_id'] ?? 0,
    );
  }
}