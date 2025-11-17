# 🚀 Guide d'Implémentation - Application de Gestion de Consulting

## ✅ État Actuel de l'Implémentation

### Phase 1: Fondations ✅ Complétée

#### Architecture et Configuration
- ✅ Structure de projet Flutter complète
- ✅ Configuration Firebase (à personnaliser)
- ✅ Constantes et configuration de base
- ✅ Système de thème (light/dark mode)
- ✅ Logging et utilitaires

#### Modèles de Données
- ✅ 11 modèles Freezed créés:
  - UserModel
  - ConsultantModel
  - SkillModel, CertificationModel, DocumentModel
  - CongeModel
  - ProjectModel
  - TaskModel
  - TimeTrackingModel
  - EvaluationModel
  - NotificationModel

#### Services
- ✅ AuthService (authentification complète)
- ✅ StorageService (upload/download fichiers)

#### State Management (Riverpod)
- ✅ AuthProvider
- ✅ ThemeProvider

#### Routing (GoRouter)
- ✅ Configuration complète avec redirection
- ✅ Routes protégées par authentification

#### UI/Screens
- ✅ LoginScreen (email + Google Sign-In)
- ✅ DashboardScreen (layout adaptatif)
- ✅ Navigation drawer avec menu contextuel par rôle

---

## 🔧 Configuration Requise Avant de Lancer

### 1. Configurer Firebase

#### Créer un projet Firebase
1. Allez sur https://console.firebase.google.com
2. Créez un nouveau projet: "consulting-management-app"
3. Activez les services suivants:

**Authentication:**
```
- Email/Password
- Google Sign-In
```

**Firestore Database:**
- Mode: Production
- Région: europe-west1
- Appliquer les règles de sécurité depuis `docs/DATABASE_SCHEMA.md`

**Storage:**
- Mode: Production
- Appliquer les règles de sécurité

**Cloud Messaging (FCM):**
- Activer les notifications push

#### Télécharger les fichiers de configuration

**Pour Android:**
```bash
# Télécharger google-services.json
# Placer dans: android/app/google-services.json
```

**Pour iOS:**
```bash
# Télécharger GoogleService-Info.plist
# Placer dans: ios/Runner/GoogleService-Info.plist
```

**Pour Web:**
Copier les credentials dans `lib/core/config/firebase_config.dart`:
```dart
static const String apiKey = 'AIza...';
static const String projectId = 'consulting-management-app';
static const String messagingSenderId = '123456789';
static const String appId = '1:123456789:web:abc123';
static const String storageBucket = 'consulting-management-app.appspot.com';
```

#### Créer le fichier .env
```bash
cp .env.example .env
```

Éditer `.env`:
```env
FIREBASE_API_KEY=AIzaSy...votre_api_key
FIREBASE_PROJECT_ID=consulting-management-app
FIREBASE_APP_ID=1:123456789:web:abc123
FIREBASE_MESSAGING_SENDER_ID=123456789
FIREBASE_STORAGE_BUCKET=consulting-management-app.appspot.com
ENVIRONMENT=development
```

### 2. Installer les Dépendances

```bash
flutter pub get
```

### 3. Générer le Code Freezed

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Cette commande va générer tous les fichiers `.freezed.dart` et `.g.dart` nécessaires.

### 4. Créer des Utilisateurs de Test

Dans Firebase Console → Authentication, créez manuellement:

```
Admin:
- Email: admin@consulting.com
- Password: password123

Chef de Projet:
- Email: chef@consulting.com
- Password: password123

Consultant:
- Email: consultant@consulting.com
- Password: password123
```

Puis dans Firestore, créez les documents dans `users`:

