class TeamPerformanceModel {
  final String name;
  final int tasksCount;
  final double progress; // من 0.0 إلى 1.0
  final String percentage;

  TeamPerformanceModel({required this.name, required this.tasksCount, required this.progress, required this.percentage});
}