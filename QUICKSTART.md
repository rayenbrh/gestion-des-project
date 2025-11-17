# ⚡ Quick Start - Application de Gestion de Consulting

Ce guide vous permet de démarrer rapidement avec l'application.

## 📋 Prérequis

- Flutter SDK 3.9+ installé
- Compte Google (pour Firebase)
- Éditeur de code (VS Code recommandé)
- Git installé

---

## 🚀 Étape 1: Cloner et Installer

```bash
# Le projet est déjà cloné
cd gestion-des-project

# Installer les dépendances Flutter
flutter pub get

# Générer le code Freezed (IMPORTANT)
flutter pub run build_runner build --delete-conflicting-outputs
```

⏱️ **Temps estimé:** 5 minutes

---

## 🔥 Étape 2: Configurer Firebase

### Option A: Configuration Rapide (Recommandée)

Suivez le guide complet: **[docs/FIREBASE_SETUP.md](docs/FIREBASE_SETUP.md)**

Checklist rapide:
1. ✅ Créer projet Firebase sur https://console.firebase.google.com
2. ✅ Activer Authentication (Email + Google)
3. ✅ Créer 3 utilisateurs test
4. ✅ Activer Firestore Database
5. ✅ Activer Storage
6. ✅ Configurer l'app (Web/Android/iOS)
7. ✅ Créer le fichier `.env`

### Option B: Configuration Automatisée

Si Firebase CLI est installé:

```bash
# Installer Firebase CLI (si pas déjà fait)
npm install -g firebase-tools

# Login
firebase login

# Déployer les règles de sécurité
./scripts/deploy_firebase.sh
```

⏱️ **Temps estimé:** 20-30 minutes

---

## 🎯 Étape 3: Lancer l'Application

### Web (Recommandé pour commencer)

```bash
flutter run -d chrome
```

### Android

```bash
flutter run -d android
```

### iOS

```bash
cd ios
pod install
cd ..
flutter run -d ios
```

⏱️ **Temps estimé:** 2-3 minutes

---

## 🔑 Étape 4: Se Connecter

Utilisez un des comptes de test créés:

**Administrateur:**
```
Email: admin@consulting.com
Password: Password123!
```

**Chef de Projet:**
```
Email: chef@consulting.com
Password: Password123!
```

**Consultant:**
```
Email: consultant@consulting.com
Password: Password123!
```

---

## ✅ Vérification

Après connexion, vous devriez voir:

1. ✅ Dashboard avec message de bienvenue
2. ✅ Menu drawer avec navigation
3. ✅ Bouton de changement de thème (clair/sombre)
4. ✅ Statistiques (actuellement à 0)
5. ✅ Actions rapides

---

## 📚 Documentation Complète

### Configuration
- **[FIREBASE_SETUP.md](docs/FIREBASE_SETUP.md)** - Configuration Firebase détaillée
- **[IMPLEMENTATION_GUIDE.md](docs/IMPLEMENTATION_GUIDE.md)** - Guide de développement

### Architecture
- **[CAHIER_DES_CHARGES.md](docs/CAHIER_DES_CHARGES.md)** - Spécifications fonctionnelles
- **[UML_DIAGRAMS.md](docs/UML_DIAGRAMS.md)** - Diagrammes UML
- **[DATABASE_SCHEMA.md](docs/DATABASE_SCHEMA.md)** - Schéma de base de données

---

## 🐛 Problèmes Courants

### "Firebase not initialized"
```bash
# Vérifiez que Firebase est bien configuré
# Suivez docs/FIREBASE_SETUP.md Étape 6
```

### "Build failed" lors de build_runner
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Erreur de connexion
```bash
# Vérifiez que vous avez créé les utilisateurs dans Firebase Authentication
# ET les documents correspondants dans Firestore collection 'users'
```

### "User not found in Firestore"
```bash
# Créez les documents users dans Firestore
# Voir docs/FIREBASE_SETUP.md Étape 3.3
```

---

## 🎯 Prochaines Étapes

Une fois l'app lancée et testée:

1. **Phase 2:** Développer le Module RH
   - Consultants CRUD
   - Gestion des congés
   - Compétences et certifications

2. **Phase 3:** Développer le Module Projets
   - Projets CRUD
   - Tâches et Kanban
   - Time tracking

3. **Phase 4:** Dashboards et KPI
   - Graphiques temps réel
   - Statistiques avancées

Voir **[IMPLEMENTATION_GUIDE.md](docs/IMPLEMENTATION_GUIDE.md)** pour les détails.

---

## 💡 Conseils

- **Testez régulièrement** sur Web ET Mobile
- **Committez souvent** avec des messages clairs
- **Lisez la documentation** avant de coder
- **Utilisez les règles de sécurité** Firebase pour protéger les données

---

## 🆘 Besoin d'Aide?

1. Consultez la [documentation Firebase](https://firebase.google.com/docs)
2. Consultez la [documentation Flutter](https://flutter.dev/docs)
3. Regardez les fichiers dans `docs/`
4. Vérifiez les logs avec `AppLogger`

---

## 📊 État du Projet

### ✅ Complété
- Architecture Flutter
- Modèles de données (11 modèles)
- Services (Auth, Storage)
- Providers (Auth, Theme)
- Routing (GoRouter)
- Authentification UI
- Dashboard de base
- Configuration Firebase

### 🔄 En Cours
- Configuration Firebase personnalisée

### ⏳ À Faire
- Module RH
- Module Projets
- Dashboards détaillés
- Notifications
- Tests

---

**Version:** 1.0.0
**Dernière mise à jour:** 17 Novembre 2025

🚀 **Bon développement !**
