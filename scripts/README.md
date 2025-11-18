# 🔥 Scripts Firebase

Ce dossier contient des scripts utiles pour la configuration et le déploiement Firebase.

## deploy_firebase.sh

Déploie automatiquement:
- Règles de sécurité Firestore
- Index Firestore
- Règles de sécurité Storage

### Prérequis

```bash
# Installer Firebase CLI
npm install -g firebase-tools

# Se connecter
firebase login
```

### Utilisation

```bash
# Donner les permissions d'exécution (déjà fait)
chmod +x scripts/deploy_firebase.sh

# Exécuter le script
./scripts/deploy_firebase.sh
```

## Autres scripts utiles

### Initialiser Firebase dans le projet

```bash
firebase init
```

Sélectionnez:
- Firestore
- Storage
- Hosting (optionnel)

### Déployer seulement les règles Firestore

```bash
firebase deploy --only firestore:rules
```

### Déployer seulement les index

```bash
firebase deploy --only firestore:indexes
```

### Déployer seulement Storage

```bash
firebase deploy --only storage
```

### Tester les règles localement

```bash
firebase emulators:start
```

### Déployer l'app Web sur Firebase Hosting

```bash
# Build l'application
flutter build web

# Déployer
firebase deploy --only hosting
```

## Commandes utiles

### Voir les projets Firebase

```bash
firebase projects:list
```

### Changer de projet

```bash
firebase use <project-id>
```

### Voir les logs

```bash
firebase functions:log
```

### Exporter la base de données

```bash
gcloud firestore export gs://[BUCKET_NAME]/[EXPORT_PREFIX]
```
