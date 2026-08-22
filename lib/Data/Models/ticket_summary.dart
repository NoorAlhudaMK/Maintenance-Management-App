class TicketSummary {
  final int total;
  final int open;
  final int inProgress;
  final int pending;
  final int resolved;
  final int closed;
  final int completed;

  TicketSummary({
    required this.total,
    required this.open,
    required this.inProgress,
    required this.pending,
    required this.resolved,
    required this.closed,
    required this.completed,
  });

  factory TicketSummary.fromJson(Map<String, dynamic> json) {
    return TicketSummary(
      total: json['total'] ?? 0,
      open: json['open'] ?? 0,
      inProgress: json['in_progress'] ?? 0,
      pending: json['pending'] ?? 0,
      resolved: json['resolved'] ?? 0,
      closed: json['closed'] ?? 0,
      completed: json['completed'] ?? 0,
    );
  }
}