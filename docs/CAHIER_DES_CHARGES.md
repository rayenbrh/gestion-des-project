# 📋 Cahier des Charges - Application de Gestion de Consulting

## 1. Présentation du Projet

### 1.1 Contexte
Application web et mobile pour la gestion interne d'un bureau de consulting composé de 3 à 10 consultants.

### 1.2 Objectifs Principaux
- Digitaliser la gestion des projets et missions de consulting
- Optimiser le suivi des tâches et des délais
- Centraliser les informations des consultants (compétences, charges, disponibilité)
- Automatiser et simplifier les processus RH internes
- Fournir des tableaux de bord de pilotage

### 1.3 Périmètre
- Application cross-platform (Web + Mobile iOS/Android)
- Gestion de 3 à 10 consultants simultanément
- Multi-utilisateurs avec gestion des rôles
- Temps réel pour les mises à jour

---

## 2. Modules Fonctionnels

### 2.1 Module Authentification et Sécurité

#### Fonctionnalités
- Connexion par email/mot de passe
- Connexion Google (Firebase Auth)
- Récupération de mot de passe
- Gestion des sessions
- Tokens JWT/Firebase
- Sécurité des données (RGPD)

#### Rôles utilisateurs
1. **Administrateur** (Directeur du cabinet)
   - Accès complet à tous les modules
   - Gestion des utilisateurs
   - Configuration du système
   - Validation finale des congés et projets

2. **Chef de Projet**
   - Gestion des projets assignés
   - Affectation des consultants
   - Suivi des tâches et délais
   - Validation des congés de son équipe
   - Accès aux KPI de ses projets

3. **Consultant**
   - Consultation de son profil
   - Mise à jour de ses compétences
   - Saisie des temps passés
   - Demande de congés
   - Vue sur ses projets et tâches

---

### 2.2 Module RH (Ressources Humaines)

#### 2.2.1 Gestion des Consultants

**Fiche Consultant**
- Informations personnelles
  - Nom, prénom, email, téléphone
  - Photo de profil
  - Date d'entrée, poste, département
  - Statut (actif, inactif, en congé)

