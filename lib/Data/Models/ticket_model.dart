class TicketModel {
  final int id;
  final String subject;
  final String description;
  final String unitName;
  final String categoryName;
  final String stageName;
  final String status;

  TicketModel({
    required this.id,
    required this.subject,
    required this.description,
    required this.unitName,
    required this.categoryName,
    required this.stageName,
    required this.status,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'],
      subject: json['subject'] ?? "",
      description: json['description'] ?? "",
      unitName: json['unit_name'] ?? "",
      categoryName: json['category_name'] ?? "",
      stageName: json['stage_name'] ?? "",
      status: json['state'] ?? "",
    );
  }
}
