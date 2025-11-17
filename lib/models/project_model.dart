import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'project_model.freezed.dart';
part 'project_model.g.dart';

enum ProjectType {
  @JsonValue('INTERNE')
  interne,
  @JsonValue('EXTERNE')
  externe,
  @JsonValue('R_AND_D')
  rAndD,
}

enum ProjectStatus {
  @JsonValue('PLANIFIE')
  planifie,
  @JsonValue('EN_COURS')
  enCours,
  @JsonValue('EN_PAUSE')
  enPause,
  @JsonValue('TERMINE')
  termine,
  @JsonValue('ANNULE')
  annule,
  @JsonValue('EN_RETARD')
  enRetard,
}

enum Priority {
  @JsonValue('BASSE')
  basse,
  @JsonValue('MOYENNE')
  moyenne,
  @JsonValue('HAUTE')
  haute,
  @JsonValue('CRITIQUE')
  critique,
}

@freezed
class ProjectModel with _$ProjectModel {
  const ProjectModel._();

  const factory ProjectModel({
    required String id,
    required String code,
    required String name,
    String? description,
    required String clientName,
    ClientContact? clientContact,
    @Default(ProjectType.externe) ProjectType type,
    @Default(ProjectStatus.planifie) ProjectStatus status,
    @Default(Priority.moyenne) Priority priority,
    required DateTime startDate,
    required DateTime endDate,
    DateTime? actualEndDate,
    double? budget,
    required String chefProjetId,
    @Default(0.0) double progress,
    @Default([]) List<Milestone> milestones,
    @Default([]) List<String> tags,
    ProjectStats? stats,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProjectModel;

  bool get isDelayed {
    if (status == ProjectStatus.termine || status == ProjectStatus.annule) {
      return false;
    }
    return DateTime.now().isAfter(endDate);
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);

  factory ProjectModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProjectModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }
}

@freezed
class ClientContact with _$ClientContact {
  const factory ClientContact({
    String? name,
    String? email,
    String? phone,
  }) = _ClientContact;

  factory ClientContact.fromJson(Map<String, dynamic> json) =>
      _$ClientContactFromJson(json);
}

@freezed
class Milestone with _$Milestone {
  const factory Milestone({
    required String milestoneId,
    required String name,
    String? description,
    required DateTime targetDate,
    DateTime? completedDate,
    @Default(MilestoneStatus.aFaire) MilestoneStatus status,
  }) = _Milestone;

  factory Milestone.fromJson(Map<String, dynamic> json) =>
      _$MilestoneFromJson(json);
}

enum MilestoneStatus {
  @JsonValue('A_FAIRE')
  aFaire,
  @JsonValue('EN_COURS')
  enCours,
  @JsonValue('TERMINE')
  termine,
  @JsonValue('EN_RETARD')
  enRetard,
}

@freezed
class ProjectStats with _$ProjectStats {
  const factory ProjectStats({
    @Default(0) int totalTasks,
    @Default(0) int completedTasks,
    @Default(0.0) double totalHours,
    @Default(0.0) double estimatedHours,
    @Default(0) int teamSize,
  }) = _ProjectStats;

  factory ProjectStats.fromJson(Map<String, dynamic> json) =>
      _$ProjectStatsFromJson(json);
}
