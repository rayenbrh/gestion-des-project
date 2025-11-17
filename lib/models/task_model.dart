import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'project_model.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

enum TaskStatus {
  @JsonValue('A_FAIRE')
  aFaire,
  @JsonValue('EN_COURS')
  enCours,
  @JsonValue('EN_REVUE')
  enRevue,
  @JsonValue('TERMINEE')
  terminee,
  @JsonValue('BLOQUEE')
  bloquee,
}

@freezed
class TaskModel with _$TaskModel {
  const TaskModel._();

  const factory TaskModel({
    required String id,
    required String projectId,
    String? missionId,
    required String title,
    String? description,
    required String assignedTo,
    @Default(Priority.moyenne) Priority priority,
    @Default(TaskStatus.aFaire) TaskStatus status,
    required String createdBy,
    required DateTime createdAt,
    required DateTime dueDate,
    DateTime? startDate,
    DateTime? completedDate,
    @Default(0.0) double estimatedHours,
    @Default(0.0) double actualHours,
    @Default(0.0) double progress,
    @Default([]) List<Subtask> subtasks,
    @Default([]) List<String> tags,
    @Default([]) List<String> dependencies,
    @Default([]) List<String> blockedBy,
    @Default([]) List<TaskAttachment> attachments,
    DateTime? updatedAt,
  }) = _TaskModel;

  bool get isOverdue {
    if (status == TaskStatus.terminee) return false;
    return DateTime.now().isAfter(dueDate);
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }
}

@freezed
class Subtask with _$Subtask {
  const factory Subtask({
    required String subtaskId,
    required String title,
    @Default(false) bool isCompleted,
    DateTime? completedAt,
  }) = _Subtask;

  factory Subtask.fromJson(Map<String, dynamic> json) =>
      _$SubtaskFromJson(json);
}

@freezed
class TaskAttachment with _$TaskAttachment {
  const factory TaskAttachment({
    required String url,
    required String name,
    required DateTime uploadedAt,
  }) = _TaskAttachment;

  factory TaskAttachment.fromJson(Map<String, dynamic> json) =>
      _$TaskAttachmentFromJson(json);
}

@freezed
class CommentModel with _$CommentModel {
  const factory CommentModel({
    required String id,
    required String taskId,
    required String authorId,
    required String content,
    required DateTime createdAt,
    DateTime? updatedAt,
    @Default([]) List<String> attachments,
    @Default([]) List<String> mentions,
    @Default(false) bool isEdited,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  factory CommentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommentModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }
}
