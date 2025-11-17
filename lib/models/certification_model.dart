import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'certification_model.freezed.dart';
part 'certification_model.g.dart';

@freezed
class CertificationModel with _$CertificationModel {
  const factory CertificationModel({
    required String id,
    required String name,
    required String issuingOrganization,
    required DateTime issueDate,
    DateTime? expirationDate,
    String? credentialId,
    String? credentialUrl,
    String? certificateFile,
    DateTime? addedAt,
  }) = _CertificationModel;

  factory CertificationModel.fromJson(Map<String, dynamic> json) =>
      _$CertificationModelFromJson(json);

  factory CertificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CertificationModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }
}
