class TicketImageModel {
  final int id;
  final String filename;
  final String imageType;
  final String url;

  TicketImageModel({
    required this.id,
    required this.filename,
    required this.imageType,
    required this.url,
  });

  factory TicketImageModel.fromJson(Map<String, dynamic> json) {
    return TicketImageModel(
      id: json['id'] ?? 0,
      filename: json['filename'] ?? '',
      imageType: json['image_type'] ?? '',
      url: json['url'] ?? '',
    );
  }
}