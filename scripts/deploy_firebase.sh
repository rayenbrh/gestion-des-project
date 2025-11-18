#!/bin/bash

# Script d'initialisation de la base de données Firestore
# Usage: ./scripts/init_firestore.sh

echo "🔥 Initialisation de Firestore pour Consulting Management App"
echo ""

# Vérifier que Firebase CLI est installé
if ! command -v firebase &> /dev/null
then
    echo "❌ Firebase CLI n'est pas installé"
    echo "Installez-le avec: npm install -g firebase-tools"
    exit 1
fi

echo "✅ Firebase CLI trouvé"
echo ""

# Login Firebase (si pas déjà fait)
echo "📝 Connexion à Firebase..."
firebase login --no-localhost

# Déployer les règles Firestore
echo ""
echo "📤 Déploiement des règles Firestore..."
firebase deploy --only firestore:rules

# Déployer les index Firestore
echo ""
echo "📤 Déploiement des index Firestore..."
firebase deploy --only firestore:indexes

# Déployer les règles Storage
echo ""
echo "📤 Déploiement des règles Storage..."
firebase deploy --only storage

echo ""
echo "✅ Configuration Firebase déployée avec succès!"
echo ""
echo "⚠️  N'oubliez pas de:"
echo "  1. Créer les utilisateurs de test dans Authentication"
echo "  2. Créer les documents users dans Firestore"
echo "  3. Tester les règles de sécurité"
echo ""
echo "📚 Consultez docs/FIREBASE_SETUP.md pour plus de détails"
