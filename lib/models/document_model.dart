import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'document_model.freezed.dart';
part 'document_model.g.dart';

enum DocumentType {
  @JsonValue('CV')
  cv,
  @JsonValue('CONTRACT')
  contract,
  @JsonValue('CERTIFICATE')
  certificate,
  @JsonValue('ADMINISTRATIVE')
  administrative,
  @JsonValue('OTHER')
  other,
}

@freezed
class DocumentModel with _$DocumentModel {
  const factory DocumentModel({
    required String id,
    required String title,
    @Default(DocumentType.other) DocumentType type,
    required String fileUrl,
    required String fileName,
    @Default(0) int fileSize,
    String? mimeType,
    required DateTime uploadedAt,
    required String uploadedBy,
    @Default(false) bool isConfidential,
    DateTime? expirationDate,
  }) = _DocumentModel;

  factory DocumentModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentModelFromJson(json);

  factory DocumentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DocumentModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }
}