- Compétences et Expertise
  - Liste des compétences (niveau: débutant, intermédiaire, expert)
  - Technologies maîtrisées
  - Domaines d'expertise
  - Langues parlées
  - Certifications (nom, date d'obtention, validité)

- Expérience
  - Années d'expérience
  - Projets antérieurs
  - Formations suivies

- Documents
  - CV
  - Contrat de travail
  - Documents administratifs
  - Certificats
  - Stockage Firebase Storage

**Disponibilité et Charge de Travail**
- Calendrier de disponibilité
- Charge actuelle (%)
- Affectations en cours
- Planning prévisionnel (mensuel/trimestriel)
- Vue graphique de la charge
- Alertes si surcharge (>100%)

#### 2.2.2 Gestion des Congés et Absences

**Types d'absences**
- Congés payés
- RTT
- Congés maladie
- Congés sans solde
- Formation
- Autre

**Workflow de demande**
1. Consultant crée une demande
   - Type de congé
   - Date début/fin
   - Nombre de jours
   - Motif/commentaire
   - Statut: Brouillon

2. Soumission de la demande
   - Statut: En attente
   - Notification au chef de projet

3. Validation Chef de Projet
   - Accepter/Refuser
   - Commentaire
   - Si accepté → notification Admin

4. Validation finale Administrateur
   - Accepter/Refuser définitif
   - Statut final: Approuvé/Rejeté
   - Notification au consultant

**Solde de congés**
- Compteur de jours disponibles
- Historique des congés
- Période de référence
- Calcul automatique des soldes

#### 2.2.3 Évaluations et Performance

**Évaluations annuelles**
- Date d'évaluation
- Objectifs fixés
- Résultats obtenus
- Points forts/axes d'amélioration
- Note globale
- Plan de développement
- Signature évaluateur/évalué

**Suivi des objectifs**
- Objectifs SMART
- Progression (%)
- Échéances
- Statut (en cours, atteint, non atteint)

#### 2.2.4 Gestion Administrative

**Données salariales** (Accès Admin uniquement)
- Salaire de base
- Primes/bonus
- Taux horaire/journalier
- Historique des augmentations

**Contrats**
- Type de contrat (CDI, CDD, Freelance)
- Date de début/fin
- Renouvellement

---

### 2.3 Module Gestion des Projets

#### 2.3.1 Projets

**Création et configuration**
- Informations générales
  - Nom du projet
  - Code projet (unique)
  - Client (nom, contact)
  - Type (interne, externe)
  - Description
  - Objectifs

- Planning
  - Date de début/fin
  - Durée estimée
  - Jalons (milestones)
  - Budget (optionnel)

- Équipe projet
  - Chef de projet
  - Consultants assignés
  - Rôle de chacun
  - Charge allouée (%)

**Statuts de projet**
- Planifié
- En cours
- En pause
- Terminé
- Annulé
- En retard (automatique si deadline dépassée)

**Suivi et indicateurs**
- Avancement global (%)
- Tâches complétées/totales
- Temps passé vs estimé
- Livrables
- Risques identifiés
- Incidents/problèmes

#### 2.3.2 Missions

**Définition**
- Nom de la mission
- Projet parent
- Description
- Objectif
- Consultant(s) assigné(s)
- Date début/fin
- Statut (à faire, en cours, terminé)

**Livrables**
- Liste des livrables attendus
- Documents/fichiers
- Date de livraison
- Validation

#### 2.3.3 Tâches

**Gestion des tâches**
- Titre
- Description détaillée
- Projet/mission associé(e)
- Assigné à (consultant)
- Priorité (basse, moyenne, haute, critique)
- Statut
  - À faire
  - En cours
  - En revue
  - Terminée
  - Bloquée
- Dates
  - Date de création
  - Date d'échéance
  - Date de début
  - Date de fin réelle
- Estimation (heures)
- Temps réel passé

**Sous-tâches**
- Décomposition en sous-tâches
- Checklist
- Progression

**Dépendances**
- Tâches bloquantes
- Tâches dépendantes
- Vue Gantt (optionnel)

**Commentaires et activité**
- Fil de discussion
- Pièces jointes
- Historique des modifications
- Tags/labels

#### 2.3.4 Time Tracking (Suivi des Temps)

**Saisie des temps**
- Consultant saisit le temps passé
- Sélection projet/mission/tâche
- Date
- Nombre d'heures
- Description de l'activité
- Type (développement, réunion, formation, etc.)

**Feuilles de temps**
- Vue hebdomadaire/mensuelle
- Validation par chef de projet
- Export (Excel, PDF)
- Statistiques individuelles

**Rapports de temps**
- Temps par projet
- Temps par consultant
- Temps par période
- Comparaison estimé vs réel

#### 2.3.5 Gestion des Risques et Incidents

**Risques**
- Description du risque
- Probabilité (faible, moyenne, élevée)
- Impact (faible, moyen, critique)
- Plan d'atténuation
- Responsable
- Statut (identifié, en cours, résolu)

**Incidents**
- Description
- Gravité
- Date de survenue
- Actions correctives
- Résolution

---

### 2.4 Module Tableaux de Bord et KPI

#### 2.4.1 Dashboard Principal (Admin)

**Vue d'ensemble**
- Nombre de consultants actifs
- Nombre de projets en cours/terminés
- Taux de charge moyen
- Congés en cours/à venir
- Alertes importantes

**Graphiques et statistiques**
- Charge de travail par consultant (bar chart)
- Répartition des projets par statut (pie chart)
- Timeline des projets (Gantt simplifié)
- Évolution du nombre de projets (line chart)
- Taux d'occupation mensuel

#### 2.4.2 Dashboard Chef de Projet

**Mes projets**
- Liste des projets assignés
- Statut et avancement
- Alertes (retards, surcharges)
- Prochaines échéances

**Mon équipe**
- Consultants de l'équipe
- Disponibilité
- Tâches en cours

#### 2.4.3 Dashboard Consultant

**Mes activités**
- Mes projets actifs
- Mes tâches du jour/semaine
- Mon planning
- Mes congés

**Mes statistiques**
- Heures travaillées ce mois
- Projets complétés
- Tâches terminées
- Évaluations

#### 2.4.4 KPI et Métriques

**KPI Projets**
- Taux de complétion
- Respect des délais
- Temps moyen par projet
- Nombre de projets livrés dans les temps

**KPI Consultants**
- Taux d'occupation moyen
- Heures facturables
- Nombre de projets par consultant
- Performance (basé sur évaluations)

**KPI RH**
- Taux d'absentéisme
- Solde de congés moyen
- Turnover
- Satisfaction (si enquêtes)

---

## 3. Spécifications Techniques

### 3.1 Architecture

**Frontend**
- Framework: Flutter
- Plateformes: Web, iOS, Android
- État management: Riverpod ou Provider
- Navigation: Go Router
- Responsive design

**Backend**
- Option 1: Firebase (recommandé pour MVP)
  - Firestore (base NoSQL)
  - Firebase Auth
  - Firebase Storage
  - Cloud Functions (si logique métier complexe)
  - Firebase Cloud Messaging (notifications)

- Option 2: Node.js + PostgreSQL
  - Express.js
  - PostgreSQL + Prisma ORM
  - JWT Authentication
  - REST API ou GraphQL

### 3.2 Base de Données

**Collections/Tables principales**
- users (authentification et rôles)
- consultants (profils détaillés)
- projects (projets)
- missions
- tasks (tâches)
- timeTracking (suivi des temps)
- conges (demandes de congés)
- evaluations
- competences (compétences)
- documents (métadonnées fichiers)
- notifications

### 3.3 Sécurité

- Authentification Firebase Auth ou JWT
- Règles de sécurité Firestore
- Validation des données côté client et serveur
- Chiffrement des données sensibles
- HTTPS obligatoire
- Conformité RGPD
- Sauvegarde automatique des données

### 3.4 Packages Flutter Requis

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Firebase
  firebase_core: ^2.24.0
  firebase_auth: ^4.15.0
  cloud_firestore: ^4.13.0
  firebase_storage: ^11.5.0
  firebase_messaging: ^14.7.0

  # State Management
  flutter_riverpod: ^2.4.9

  # UI et Design
  google_fonts: ^6.1.0
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0

  # Navigation
  go_router: ^12.1.3

  # Charts et graphs
  fl_chart: ^0.65.0
  syncfusion_flutter_charts: ^24.1.41

  # Formulaires et validation
  flutter_form_builder: ^9.1.1
  form_builder_validators: ^9.1.0

  # Date et temps
  intl: ^0.18.1
  table_calendar: ^3.0.9

  # Fichiers et documents
  file_picker: ^6.1.1
  image_picker: ^1.0.5
  pdf: ^3.10.7

  # Notifications
  flutter_local_notifications: ^16.3.0

  # Utils
  uuid: ^4.3.3
  http: ^1.1.2
  shared_preferences: ^2.2.2
  connectivity_plus: ^5.0.2

  # Icons
  font_awesome_flutter: ^10.6.0
  cupertino_icons: ^1.0.6
```

---

## 4. Design UI/UX

### 4.1 Charte Graphique

**Style**
- Design moderne et minimaliste
- Interface épurée et professionnelle
- Espacements généreux
- Typographie claire et lisible

**Palette de couleurs**
- Couleur primaire: Bleu (#2196F3)
- Couleur secondaire: Orange (#FF9800)
- Couleur succès: Vert (#4CAF50)
- Couleur erreur: Rouge (#F44336)
- Couleur warning: Jaune (#FFC107)
- Couleur neutre: Gris (#9E9E9E)

**Thèmes**
- Light mode (par défaut)
  - Background: #FFFFFF
  - Surface: #F5F5F5
  - Text: #212121

- Dark mode
  - Background: #121212
  - Surface: #1E1E1E
  - Text: #FFFFFF

### 4.2 Composants UI

**Navigation**
- Web: Sidebar fixe + top bar
- Mobile: Bottom navigation bar + drawer
- Breadcrumbs pour navigation hiérarchique

**Cartes et widgets**
- Cards avec ombre légère
- Statistiques avec icônes et chiffres
- Graphiques interactifs
- Listes avec avatars et badges

**Formulaires**
- Champs avec labels flottants
- Validation en temps réel
- Messages d'erreur clairs
- Boutons de soumission désactivés si formulaire invalide

**Tables**
- Tableaux responsives
- Tri et filtrage
- Pagination
- Actions rapides (éditer, supprimer)
- Export Excel/PDF

---

## 5. User Stories Principales

### Administrateur
1. En tant qu'admin, je veux créer et gérer les comptes utilisateurs
2. En tant qu'admin, je veux voir un dashboard global de l'activité
3. En tant qu'admin, je veux valider ou rejeter les demandes de congés
4. En tant qu'admin, je veux gérer les données salariales des consultants
5. En tant qu'admin, je veux exporter des rapports personnalisés

### Chef de Projet
1. En tant que chef de projet, je veux créer un nouveau projet
2. En tant que chef de projet, je veux assigner des consultants à mon projet
3. En tant que chef de projet, je veux suivre l'avancement des tâches
4. En tant que chef de projet, je veux voir la charge de travail de mon équipe
5. En tant que chef de projet, je veux valider les feuilles de temps

### Consultant
1. En tant que consultant, je veux voir mes tâches du jour
2. En tant que consultant, je veux saisir mes heures de travail
3. En tant que consultant, je veux demander des congés
4. En tant que consultant, je veux mettre à jour mes compétences
5. En tant que consultant, je veux voir mes projets en cours

---

## 6. Contraintes et Exigences

### 6.1 Contraintes Techniques
- Compatible Web (Chrome, Firefox, Safari, Edge)
- Compatible Mobile iOS 12+ et Android 8+
- Temps de chargement < 3 secondes
- Support hors ligne partiel (consultation des données)
- Synchronisation automatique

### 6.2 Contraintes Fonctionnelles
- Support de 3 à 10 consultants simultanés
- Gestion multi-projets (pas de limite)
- Historique conservé 5 ans minimum
- Sauvegardes quotidiennes automatiques

### 6.3 Contraintes Légales
- Conformité RGPD
- Droit à l'oubli
- Portabilité des données
- Logs d'audit

---

## 7. Planning et Livrables

### Phase 1: Conception (Semaine 1)
- ✅ Cahier des charges
- ✅ Diagrammes UML
- ✅ Schéma de base de données
- ⏳ Maquettes Figma

### Phase 2: Setup et Architecture (Semaine 2)
- Configuration Firebase
- Architecture Flutter (Clean Architecture)
- Modèles de données
- Services de base

### Phase 3: Module Authentification (Semaine 2-3)
- Écrans de connexion/inscription
- Gestion des sessions
- Gestion des rôles

### Phase 4: Module RH (Semaine 3-5)
- Gestion des consultants
- Gestion des congés
- Gestion des compétences

### Phase 5: Module Projets (Semaine 5-7)
- Gestion des projets
- Gestion des tâches
- Time tracking

### Phase 6: Dashboards (Semaine 7-8)
- Dashboard Admin
- Dashboard Chef de projet
- Dashboard Consultant
- Graphiques et KPI

### Phase 7: Notifications et Finitions (Semaine 8-9)
- Notifications push
- Emails automatiques
- Optimisations

### Phase 8: Tests et Documentation (Semaine 9-10)
- Tests unitaires
- Tests d'intégration
- Tests UI
- Documentation technique
- Guide utilisateur

### Phase 9: Déploiement (Semaine 10)
- Déploiement Web
- Publication iOS App Store
- Publication Android Play Store
- Formation utilisateurs

---

## 8. Critères de Succès

- ✅ Application fonctionnelle sur Web et Mobile
- ✅ Tous les modules implémentés
- ✅ Interface intuitive et moderne
- ✅ Performance optimale (< 3s chargement)
- ✅ Sécurité validée
- ✅ Tests passants (>80% couverture)
- ✅ Documentation complète
- ✅ Satisfaction utilisateurs

---

## 9. Évolutions Futures (V2)

- Intégration calendrier externe (Google Calendar)
- Génération automatique de rapports PDF
- Module de facturation clients
- Chatbot d'assistance
- Application mobile native (si nécessaire)
- Intégration Slack/Teams
- Module de formation continue
- Gestion des congés payés automatique
- IA pour prédiction de charge
- Export données comptables

---

**Version:** 1.0
**Date:** 17 Novembre 2025
**Auteur:** Claude AI
**Statut:** ✅ Validé
