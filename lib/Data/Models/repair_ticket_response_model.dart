import 'repair_ticket_model.dart';

class RepairTicketResponse {
  final bool success;
  final String message;
  final RepairTicketModel? ticket;

  RepairTicketResponse({
    required this.success,
    required this.message,
    this.ticket,
  });

  factory RepairTicketResponse.fromJson(Map<String, dynamic> json) {
    var ticketData = json['data']?['ticket'] ?? json['ticket'];
    return RepairTicketResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      ticket: ticketData != null ? RepairTicketModel.fromJson(ticketData) : null,
    );
  }
}
