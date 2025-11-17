import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'conge_model.freezed.dart';
part 'conge_model.g.dart';

enum CongeType {
  @JsonValue('CONGE_PAYE')
  congePaye,
  @JsonValue('RTT')
  rtt,
  @JsonValue('MALADIE')
  maladie,
  @JsonValue('SANS_SOLDE')
  sansSolde,
  @JsonValue('FORMATION')
  formation,
  @JsonValue('AUTRE')
  autre,
}

enum CongeStatus {
  @JsonValue('BROUILLON')
  brouillon,
  @JsonValue('EN_ATTENTE')
  enAttente,
  @JsonValue('VALIDE_CHEF')
  valideChef,
  @JsonValue('APPROUVE')
  approuve,
  @JsonValue('REJETE')
  rejete,
  @JsonValue('ANNULE')
  annule,
}

@freezed
class CongeModel with _$CongeModel {
  const factory CongeModel({
    required String id,
    required String consultantId,
    @Default(CongeType.congePaye) CongeType type,
    required DateTime startDate,
    required DateTime endDate,
    required int numberOfDays,
    String? reason,
    @Default(CongeStatus.brouillon) CongeStatus status,
    required DateTime requestDate,
    CongeValidation? validations,
    @Default([]) List<CongeAttachment> attachments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CongeModel;

  factory CongeModel.fromJson(Map<String, dynamic> json) =>
      _$CongeModelFromJson(json);

  factory CongeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CongeModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }
}

@freezed
class CongeValidation with _$CongeValidation {
  const factory CongeValidation({
    ValidationStep? chefProjet,
    ValidationStep? admin,
  }) = _CongeValidation;

  factory CongeValidation.fromJson(Map<String, dynamic> json) =>
      _$CongeValidationFromJson(json);
}

@freezed
class ValidationStep with _$ValidationStep {
  const factory ValidationStep({
    required bool validated,
    required String validatedBy,
    required DateTime validatedAt,
    String? comment,
  }) = _ValidationStep;

  factory ValidationStep.fromJson(Map<String, dynamic> json) =>
      _$ValidationStepFromJson(json);
}

@freezed
class CongeAttachment with _$CongeAttachment {
  const factory CongeAttachment({
    required String url,
    required String name,
  }) = _CongeAttachment;

  factory CongeAttachment.fromJson(Map<String, dynamic> json) =>
      _$CongeAttachmentFromJson(json);
}
