import 'package:flutter/material.dart';

enum TechStatus { all, available, busy, notAvailable }

class TechnicianModel {
  final String id, name, specialty, initials;
  final double rating;
  final int activeTasks;
  final TechStatus status;
  final Color avatarColor;
  final bool isAvailable;

  final int completedTasks;
  final String onTimePercentage;
  final List<RecentTask>? recentTasks;

  TechnicianModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.initials,
    required this.rating,
    required this.activeTasks,
    required this.status,
    required this.avatarColor,
    required this.isAvailable,
    this.completedTasks = 0,
    this.onTimePercentage = "0%",
    this.recentTasks,
  });
}

class RecentTask {
  final String id;
  final String title;
  final String location;
  final bool isSuccess;

  RecentTask({
    required this.id,
    required this.title,
    required this.location,
    this.isSuccess = true,
  });
}