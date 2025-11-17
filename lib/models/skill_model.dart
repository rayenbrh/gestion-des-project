import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'skill_model.freezed.dart';
part 'skill_model.g.dart';

enum SkillLevel {
  @JsonValue('DEBUTANT')
  debutant,
  @JsonValue('INTERMEDIAIRE')
  intermediaire,
  @JsonValue('AVANCE')
  avance,
  @JsonValue('EXPERT')
  expert,
}

@freezed
class SkillModel with _$SkillModel {
  const factory SkillModel({
    required String id,
    required String name,
    required String category,
    @Default(SkillLevel.debutant) SkillLevel level,
    @Default(0) int yearsOfExperience,
    DateTime? lastUsed,
    @Default(false) bool certified,
    DateTime? addedAt,
  }) = _SkillModel;

  factory SkillModel.fromJson(Map<String, dynamic> json) =>
      _$SkillModelFromJson(json);

  factory SkillModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SkillModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }
}
