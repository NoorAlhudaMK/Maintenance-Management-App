part of 'add_new_report_bloc.dart';

class AddNewReportState {
  final List<PriorityModel> priorities;
  final List<CategoryModel> categories;
  final PriorityModel? selectedPriority;
  final CategoryModel? selectedCategory;
  final String? selectedBuilding;
  final File? reportImage;
  final bool isLoading;
  final bool isSubmitting;
  final String? successMessage;
  final String? errorMessage;

  const AddNewReportState({
    this.priorities = const [],
    this.categories = const [],
    this.selectedPriority,
    this.selectedCategory,
    this.selectedBuilding,
    this.reportImage,
    this.isLoading = false,
    this.isSubmitting = false,
    this.successMessage,
    this.errorMessage,
  });

  AddNewReportState copyWith({
    List<PriorityModel>? priorities,
    List<CategoryModel>? categories,
    PriorityModel? selectedPriority,
    CategoryModel? selectedCategory,
    String? selectedBuilding,
    File? reportImage,
    bool? isLoading,
    bool? isSubmitting,
    String? successMessage,
    String? errorMessage,
  }) {
    return AddNewReportState(
      priorities: priorities ?? this.priorities,
      categories: categories ?? this.categories,
      selectedPriority: selectedPriority ?? this.selectedPriority,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedBuilding: selectedBuilding ?? this.selectedBuilding,
      reportImage: reportImage ?? this.reportImage,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }
}