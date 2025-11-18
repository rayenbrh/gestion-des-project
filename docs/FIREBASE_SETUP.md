# 🔥 Configuration Firebase - Guide Complet

## Étape 1: Créer le Projet Firebase

### 1.1 Créer le projet
1. Allez sur https://console.firebase.google.com
2. Cliquez sur **"Ajouter un projet"**
3. Nom du projet: `consulting-management-app` (ou votre choix)
4. Activez Google Analytics (optionnel mais recommandé)
5. Cliquez sur **"Créer le projet"**

---

## Étape 2: Configurer Authentication

### 2.1 Activer l'authentification Email/Password
1. Dans le menu latéral → **Authentication**
2. Cliquez sur **"Commencer"**
3. Onglet **"Sign-in method"**
4. Cliquez sur **"E-mail/Mot de passe"**
5. Activez **"E-mail/Mot de passe"** (premier bouton)
6. Cliquez sur **"Enregistrer"**

### 2.2 Activer Google Sign-In
1. Dans **"Sign-in method"**
2. Cliquez sur **"Google"**
3. Activez Google
4. Renseignez l'email de support du projet
5. Cliquez sur **"Enregistrer"**

### 2.3 Créer les utilisateurs de test
1. Onglet **"Users"**
2. Cliquez sur **"Ajouter un utilisateur"**

Créez ces 3 utilisateurs:

**Administrateur:**
```
Email: admin@consulting.com
Mot de passe: Password123!
```

**Chef de Projet:**
```
Email: chef@consulting.com
Mot de passe: Password123!
```

**Consultant:**
```
Email: consultant@consulting.com
Mot de passe: Password123!
```

⚠️ **Important:** Notez les **UID** de chaque utilisateur, vous en aurez besoin pour l'étape Firestore.

---

## Étape 3: Configurer Firestore Database

### 3.1 Créer la base de données
1. Menu latéral → **Firestore Database**
2. Cliquez sur **"Créer une base de données"**
3. Mode: **"Commencer en mode production"**
4. Emplacement: **"europe-west1"** (ou proche de votre région)
5. Cliquez sur **"Activer"**

### 3.2 Appliquer les règles de sécurité
1. Onglet **"Règles"**
2. Remplacez le contenu par le fichier: `firebase/firestore.rules`
3. Cliquez sur **"Publier"**

### 3.3 Créer la structure initiale

#### Collection `users`

Pour chaque utilisateur créé à l'étape 2.3, créez un document:

