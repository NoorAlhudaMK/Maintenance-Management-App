import 'ticket_summary.dart';

class TeamMemberModel {
  final int id;
  final String name;
  final int teamId;
  final String teamName;
  final TicketSummary? ticketSummary;

  TeamMemberModel({
    required this.id,
    required this.name,
    required this.teamId,
    required this.teamName,
    this.ticketSummary,
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      teamId: json['team_id'] ?? 0,
      teamName: json['team_name'] ?? '',
      ticketSummary: json['ticket_summary'] != null
          ? TicketSummary.fromJson(json['ticket_summary'])
          : null,
    );
  }
}