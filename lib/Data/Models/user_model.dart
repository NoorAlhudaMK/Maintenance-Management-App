import 'resident_profile_model.dart';
import 'unit_model.dart';
import 'building_model.dart';
import 'maintenance_team_model.dart';

class UserModel {
  final int id;
  final String name;
  final String login;
  final String email;
  final String phone;
  final String mobile;
  final String role;
  final String timezone;
  final List<String>? allowedApps;
  final List<String>? groups;
  final List<UnitModel>? units;
  final List<ResidentProfileModel> residentProfiles;
  final List<MaintenanceTeamModel> maintenanceTeams;
  final List<BuildingModel> buildings;
  final List<dynamic> assignedGates;
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.login,
    required this.email,
    required this.phone,
    required this.mobile,
    required this.role,
    required this.timezone,
    required this.allowedApps,
    required this.groups,
    required this.units,
    required this.residentProfiles,
    required this.maintenanceTeams,
    required this.buildings,
    required this.assignedGates,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {String? token}) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      login: json['login'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      mobile: json['mobile'] ?? '',
      role: json['role'] ?? 'user',
      timezone: json['timezone'] ?? '',

      allowedApps: json['allowed_apps'] != null
          ? List<String>.from(json['allowed_apps'])
          : [],

      groups: json['groups'] != null && json['groups'] is List
          ? List<String>.from(json['groups'])
          : [],

      units: json['units'] != null
          ? (json['units'] as List).map((i) => UnitModel.fromJson(i)).toList()
          : [],

      residentProfiles: json['resident_profiles'] != null
          ? (json['resident_profiles'] as List)
          .map((i) => ResidentProfileModel.fromJson(i))
          .toList()
          : [],

      maintenanceTeams: json['maintenance_teams'] != null
          ? (json['maintenance_teams'] as List)
          .map((i) => MaintenanceTeamModel.fromJson(i))
          .toList()
          : [],

      buildings: json['buildings'] != null
          ? (json['buildings'] as List)
          .map((i) => BuildingModel.fromJson(i))
          .toList()
          : [],

      assignedGates: json['assigned_gates'] != null
          ? List<dynamic>.from(json['assigned_gates'])
          : [],

      token: token,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'login': login,
      'email': email,
      'phone': phone,
      'mobile': mobile,
      'role': role,
      'timezone': timezone,
      'allowed_apps': allowedApps,
      'groups': groups,
      'units': units?.map((unit) => unit.toJson()).toList() ?? [],
      'resident_profiles': residentProfiles.map((profile) => profile.toJson()).toList(),
      'maintenance_teams': maintenanceTeams.map((team) => team.toJson()).toList(),
      'buildings': buildings.map((building) => building.toJson()).toList(),
      'assigned_gates': assignedGates,
      'token': token,
    };
  }
}