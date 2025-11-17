# 🏢 Application de Gestion de Consulting

Application web et mobile Flutter pour la gestion interne d'un cabinet de consulting de 3 à 10 consultants.

## 📋 Vue d'ensemble

Cette application permet de:
- **Gérer les ressources humaines** (consultants, compétences, congés, évaluations)
- **Piloter les projets** (projets, missions, tâches, affectations)
- **Suivre les temps** de travail des consultants
- **Visualiser des KPI** et tableaux de bord
- **Gérer les notifications** en temps réel

## 🎯 Fonctionnalités principales

### Module RH
- Gestion des profils consultants (compétences, certifications, documents)
- Workflow de demande et validation de congés
- Suivi de la disponibilité et charge de travail
- Évaluations annuelles et objectifs

### Module Gestion de Projets
- Création et suivi de projets
- Affectation des consultants
- Gestion des missions et tâches
- Time tracking
- Gestion des risques

### Module Dashboards
- Dashboard administrateur
- Dashboard chef de projet
- Dashboard consultant
- KPI en temps réel

## 🛠️ Technologies

- Flutter 3.9+ (Web + Mobile)
- Firebase (Firestore, Auth, Storage, FCM)
- Riverpod (State Management)
- GoRouter (Navigation)
- Freezed (Modèles immutables)

## 📚 Documentation

- [Cahier des charges](docs/CAHIER_DES_CHARGES.md)
- [Diagrammes UML](docs/UML_DIAGRAMS.md)
- [Schéma de base de données](docs/DATABASE_SCHEMA.md)

## 🚀 Installation

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

**Version**: 1.0.0
