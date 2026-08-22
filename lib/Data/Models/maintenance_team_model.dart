import 'package:flutter/cupertino.dart';
import 'package:maintenance_management_app/Data/Models/team_member_model.dart';

class MaintenanceTeamModel {
  final int id;
  final int teamId;
  final String name;
  final String teamName;
  final int color;
  final String icon;
  final String? imageUrl;
  final int defaultStageId;
  final String defaultStageName;
  final String description;
  final List<TeamMemberModel> supervisors;
  final List<TeamMemberModel> members;
  final List<TeamMemberModel> teamMembers;

  MaintenanceTeamModel({
    required this.id,
    required this.teamId,
    required this.name,
    required this.teamName,
    required this.color,
    required this.icon,
    this.imageUrl,
    required this.defaultStageId,
    required this.defaultStageName,
    required this.description,
    required this.supervisors,
    required this.members,
    required this.teamMembers,
  });

  factory MaintenanceTeamModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceTeamModel(
      id: json['id'] ?? 0,
      teamId: json['team_id'] ?? 0,
      name: json['name'] ?? '',
      teamName: json['team_name'] ?? '',
      color: json['color'] ?? 0,
      icon: json['icon'] ?? '',
      imageUrl: json['image_url'],
      defaultStageId: json['default_stage_id'] ?? 0,
      defaultStageName: json['default_stage_name'] ?? '',
      description: json['description'] ?? '',
      supervisors: json['supervisors'] != null
          ? (json['supervisors'] as List)
          .map((i) => TeamMemberModel.fromJson(i))
          .toList()
          : [],
      members: json['members'] != null
          ? (json['members'] as List)
          .map((i) => TeamMemberModel.fromJson(i))
          .toList()
          : [],
      teamMembers: json['team_members'] != null
          ? (json['team_members'] as List)
          .map((i) => TeamMemberModel.fromJson(i))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'team_id': teamId,
      'name': name,
      'team_name': teamName,
      'color': color,
      'icon': icon,
      'image_url': imageUrl,
      'default_stage_id': defaultStageId,
      'default_stage_name': defaultStageName,
      'description': description,
      'supervisors': supervisors.map((e) => e.toJson()).toList(),
      'members': members.map((e) => e.toJson()).toList(),
      'team_members': teamMembers.map((e) => e.toJson()).toList(),
    };
  }
}