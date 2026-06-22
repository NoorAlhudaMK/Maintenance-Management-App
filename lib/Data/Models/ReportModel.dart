import 'package:flutter/material.dart';

enum ReportCategory { all, plumbing, electric, ac }

class ReportModel {
  final String id, location, description, status;
  final IconData icon;
  final Color iconColor;
  final ReportCategory category;
  final bool isUrgent;

  ReportModel({
    required this.id, required this.location, required this.description,
    required this.status, required this.icon, required this.iconColor,
    required this.category, this.isUrgent = false,
  });
}