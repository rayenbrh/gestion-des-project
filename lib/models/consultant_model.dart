import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'consultant_model.freezed.dart';
part 'consultant_model.g.dart';

enum ConsultantStatus {
  @JsonValue('ACTIF')
  actif,
  @JsonValue('EN_CONGE')
  enConge,
  @JsonValue('INACTIF')
  inactif,
  @JsonValue('EN_MISSION')
  enMission,
}

@freezed
class ConsultantModel with _$ConsultantModel {
  const ConsultantModel._();

  const factory ConsultantModel({
    required String id,
    required String userId,
    required String firstName,
    required String lastName,
    String? phone,
    String? photoUrl,
    String? position,
    String? department,
    DateTime? dateJoined,
    @Default(ConsultantStatus.actif) ConsultantStatus status,
    @Default(0) int yearsExperience,
    @Default(0.0) double hourlyRate,
    @Default(0.0) double dailyRate,
    @Default(100.0) double availability,
    @Default(0.0) double currentWorkload,
    CongesBalance? congesBalance,
    Address? address,
    EmergencyContact? emergencyContact,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ConsultantModel;

  String get fullName => '$firstName $lastName';

  factory ConsultantModel.fromJson(Map<String, dynamic> json) =>
      _$ConsultantModelFromJson(json);

  factory ConsultantModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ConsultantModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }
}

@freezed
class CongesBalance with _$CongesBalance {
  const factory CongesBalance({
    @Default(25) int congesPayes,
    @Default(10) int rtt,
    @Default(5) int formation,
  }) = _CongesBalance;

  factory CongesBalance.fromJson(Map<String, dynamic> json) =>
      _$CongesBalanceFromJson(json);
}

@freezed
class Address with _$Address {
  const factory Address({
    String? street,
    String? city,
    String? zipCode,
    @Default('France') String country,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}

@freezed
class EmergencyContact with _$EmergencyContact {
  const factory EmergencyContact({
    String? name,
    String? phone,
    String? relation,
  }) = _EmergencyContact;

  factory EmergencyContact.fromJson(Map<String, dynamic> json) =>
      _$EmergencyContactFromJson(json);
}
