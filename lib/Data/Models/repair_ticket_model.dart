
class RepairTicketModel {
  final int id;
  final String name;
  final String title;
  final String unitName;
  final String buildingName;
  final String status;

  RepairTicketModel({
    required this.id,
    required this.name,
    required this.title,
    required this.unitName,
    required this.buildingName,
    required this.status,
  });

  factory RepairTicketModel.fromJson(Map<String, dynamic> json) {
    return RepairTicketModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      title: json['title'] ?? json['subject'] ?? '',
      unitName: json['unit_name'] ?? '',
      buildingName: json['building_name'] ?? '',
      status: json['status'] ?? json['stage_name'] ?? '',
    );
  }
}