import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'time_tracking_model.freezed.dart';
part 'time_tracking_model.g.dart';

enum ActivityType {
  @JsonValue('DEVELOPPEMENT')
  developpement,
  @JsonValue('REUNION')
  reunion,
  @JsonValue('FORMATION')
  formation,
  @JsonValue('DOCUMENTATION')
  documentation,
  @JsonValue('SUPPORT')
  support,
  @JsonValue('AUTRE')
  autre,
}

@freezed
class TimeTrackingModel with _$TimeTrackingModel {
  const factory TimeTrackingModel({
    required String id,
    required String consultantId,
    required String projectId,
    String? missionId,
    String? taskId,
    required DateTime date,
    required double hours,
    required String description,
    @Default(ActivityType.developpement) ActivityType activityType,
    @Default(true) bool isBillable,
    @Default(false) bool isValidated,
    String? validatedBy,
    DateTime? validatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _TimeTrackingModel;

  factory TimeTrackingModel.fromJson(Map<String, dynamic> json) =>
      _$TimeTrackingModelFromJson(json);

  factory TimeTrackingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TimeTrackingModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }
}
