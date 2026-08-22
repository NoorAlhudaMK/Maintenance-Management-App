import 'ticket_image_model.dart';

class TicketImageResponse {
  final bool success;
  final String message;
  final List<TicketImageModel> images;

  TicketImageResponse({
    required this.success,
    required this.message,
    required this.images,
  });

  factory TicketImageResponse.fromJson(Map<String, dynamic> json) {
    var imagesList = json['data']?['images'] ?? json['images'] ?? [];
    List<TicketImageModel> parsedImages = (imagesList as List)
        .map((img) => TicketImageModel.fromJson(img))
        .toList();

    return TicketImageResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      images: parsedImages,
    );
  }
}