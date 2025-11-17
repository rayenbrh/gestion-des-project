import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserRole {
  @JsonValue('ADMIN')
  admin,
  @JsonValue('CHEF_PROJET')
  chefProjet,
  @JsonValue('CONSULTANT')
  consultant,
}

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required UserRole role,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? lastLogin,
    @Default([]) List<String> fcmTokens,
    UserPreferences? preferences,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }
}

@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    @Default('light') String theme,
    @Default('fr') String language,
    @Default(NotificationSettings()) NotificationSettings notifications,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
}

@freezed
class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    @Default(true) bool email,
    @Default(true) bool push,
    @Default(false) bool sms,
  }) = _NotificationSettings;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);
}
