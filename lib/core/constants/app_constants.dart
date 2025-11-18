import 'package:flutter/material.dart';

/// Application constants
class AppConstants {
  // App Info
  static const String appName = 'Consulting Management';
  static const String appVersion = '1.0.0';

  // API & Firebase
  static const String firestoreVersion = 'v1';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Time & Date
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String timeFormat = 'HH:mm';

  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;

  // Files
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocExtensions = ['pdf', 'doc', 'docx', 'xls', 'xlsx'];

  // HR
  static const int defaultCongesPayesPerYear = 25;
  static const int defaultRttPerYear = 11;
  static const int defaultFormationDaysPerYear = 5;
  static const int minNoticeDaysForConge = 7;
  static const int maxConsecutiveCongesDays = 30;

  // Project Management
  static const double hoursPerDay = 7.0;
  static const int daysPerWeek = 5;
  static const double hoursPerWeek = 35.0;

  // Notifications
  static const Duration notificationExpiry = Duration(days: 30);
  static const List<int> deadlineReminderDays = [1, 3, 7]; // Rappels avant échéance

  // UI
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double defaultElevation = 2.0;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
}

/// Color constants
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFF64B5F6);

  // Secondary Colors
  static const Color secondary = Color(0xFFFF9800);
  static const Color secondaryDark = Color(0xFFF57C00);
  static const Color secondaryLight = Color(0xFFFFB74D);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Neutral Colors
  static const Color black = Color(0xFF212121);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFE0E0E0);
  static const Color greyDark = Color(0xFF616161);

  // Background Colors
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
}

/// Route names
class RouteNames {
  // Auth
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';

  // Main
  static const String home = '/';
  static const String dashboard = '/dashboard';

  // Consultants
  static const String consultants = '/consultants';
  static const String consultantDetails = '/consultants/:id';
  static const String consultantCreate = '/consultants/create';
  static const String consultantEdit = '/consultants/:id/edit';

  // Projects
  static const String projects = '/projects';
  static const String projectDetails = '/projects/:id';
  static const String projectCreate = '/projects/create';
  static const String projectEdit = '/projects/:id/edit';

  // Tasks
  static const String tasks = '/tasks';
  static const String taskDetails = '/tasks/:id';

  // Conges
  static const String conges = '/conges';
  static const String congeCreate = '/conges/create';
  static const String congeDetails = '/conges/:id';

  // Time Tracking
  static const String timeTracking = '/time-tracking';

  // Settings
  static const String settings = '/settings';
  static const String profile = '/profile';

  // Notifications
  static const String notifications = '/notifications';
}

/// Asset paths
class AssetPaths {
  static const String imagesPath = 'assets/images/';
  static const String iconsPath = 'assets/icons/';

  // Images
  static const String logo = '${imagesPath}logo.png';
  static const String logoLight = '${imagesPath}logo_light.png';
  static const String logoDark = '${imagesPath}logo_dark.png';
  static const String placeholder = '${imagesPath}placeholder.png';
  static const String avatarPlaceholder = '${imagesPath}avatar_placeholder.png';

  // Icons
  static const String dashboardIcon = '${iconsPath}dashboard.svg';
  static const String consultantsIcon = '${iconsPath}consultants.svg';
  static const String projectsIcon = '${iconsPath}projects.svg';
  static const String tasksIcon = '${iconsPath}tasks.svg';
  static const String timeTrackingIcon = '${iconsPath}time_tracking.svg';
  static const String congesIcon = '${iconsPath}conges.svg';
}

/// Firebase collection names
class FirebaseCollections {
  static const String users = 'users';
  static const String consultants = 'consultants';
  static const String projects = 'projects';
  static const String tasks = 'tasks';
  static const String conges = 'conges';
  static const String timeTracking = 'timeTracking';
  static const String notifications = 'notifications';
  static const String activityLogs = 'activityLogs';
  static const String settings = 'settings';

  // Sub-collections
  static const String skills = 'skills';
  static const String certifications = 'certifications';
  static const String documents = 'documents';
  static const String evaluations = 'evaluations';
  static const String assignments = 'assignments';
  static const String missions = 'missions';
  static const String risks = 'risks';
  static const String comments = 'comments';
}

/// Storage paths
class StoragePaths {
  static const String consultants = 'consultants';
  static const String projects = 'projects';
  static const String documents = 'documents';
  static const String avatars = 'avatars';
  static const String attachments = 'attachments';

  static String consultantAvatar(String consultantId) => '$consultants/$consultantId/avatar';
  static String consultantDocument(String consultantId, String docId) => '$consultants/$consultantId/documents/$docId';
  static String projectDocument(String projectId, String docId) => '$projects/$projectId/documents/$docId';
  static String taskAttachment(String taskId, String attachmentId) => '$attachments/tasks/$taskId/$attachmentId';
}

/// Error messages
class ErrorMessages {
  static const String networkError = 'Erreur de connexion. Veuillez vérifier votre connexion internet.';
  static const String serverError = 'Erreur serveur. Veuillez réessayer plus tard.';
  static const String unknownError = 'Une erreur inattendue s\'est produite.';
  static const String authError = 'Erreur d\'authentification. Veuillez vous reconnecter.';
  static const String permissionDenied = 'Vous n\'avez pas les permissions nécessaires.';
  static const String notFound = 'Ressource introuvable.';
  static const String invalidData = 'Données invalides.';
  static const String emailAlreadyInUse = 'Cet email est déjà utilisé.';
  static const String weakPassword = 'Le mot de passe est trop faible.';
  static const String wrongPassword = 'Mot de passe incorrect.';
  static const String userNotFound = 'Utilisateur introuvable.';
  static const String fileTooLarge = 'Le fichier est trop volumineux.';
  static const String invalidFileType = 'Type de fichier non autorisé.';
}

/// Success messages
class SuccessMessages {
  static const String loginSuccess = 'Connexion réussie';
  static const String logoutSuccess = 'Déconnexion réussie';
  static const String createSuccess = 'Création réussie';
  static const String updateSuccess = 'Mise à jour réussie';
  static const String deleteSuccess = 'Suppression réussie';
  static const String uploadSuccess = 'Fichier téléchargé avec succès';
  static const String congeRequestSubmitted = 'Demande de congé envoyée';
  static const String congeApproved = 'Congé approuvé';
  static const String congeRejected = 'Congé rejeté';
  static const String timeLoggedSuccess = 'Temps enregistré avec succès';
}
