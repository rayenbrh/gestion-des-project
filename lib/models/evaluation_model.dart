import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'evaluation_model.freezed.dart';
part 'evaluation_model.g.dart';

enum ObjectiveStatus {
  @JsonValue('EN_COURS')
  enCours,
  @JsonValue('ATTEINT')
  atteint,
  @JsonValue('NON_ATTEINT')
  nonAtteint,
  @JsonValue('ABANDONNE')
  abandonne,
}

@freezed
class EvaluationModel with _$EvaluationModel {
  const EvaluationModel._();

  const factory EvaluationModel({
    required String id,
    required String consultantId,
    required String evaluatorId,
    required DateTime evaluationDate,
    required String period,
    @Default([]) List<ObjectiveModel> objectives,
    String? achievements,
    String? strengths,
    String? improvements,
    @Default(0.0) double globalRating,
    @Default(0.0) double technicalRating,
    @Default(0.0) double teamworkRating,
    @Default(0.0) double communicationRating,
    String? comments,
    String? developmentPlan,
    DateTime? nextReviewDate,
    @Default(false) bool signedByConsultant,
    @Default(false) bool signedByEvaluator,
    DateTime? createdAt,
  }) = _EvaluationModel;

  double get averageRating =>
      (globalRating + technicalRating + teamworkRating + communicationRating) /
      4;

  factory EvaluationModel.fromJson(Map<String, dynamic> json) =>
      _$EvaluationModelFromJson(json);

  factory EvaluationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EvaluationModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }
}

@freezed
class ObjectiveModel with _$ObjectiveModel {
  const factory ObjectiveModel({
    required String objectiveId,
    required String title,
    String? description,
    required DateTime targetDate,
    @Default(0.0) double progress,
    @Default(ObjectiveStatus.enCours) ObjectiveStatus status,
  }) = _ObjectiveModel;

  factory ObjectiveModel.fromJson(Map<String, dynamic> json) =>
      _$ObjectiveModelFromJson(json);
}
