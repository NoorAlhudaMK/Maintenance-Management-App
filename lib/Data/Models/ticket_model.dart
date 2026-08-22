class TicketModel {
  final int id;
  final String title;
  final String description;
  final String unitName;
  final String categoryName;
  final String stageName;
  final String status;
  final String priorityName;
  final String createdDate;
  final String residentName;

  TicketModel({
    required this.id,
    required this.title,
    required this.description,
    required this.unitName,
    required this.categoryName,
    required this.stageName,
    required this.status,
    required this.priorityName,
    required this.createdDate,
    required this.residentName,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      unitName: json['unit_name'] ?? "",
      categoryName: json['category_name'] ?? "",
      stageName: json['stage_name'] ?? "",
      status: json['status'] ?? "",
      priorityName: json['priority_name'] ?? "",
      createdDate: json['created_date'] ?? "",
      residentName: json['resident']?['full_name'] ?? "",
    );
  }
}