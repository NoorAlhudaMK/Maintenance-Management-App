class TeamMemberModel {
  final int id;
  final int memberId;
  final String name;
  final String fullName;
  final String login;
  final String email;
  final String phone;
  final String role;
  final String roleCode;
  final String department;
  final int teamId;
  final String teamName;
  final String specialization;
  final String employmentStatus;
  final String status;

  TeamMemberModel({
    required this.id,
    required this.memberId,
    required this.name,
    required this.fullName,
    required this.login,
    required this.email,
    required this.phone,
    required this.role,
    required this.roleCode,
    required this.department,
    required this.teamId,
    required this.teamName,
    required this.specialization,
    required this.employmentStatus,
    required this.status,
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
      id: json['id'] ?? 0,
      memberId: json['member_id'] ?? 0,
      name: json['name'] ?? '',
      fullName: json['full_name'] ?? '',
      login: json['login'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      roleCode: json['role_code'] ?? '',
      department: json['department'] ?? '',
      teamId: json['team_id'] ?? 0,
      teamName: json['team_name'] ?? '',
      specialization: json['specialization'] ?? '',
      employmentStatus: json['employment_status'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'member_id': memberId,
      'name': name,
      'full_name': fullName,
      'login': login,
      'email': email,
      'phone': phone,
      'role': role,
      'role_code': roleCode,
      'department': department,
      'team_id': teamId,
      'team_name': teamName,
      'specialization': specialization,
      'employment_status': employmentStatus,
      'status': status,
    };
  }
}