**Document ID: [uid de l'admin]**
```json
{
  "email": "admin@consulting.com",
  "role": "ADMIN",
  "isActive": true,
  "createdAt": [timestamp],
  "fcmTokens": []
}
```

Répéter pour chef et consultant avec leurs rôles respectifs.

### 5. Lancer l'Application

**Web:**
```bash
flutter run -d chrome
```

**iOS:**
```bash
flutter run -d ios
```

**Android:**
```bash
flutter run -d android
```

---

## 📋 Prochaines Étapes de Développement

### Phase 2: Module RH (5-7 jours)

#### 1. Service Consultant
**Fichier:** `lib/services/consultant_service.dart`
```dart
- getAllConsultants()
- getConsultantById()
- createConsultant()
- updateConsultant()
- deleteConsultant()
- getConsultantSkills()
- addSkill()
- updateSkill()
- deleteSkill()
- getConsultantCertifications()
- addCertification()
```

#### 2. Provider Consultant
**Fichier:** `lib/providers/consultant_provider.dart`
```dart
- consultantsListProvider
- consultantByIdProvider
- consultantSkillsProvider
- consultantWorkloadProvider
```

#### 3. Écrans Consultants
**Fichiers:**
- `lib/screens/consultants/consultants_list_screen.dart`
- `lib/screens/consultants/consultant_details_screen.dart`
- `lib/screens/consultants/consultant_form_screen.dart`
- `lib/screens/consultants/skills_management_screen.dart`

**Features:**
- Liste des consultants (card/table view)
- Recherche et filtres
- Profil détaillé
- Formulaire création/édition
- Gestion des compétences
- Upload de documents
- Affichage de la charge de travail

#### 4. Service & Écrans Congés
**Fichiers:**
- `lib/services/conge_service.dart`
- `lib/providers/conge_provider.dart`
- `lib/screens/conges/conges_list_screen.dart`
- `lib/screens/conges/conge_form_screen.dart`
- `lib/screens/conges/conge_details_screen.dart`

**Features:**
- Demande de congés
- Workflow de validation (Chef → Admin)
- Calendrier des congés
- Solde de congés
- Historique

### Phase 3: Module Projets (5-7 jours)

#### 1. Service Projet
**Fichier:** `lib/services/project_service.dart`
```dart
- getAllProjects()
- getProjectById()
- createProject()
- updateProject()
- deleteProject()
- getProjectAssignments()
- assignConsultant()
- removeConsultant()
- updateProjectProgress()
- getProjectTasks()
```

#### 2. Provider Projet
**Fichier:** `lib/providers/project_provider.dart`

#### 3. Écrans Projets
**Fichiers:**
- `lib/screens/projects/projects_list_screen.dart`
- `lib/screens/projects/project_details_screen.dart`
- `lib/screens/projects/project_form_screen.dart`
- `lib/screens/projects/project_team_screen.dart`

**Features:**
- Liste des projets
- Filtres par statut, type, chef de projet
- Détails du projet
- Timeline et milestones
- Affectation consultants
- Gestion de la charge
- Suivi d'avancement

#### 4. Service & Écrans Tâches
**Fichiers:**
- `lib/services/task_service.dart`
- `lib/providers/task_provider.dart`
- `lib/screens/tasks/tasks_board_screen.dart` (Kanban)
- `lib/screens/tasks/task_details_screen.dart`
- `lib/screens/tasks/task_form_screen.dart`

**Features:**
- Board Kanban
- Liste des tâches
- Création/édition tâches
- Sous-tâches
- Commentaires
- Dépendances
- Pièces jointes

#### 5. Time Tracking
**Fichiers:**
- `lib/services/time_tracking_service.dart`
- `lib/providers/time_tracking_provider.dart`
- `lib/screens/time_tracking/time_tracking_screen.dart`
- `lib/screens/time_tracking/timesheet_screen.dart`

**Features:**
- Saisie des temps
- Sélection projet/tâche
- Feuilles de temps hebdomadaires
- Validation par chef de projet
- Statistiques personnelles

### Phase 4: Dashboards et KPI (3-5 jours)

#### 1. Dashboard Administrateur
**Fichier:** `lib/screens/dashboard/admin_dashboard_screen.dart`
```dart
- Vue d'ensemble globale
- KPI entreprise
- Charge consultants (graphique)
- Projets en cours/retard
- Congés à valider
- Alertes système
```

#### 2. Dashboard Chef de Projet
**Fichier:** `lib/screens/dashboard/chef_dashboard_screen.dart`
```dart
- Mes projets
- Mon équipe
- Tâches en cours
- Charge de l'équipe
- Congés à valider
- Timeline
```

#### 3. Dashboard Consultant
**Fichier:** `lib/screens/dashboard/consultant_dashboard_screen.dart`
```dart
- Mes tâches du jour
- Mes projets
- Mon planning
- Mes heures ce mois
- Mes congés
- Mes objectifs
```

#### 4. Widgets de Graphiques
**Fichiers:**
- `lib/widgets/charts/bar_chart_widget.dart`
- `lib/widgets/charts/pie_chart_widget.dart`
- `lib/widgets/charts/line_chart_widget.dart`
- `lib/widgets/charts/gantt_chart_widget.dart`

### Phase 5: Notifications (2-3 jours)

#### 1. Service Notifications
**Fichier:** `lib/services/notification_service.dart`
```dart
- initializeNotifications()
- requestPermission()
- sendNotification()
- getNotifications()
- markAsRead()
- deleteNotification()
```

#### 2. FCM Integration
```dart
- Configure FCM
- Handle foreground notifications
- Handle background notifications
- Handle notification taps
```

#### 3. Écran Notifications
**Fichier:** `lib/screens/notifications/notifications_screen.dart`
```dart
- Liste des notifications
- Badge count
- Filtres par type
- Actions rapides
```

### Phase 6: Widgets Communs (ongoing)

**Fichiers:**
- `lib/widgets/common/custom_button.dart`
- `lib/widgets/common/custom_card.dart`
- `lib/widgets/common/custom_text_field.dart`
- `lib/widgets/common/loading_indicator.dart`
- `lib/widgets/common/empty_state.dart`
- `lib/widgets/common/error_widget.dart`
- `lib/widgets/common/avatar_widget.dart`
- `lib/widgets/common/badge_widget.dart`
- `lib/widgets/common/status_chip.dart`

### Phase 7: Tests (2-3 jours)

#### 1. Tests Unitaires
```bash
test/
├── models/
│   ├── user_model_test.dart
│   ├── consultant_model_test.dart
│   └── ...
├── services/
│   ├── auth_service_test.dart
│   ├── consultant_service_test.dart
│   └── ...
└── providers/
    ├── auth_provider_test.dart
    └── ...
```

#### 2. Tests d'Intégration
```bash
integration_test/
├── auth_flow_test.dart
├── consultant_crud_test.dart
├── project_management_test.dart
└── time_tracking_test.dart
```

#### 3. Tests de Widgets
```dart
- Test des formulaires
- Test de la navigation
- Test des états (loading, error, success)
```

### Phase 8: Déploiement

#### Web
```bash
flutter build web --release
# Déployer sur Firebase Hosting
firebase deploy --only hosting
```

#### Android
```bash
flutter build appbundle --release
# Upload sur Google Play Console
```

#### iOS
```bash
flutter build ios --release
# Upload sur App Store Connect
```

---

## 🎨 Design Patterns Recommandés

### 1. Clean Architecture
```
lib/
├── models/          # Entités de données
├── services/        # Services (Firebase, API)
├── repositories/    # Couche d'abstraction (optionnel)
├── providers/       # State management
├── screens/         # UI Screens
├── widgets/         # Composants réutilisables
├── core/           # Configuration, constantes
└── utils/          # Utilitaires, extensions
```

### 2. Gestion d'État avec Riverpod
- Utiliser `Provider` pour les services
- Utiliser `StreamProvider` pour les flux de données
- Utiliser `StateNotifierProvider` pour la logique métier
- Utiliser `FutureProvider` pour les opérations asynchrones

### 3. Navigation
- GoRouter pour navigation déclarative
- Routes protégées avec redirect
- Deep linking support

---

## 📝 Bonnes Pratiques

### Code
- Respecter les conventions de nommage Dart
- Documenter les fonctions publiques
- Utiliser const constructors autant que possible
- Éviter les widgets trop profonds (max 3-4 niveaux)

### Git
- Commits atomiques et descriptifs
- Feature branches: `feature/module-name`
- Pull requests avec description
- Code review avant merge

### Performance
- Utiliser lazy loading pour les listes
- Implémenter pagination
- Cacher les données fréquemment utilisées
- Optimiser les images

### Sécurité
- Valider toutes les entrées utilisateur
- Appliquer les règles Firestore strictement
- Ne jamais stocker de secrets dans le code
- Utiliser HTTPS uniquement

---

## 🐛 Troubleshooting

### Problème: Erreur lors du build_runner
**Solution:**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Problème: Firebase initialization failed
**Solution:**
- Vérifier que google-services.json (Android) ou GoogleService-Info.plist (iOS) est bien placé
- Vérifier les credentials dans firebase_config.dart pour Web
- Rebuilder l'application

### Problème: Provider not found
**Solution:**
- S'assurer que ProviderScope entoure MaterialApp dans main.dart
- Vérifier les imports

### Problème: Routes ne fonctionnent pas
**Solution:**
- Vérifier que routerProvider est bien passé à MaterialApp.router
- Vérifier la syntaxe des routes dans app_router.dart

---

## 📚 Ressources Utiles

### Documentation
- [Flutter](https://flutter.dev/docs)
- [Riverpod](https://riverpod.dev)
- [GoRouter](https://pub.dev/packages/go_router)
- [Firebase](https://firebase.google.com/docs)
- [Freezed](https://pub.dev/packages/freezed)

### Packages Essentiels
- `flutter_riverpod`: State management
- `go_router`: Routing
- `freezed`: Immutable models
- `fl_chart`: Charts
- `intl`: Internationalization
- `shared_preferences`: Local storage

---

**Version:** 1.0
**Date:** 17 Novembre 2025
**Statut:** 🟢 Prêt pour développement