1. Cliquez sur **"Commencer une collection"**
2. ID de collection: `users`
3. ID du document: **[UID de l'utilisateur admin]**

**Document pour Admin:**
```json
{
  "email": "admin@consulting.com",
  "role": "ADMIN",
  "isActive": true,
  "createdAt": [Timestamp - Now],
  "lastLogin": [Timestamp - Now],
  "fcmTokens": [],
  "preferences": {
    "theme": "light",
    "language": "fr",
    "notifications": {
      "email": true,
      "push": true,
      "sms": false
    }
  }
}
```

**Document pour Chef:**
```json
{
  "email": "chef@consulting.com",
  "role": "CHEF_PROJET",
  "isActive": true,
  "createdAt": [Timestamp - Now],
  "lastLogin": [Timestamp - Now],
  "fcmTokens": [],
  "preferences": {
    "theme": "light",
    "language": "fr",
    "notifications": {
      "email": true,
      "push": true,
      "sms": false
    }
  }
}
```

**Document pour Consultant:**
```json
{
  "email": "consultant@consulting.com",
  "role": "CONSULTANT",
  "isActive": true,
  "createdAt": [Timestamp - Now],
  "lastLogin": [Timestamp - Now],
  "fcmTokens": [],
  "preferences": {
    "theme": "light",
    "language": "fr",
    "notifications": {
      "email": true,
      "push": true,
      "sms": false
    }
  }
}
```

#### Collection `settings` (optionnelle)

Document ID: `global-settings`
```json
{
  "company": {
    "name": "ConsultCorp",
    "email": "contact@consultcorp.com",
    "phone": "+33123456789"
  },
  "congesRules": {
    "congesPayesPerYear": 25,
    "rttPerYear": 11,
    "minNoticeDays": 7
  },
  "workingHours": {
    "hoursPerDay": 7,
    "daysPerWeek": 5,
    "hoursPerWeek": 35
  },
  "updatedAt": [Timestamp - Now]
}
```

---

## Étape 4: Configurer Storage

### 4.1 Créer le Storage
1. Menu latéral → **Storage**
2. Cliquez sur **"Commencer"**
3. Mode: **"Commencer en mode production"**
4. Emplacement: **"europe-west1"** (même que Firestore)
5. Cliquez sur **"Terminé"**

### 4.2 Appliquer les règles de sécurité
1. Onglet **"Rules"**
2. Remplacez par le contenu de: `firebase/storage.rules`
3. Cliquez sur **"Publier"**

---

## Étape 5: Configurer Cloud Messaging (FCM)

### 5.1 Activer FCM
1. Menu latéral → **Cloud Messaging**
2. Pas de configuration supplémentaire requise pour le moment
3. Les clés seront générées automatiquement

---

## Étape 6: Configurer l'Application Flutter

### 6.1 Pour Web

1. Dans Firebase Console, cliquez sur l'icône **Web** (</>)
2. Nom de l'app: `Consulting Management Web`
3. Cochez **"Also set up Firebase Hosting"** (optionnel)
4. Cliquez sur **"Enregistrer l'application"**
5. Copiez la configuration affichée

Ouvrez `lib/core/config/firebase_config.dart` et remplacez:

```dart
static const String apiKey = 'VOTRE_API_KEY';
static const String projectId = 'votre-project-id';
static const String messagingSenderId = 'VOTRE_SENDER_ID';
static const String appId = 'VOTRE_APP_ID';
static const String storageBucket = 'votre-project-id.appspot.com';
```

### 6.2 Pour Android

1. Dans Firebase Console, cliquez sur l'icône **Android**
2. Package name: `com.consulting.management`
3. Téléchargez `google-services.json`
4. Placez-le dans: `android/app/google-services.json`

**Modifier `android/build.gradle`:**
```gradle
buildscript {
    dependencies {
        // Ajouter cette ligne
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

**Modifier `android/app/build.gradle`:**
```gradle
// En bas du fichier, ajouter:
apply plugin: 'com.google.gms.google-services'

android {
    defaultConfig {
        applicationId "com.consulting.management"
        minSdkVersion 21  // Minimum pour Firebase
    }
}
```

### 6.3 Pour iOS

1. Dans Firebase Console, cliquez sur l'icône **iOS**
2. Bundle ID: `com.consulting.management`
3. Téléchargez `GoogleService-Info.plist`
4. Ouvrez le projet iOS dans Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```
5. Glissez-déposez `GoogleService-Info.plist` dans le dossier `Runner/Runner`
6. Assurez-vous que "Copy items if needed" est coché

**Modifier `ios/Runner/Info.plist`:**
Ajoutez avant `</dict>`:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.consulting.management</string>
        </array>
    </dict>
</array>
```

### 6.4 Créer le fichier .env

```bash
cp .env.example .env
```

Éditez `.env` avec vos valeurs Firebase:
```env
FIREBASE_API_KEY=AIzaSy...
FIREBASE_PROJECT_ID=consulting-management-app
FIREBASE_APP_ID=1:123456789:web:abc123
FIREBASE_MESSAGING_SENDER_ID=123456789
FIREBASE_STORAGE_BUCKET=consulting-management-app.appspot.com
ENVIRONMENT=development
```

---

## Étape 7: Tester la Configuration

### 7.1 Installer les dépendances
```bash
flutter pub get
```

### 7.2 Générer le code Freezed
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 7.3 Lancer l'application

**Web:**
```bash
flutter run -d chrome
```

**Android:**
```bash
flutter run -d android
```

**iOS:**
```bash
cd ios
pod install
cd ..
flutter run -d ios
```

### 7.4 Tester l'authentification

1. L'app devrait démarrer sur l'écran de login
2. Essayez de vous connecter avec:
   - Email: `admin@consulting.com`
   - Password: `Password123!`
3. Vous devriez être redirigé vers le dashboard
4. Le menu drawer devrait afficher votre email
5. Testez le toggle dark/light mode

---

## Étape 8: Vérifications de Sécurité

### 8.1 Tester les règles Firestore

Dans Firebase Console → Firestore → Règles, testez:

```javascript
// Test lecture users (doit réussir si authentifié)
auth: uid = 'UID_DE_TEST'
path: /users/UID_DE_TEST
operation: get
```

### 8.2 Tester les règles Storage

Dans Firebase Console → Storage → Règles, testez:

```javascript
// Test upload avatar (doit réussir si authentifié)
auth: uid = 'UID_DE_TEST'
path: /consultants/UID_DE_TEST/avatar/avatar.jpg
operation: write
```

---

## Étape 9: Index Firestore (si besoin)

Certaines requêtes complexes nécessitent des index. Firebase vous alertera avec un lien pour les créer automatiquement.

Les index recommandés sont listés dans `docs/DATABASE_SCHEMA.md`

---

## ✅ Checklist de Configuration

- [ ] Projet Firebase créé
- [ ] Authentication activée (Email + Google)
- [ ] 3 utilisateurs de test créés (admin, chef, consultant)
- [ ] Firestore Database créée
- [ ] Règles Firestore appliquées
- [ ] Collection `users` créée avec les 3 documents
- [ ] Storage activé
- [ ] Règles Storage appliquées
- [ ] FCM activé
- [ ] App Web enregistrée
- [ ] App Android enregistrée (si applicable)
- [ ] App iOS enregistrée (si applicable)
- [ ] `google-services.json` placé (Android)
- [ ] `GoogleService-Info.plist` placé (iOS)
- [ ] `firebase_config.dart` mis à jour (Web)
- [ ] `.env` créé et configuré
- [ ] `flutter pub get` exécuté
- [ ] `build_runner` exécuté
- [ ] Test de connexion réussi

---

## 🐛 Problèmes Courants

### "Firebase not initialized"
**Solution:** Vérifiez que `Firebase.initializeApp()` est bien appelé dans `main.dart`

### "User not found in Firestore"
**Solution:** Vérifiez que vous avez créé les documents dans la collection `users` avec les bons UIDs

### "Permission denied"
**Solution:** Vérifiez que les règles Firestore sont bien appliquées

### Erreur de build Android
**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Erreur de build iOS
**Solution:**
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter run
```

---

## 📱 Prochaines Étapes

Une fois Firebase configuré:
1. Testez la connexion avec les 3 types d'utilisateurs
2. Vérifiez que le dashboard s'affiche correctement
3. Testez le menu drawer role-based
4. Continuez avec le développement du Module RH

---

**Besoin d'aide?** Consultez:
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev)
- `docs/IMPLEMENTATION_GUIDE.md` pour la suite du développement
