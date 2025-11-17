import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

enum NotificationType {
  @JsonValue('CONGE_REQUEST')
  congeRequest,
  @JsonValue('CONGE_APPROVED')
  congeApproved,
  @JsonValue('CONGE_REJECTED')
  congeRejected,
  @JsonValue('TASK_ASSIGNED')
  taskAssigned,
  @JsonValue('PROJECT_UPDATE')
  projectUpdate,
  @JsonValue('DEADLINE_REMINDER')
  deadlineReminder,
  @JsonValue('SYSTEM_ALERT')
  systemAlert,
  @JsonValue('EVALUATION_DUE')
  evaluationDue,
}

enum NotificationPriority {
  @JsonValue('LOW')
  low,
  @JsonValue('NORMAL')
  normal,
  @JsonValue('HIGH')
  high,
}

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String userId,
    required String title,
    required String message,
    @Default(NotificationType.systemAlert) NotificationType type,
    @Default(false) bool isRead,
    DateTime? readAt,
    @Default(NotificationPriority.normal) NotificationPriority priority,
    String? relatedEntityType,
    String? relatedEntityId,
    String? actionUrl,
    Map<String, dynamic>? metadata,
    required DateTime createdAt,
    DateTime? expiresAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }
}
