# 🗄️ Schéma de Base de Données - Firebase Firestore

## Vue d'ensemble

Cette application utilise **Firebase Firestore** comme base de données NoSQL. Les données sont organisées en collections et documents.

---

## 📊 Collections Principales

### 1. Collection: `users`

Stocke les informations d'authentification et les rôles des utilisateurs.

```json
{
  "userId": "auto-generated-id",
  "email": "john.doe@example.com",
  "role": "CONSULTANT", // ADMIN | CHEF_PROJET | CONSULTANT
  "isActive": true,
  "createdAt": "2025-01-15T10:30:00Z",
  "lastLogin": "2025-11-17T08:00:00Z",
  "fcmTokens": ["token1", "token2"], // Pour notifications push
  "preferences": {
    "theme": "light", // light | dark
    "language": "fr",
    "notifications": {
      "email": true,
      "push": true,
      "sms": false
    }
  }
}
```

**Index:**
- `email` (unique)
- `role`
- `isActive`

---

### 2. Collection: `consultants`

Contient les profils détaillés des consultants.

```json
{
  "consultantId": "auto-generated-id",
  "userId": "ref-to-users",
  "firstName": "John",
  "lastName": "Doe",
  "phone": "+33612345678",
  "photoUrl": "https://storage.firebase.com/...",
  "position": "Consultant Senior",
  "department": "IT",
  "dateJoined": "2023-01-10T00:00:00Z",
  "status": "ACTIF", // ACTIF | EN_CONGE | INACTIF | EN_MISSION
  "yearsExperience": 5,
  "hourlyRate": 80.0,
  "dailyRate": 600.0,
  "availability": 40.0, // % disponible (0-100)
  "currentWorkload": 60.0, // % chargé actuellement
  "congesBalance": {
    "congesPayes": 25,
    "rtt": 10,
    "formation": 5
  },
  "address": {
    "street": "123 Rue de la Paix",
    "city": "Paris",
    "zipCode": "75001",
    "country": "France"
  },
  "emergencyContact": {
    "name": "Jane Doe",
    "phone": "+33687654321",
    "relation": "Conjoint"
  },
  "createdAt": "2023-01-10T09:00:00Z",
  "updatedAt": "2025-11-17T14:30:00Z"
}
```

**Index:**
- `userId`
- `status`
- `department`
- `availability`

**Sous-collections:**
- `consultants/{id}/skills`
- `consultants/{id}/certifications`
- `consultants/{id}/documents`
- `consultants/{id}/evaluations`

---

### 2.1 Sous-collection: `consultants/{id}/skills`

```json
{
  "skillId": "auto-generated-id",
  "name": "Flutter",
  "category": "Mobile Development",
  "level": "EXPERT", // DEBUTANT | INTERMEDIAIRE | AVANCE | EXPERT
  "yearsOfExperience": 3,
  "lastUsed": "2025-11-01T00:00:00Z",
  "certified": false,
  "addedAt": "2023-01-15T00:00:00Z"
}
```

---

### 2.2 Sous-collection: `consultants/{id}/certifications`

```json
{
  "certificationId": "auto-generated-id",
  "name": "AWS Certified Solutions Architect",
  "issuingOrganization": "Amazon Web Services",
  "issueDate": "2024-06-15T00:00:00Z",
  "expirationDate": "2027-06-15T00:00:00Z",
  "credentialId": "AWS-12345",
  "credentialUrl": "https://...",
  "certificateFile": "https://storage.firebase.com/...",
  "addedAt": "2024-06-20T00:00:00Z"
}
```

---

### 2.3 Sous-collection: `consultants/{id}/documents`

```json
{
  "documentId": "auto-generated-id",
  "title": "Contrat de travail",
  "type": "CONTRACT", // CV | CONTRACT | CERTIFICATE | ADMINISTRATIVE | OTHER
  "fileUrl": "https://storage.firebase.com/...",
  "fileName": "contrat_john_doe.pdf",
  "fileSize": 245678, // bytes
  "mimeType": "application/pdf",
  "uploadedAt": "2023-01-10T10:00:00Z",
  "uploadedBy": "admin-user-id",
  "isConfidential": true,
  "expirationDate": null
}
```

---

### 2.4 Sous-collection: `consultants/{id}/evaluations`

```json
{
  "evaluationId": "auto-generated-id",
  "consultantId": "ref",
  "evaluatorId": "ref-to-users",
  "evaluationDate": "2024-12-15T00:00:00Z",
  "period": "2024",
  "objectives": [
    {
      "objectiveId": "obj-1",
      "title": "Améliorer compétences Flutter",
      "description": "Obtenir certification Flutter",
      "targetDate": "2024-06-30T00:00:00Z",
      "progress": 100,
      "status": "ATTEINT" // EN_COURS | ATTEINT | NON_ATTEINT | ABANDONNE
    }
  ],
  "achievements": "Livré 3 projets majeurs avec succès...",
  "strengths": "Excellente maîtrise technique, bon esprit d'équipe",
  "improvements": "Améliorer compétences en communication client",
  "globalRating": 4.5, // sur 5
  "technicalRating": 5.0,
  "teamworkRating": 4.0,
  "communicationRating": 4.0,
  "comments": "Excellent consultant, très autonome",
  "developmentPlan": "Formation en gestion de projet prévue",
  "nextReviewDate": "2025-12-15T00:00:00Z",
  "signedByConsultant": true,
  "signedByEvaluator": true,
  "createdAt": "2024-12-01T00:00:00Z"
}
```

---

### 3. Collection: `conges`

Gestion des demandes de congés.

```json
{
  "congeId": "auto-generated-id",
  "consultantId": "ref-to-consultants",
  "type": "CONGE_PAYE", // CONGE_PAYE | RTT | MALADIE | SANS_SOLDE | FORMATION | AUTRE
  "startDate": "2025-12-20T00:00:00Z",
  "endDate": "2025-12-31T00:00:00Z",
  "numberOfDays": 10,
  "reason": "Vacances de fin d'année",
  "status": "APPROUVE", // BROUILLON | EN_ATTENTE | VALIDE_CHEF | APPROUVE | REJETE | ANNULE
  "requestDate": "2025-11-10T10:00:00Z",
  "validations": {
    "chefProjet": {
      "validated": true,
      "validatedBy": "chef-user-id",
      "validatedAt": "2025-11-11T09:00:00Z",
      "comment": "Approuvé, bonne période"
    },
    "admin": {
      "validated": true,
      "validatedBy": "admin-user-id",
      "validatedAt": "2025-11-12T10:00:00Z",
      "comment": "Validation finale OK"
    }
  },
  "attachments": [
    {
      "url": "https://...",
      "name": "justificatif.pdf"
    }
  ],
  "createdAt": "2025-11-10T10:00:00Z",
  "updatedAt": "2025-11-12T10:00:00Z"
}
```

**Index:**
- `consultantId`
- `status`
- `startDate`
- `type`

---

### 4. Collection: `projects`

Gestion des projets.

```json
{
  "projectId": "auto-generated-id",
  "code": "PROJ-2025-001",
  "name": "Développement Application Mobile Banking",
  "description": "Création d'une app mobile pour banque...",
  "clientName": "BankCorp",
  "clientContact": {
    "name": "Marie Martin",
    "email": "marie@bankcorp.com",
    "phone": "+33123456789"
  },
  "type": "EXTERNE", // INTERNE | EXTERNE | R_AND_D
  "status": "EN_COURS", // PLANIFIE | EN_COURS | EN_PAUSE | TERMINE | ANNULE | EN_RETARD
  "priority": "HAUTE",
  "startDate": "2025-01-15T00:00:00Z",
  "endDate": "2025-06-30T00:00:00Z",
  "actualEndDate": null,
  "budget": 150000.0,
  "chefProjetId": "ref-to-users",
  "progress": 45.0, // %
  "milestones": [
    {
      "milestoneId": "m1",
      "name": "Phase 1: Conception",
      "description": "Design et maquettes",
      "targetDate": "2025-02-28T00:00:00Z",
      "completedDate": "2025-02-25T00:00:00Z",
      "status": "TERMINE"
    }
  ],
  "tags": ["mobile", "finance", "flutter"],
  "stats": {
    "totalTasks": 50,
    "completedTasks": 22,
    "totalHours": 1200,
    "estimatedHours": 2000,
    "teamSize": 4
  },
  "createdAt": "2025-01-01T00:00:00Z",
  "updatedAt": "2025-11-17T12:00:00Z"
}
```

**Index:**
- `code` (unique)
- `status`
- `chefProjetId`
- `startDate`
- `type`

**Sous-collections:**
- `projects/{id}/assignments`
- `projects/{id}/missions`
- `projects/{id}/risks`

---

### 4.1 Sous-collection: `projects/{id}/assignments`

Affectation des consultants aux projets.

```json
{
  "assignmentId": "auto-generated-id",
  "projectId": "ref",
  "consultantId": "ref-to-consultants",
  "role": "Développeur Flutter Senior",
  "allocatedLoad": 50.0, // % du temps du consultant
  "startDate": "2025-01-15T00:00:00Z",
  "endDate": "2025-06-30T00:00:00Z",
  "isActive": true,
  "hourlyRate": 80.0,
  "totalHoursLogged": 250.0,
  "createdAt": "2025-01-10T00:00:00Z"
}
```

---

### 4.2 Sous-collection: `projects/{id}/missions`

Missions au sein d'un projet.

```json
{
  "missionId": "auto-generated-id",
  "projectId": "ref",
  "name": "Développement Module Paiement",
  "description": "Intégration Stripe et gestion des transactions",
  "objective": "Module de paiement sécurisé fonctionnel",
  "consultantIds": ["cons-1", "cons-2"],
  "startDate": "2025-03-01T00:00:00Z",
  "endDate": "2025-04-15T00:00:00Z",
  "status": "EN_COURS",
  "deliverables": [
    {
      "deliverableId": "d1",
      "name": "API Paiement",
      "description": "API REST pour paiements",
      "dueDate": "2025-03-20T00:00:00Z",
      "deliveredDate": "2025-03-18T00:00:00Z",
      "fileUrl": "https://...",
      "isValidated": true,
      "validatedBy": "chef-id",
      "validatedAt": "2025-03-19T00:00:00Z"
    }
  ],
  "progress": 70.0,
  "createdAt": "2025-02-25T00:00:00Z"
}
```

---

### 4.3 Sous-collection: `projects/{id}/risks`

Gestion des risques projet.

```json
{
  "riskId": "auto-generated-id",
  "projectId": "ref",
  "description": "Risque de retard sur l'API tierce",
  "probability": "MOYEN", // FAIBLE | MOYEN | ELEVE | CRITIQUE
  "impact": "ELEVE",
  "riskScore": 12, // probability × impact
  "mitigationPlan": "Prévoir une solution de fallback",
  "responsibleId": "ref-to-users",
  "status": "EN_COURS", // IDENTIFIE | EN_COURS | RESOLU | ACCEPTE
  "identifiedDate": "2025-03-10T00:00:00Z",
  "resolvedDate": null,
  "createdAt": "2025-03-10T00:00:00Z"
}
```

---

### 5. Collection: `tasks`

Gestion des tâches.

```json
{
  "taskId": "auto-generated-id",
  "projectId": "ref-to-projects",
  "missionId": "ref-to-missions", // optionnel
  "title": "Implémenter authentification Firebase",
  "description": "Mettre en place Firebase Auth avec Google Sign-In",
  "assignedTo": "consultant-user-id",
  "priority": "HAUTE", // BASSE | MOYENNE | HAUTE | CRITIQUE
  "status": "EN_COURS", // A_FAIRE | EN_COURS | EN_REVUE | TERMINEE | BLOQUEE
  "createdBy": "chef-user-id",
  "createdAt": "2025-03-01T09:00:00Z",
  "dueDate": "2025-03-10T17:00:00Z",
  "startDate": "2025-03-02T08:00:00Z",
  "completedDate": null,
  "estimatedHours": 16.0,
  "actualHours": 12.5,
  "progress": 75.0,
  "subtasks": [
    {
      "subtaskId": "st1",
      "title": "Configurer Firebase project",
      "isCompleted": true,
      "completedAt": "2025-03-02T10:00:00Z"
    },
    {
      "subtaskId": "st2",
      "title": "Implémenter login UI",
      "isCompleted": true,
      "completedAt": "2025-03-03T14:00:00Z"
    },
    {
      "subtaskId": "st3",
      "title": "Tester flux complet",
      "isCompleted": false,
      "completedAt": null
    }
  ],
  "tags": ["auth", "firebase", "security"],
  "dependencies": ["task-123"], // IDs des tâches bloquantes
  "blockedBy": [],
  "attachments": [
    {
      "url": "https://...",
      "name": "mockup_login.png",
      "uploadedAt": "2025-03-01T10:00:00Z"
    }
  ],
  "updatedAt": "2025-11-17T16:00:00Z"
}
```

**Index:**
- `projectId`
- `assignedTo`
- `status`
- `dueDate`
- `priority`

**Sous-collection:**
- `tasks/{id}/comments`

---

### 5.1 Sous-collection: `tasks/{id}/comments`

Commentaires sur les tâches.

```json
{
  "commentId": "auto-generated-id",
  "taskId": "ref",
  "authorId": "ref-to-users",
  "content": "J'ai terminé l'intégration, prêt pour review",
  "createdAt": "2025-03-09T15:30:00Z",
  "updatedAt": "2025-03-09T15:30:00Z",
  "attachments": [
    {
      "url": "https://...",
      "name": "screenshot.png"
    }
  ],
  "mentions": ["@user-id-2"], // Utilisateurs mentionnés
  "isEdited": false
}
```

---

### 6. Collection: `timeTracking`

Suivi des temps de travail.

```json
{
  "timeEntryId": "auto-generated-id",
  "consultantId": "ref-to-consultants",
  "projectId": "ref-to-projects",
  "missionId": "ref-to-missions", // optionnel
  "taskId": "ref-to-tasks", // optionnel
  "date": "2025-11-17T00:00:00Z",
  "hours": 6.5,
  "description": "Développement module authentification + revue code",
  "activityType": "DEVELOPPEMENT", // DEVELOPPEMENT | REUNION | FORMATION | DOCUMENTATION | SUPPORT | AUTRE
  "isBillable": true,
  "isValidated": false,
  "validatedBy": null,
  "validatedAt": null,
  "createdAt": "2025-11-17T18:00:00Z",
  "updatedAt": "2025-11-17T18:00:00Z"
}
```

**Index:**
- `consultantId`
- `projectId`
- `date`
- `isValidated`

---

### 7. Collection: `notifications`

Système de notifications.

```json
{
  "notificationId": "auto-generated-id",
  "userId": "ref-to-users",
  "title": "Nouvelle demande de congé",
  "message": "John Doe a demandé un congé du 20 au 31 décembre",
  "type": "CONGE_REQUEST", // CONGE_REQUEST | CONGE_APPROVED | CONGE_REJECTED | TASK_ASSIGNED | PROJECT_UPDATE | DEADLINE_REMINDER | SYSTEM_ALERT | EVALUATION_DUE
  "isRead": false,
  "readAt": null,
  "priority": "NORMAL", // LOW | NORMAL | HIGH
  "relatedEntityType": "conge", // conge | task | project | evaluation
  "relatedEntityId": "conge-123",
  "actionUrl": "/conges/conge-123", // Lien pour action rapide
  "metadata": {
    "consultantName": "John Doe",
    "startDate": "2025-12-20",
    "endDate": "2025-12-31"
  },
  "createdAt": "2025-11-10T10:05:00Z",
  "expiresAt": "2025-12-10T00:00:00Z" // Optionnel, pour notifications temporaires
}
```

**Index:**
- `userId`
- `isRead`
- `createdAt`
- `type`

---

### 8. Collection: `activityLogs`

Journal d'activité (audit trail).

```json
{
  "logId": "auto-generated-id",
  "userId": "ref-to-users",
  "action": "UPDATE_PROJECT", // CREATE | UPDATE | DELETE | LOGIN | LOGOUT
  "entityType": "project",
  "entityId": "project-123",
  "changes": {
    "field": "status",
    "oldValue": "EN_COURS",
    "newValue": "TERMINE"
  },
  "ipAddress": "192.168.1.1",
  "userAgent": "Mozilla/5.0...",
  "timestamp": "2025-11-17T16:30:00Z"
}
```

**Index:**
- `userId`
- `entityType`
- `timestamp`
- `action`

---

### 9. Collection: `settings`

Configuration globale de l'application.

```json
{
  "settingId": "global-settings",
  "company": {
    "name": "ConsultCorp",
    "logo": "https://storage.firebase.com/...",
    "email": "contact@consultcorp.com",
    "phone": "+33123456789",
    "address": "123 Rue de Consulting, Paris"
  },
  "congesRules": {
    "congesPayesPerYear": 25,
    "rttPerYear": 11,
    "autoApproveAfterDays": null,
    "minNoticeDays": 7,
    "maxConsecutiveDays": 30
  },
  "workingHours": {
    "hoursPerDay": 7.0,
    "daysPerWeek": 5,
    "hoursPerWeek": 35.0
  },
  "notifications": {
    "emailEnabled": true,
    "pushEnabled": true,
    "remindersDays": [1, 3, 7] // Rappels X jours avant échéance
  },
  "features": {
    "timeTrackingEnabled": true,
    "evaluationsEnabled": true,
    "budgetTrackingEnabled": false
  },
  "updatedAt": "2025-01-01T00:00:00Z",
  "updatedBy": "admin-id"
}
```

---

## 🔐 Règles de Sécurité Firestore

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }

    function isAdmin() {
      return isAuthenticated() &&
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'ADMIN';
    }

    function isChefProjet() {
      return isAuthenticated() &&
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'CHEF_PROJET';
    }

    function isConsultant() {
      return isAuthenticated() &&
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'CONSULTANT';
    }

    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }

    // Users collection
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow create: if isAdmin();
      allow update: if isOwner(userId) || isAdmin();
      allow delete: if isAdmin();
    }

    // Consultants collection
    match /consultants/{consultantId} {
      allow read: if isAuthenticated();
      allow create: if isAdmin();
      allow update: if isAdmin() ||
                      (isConsultant() && resource.data.userId == request.auth.uid);
      allow delete: if isAdmin();

      // Sous-collections
      match /skills/{skillId} {
        allow read: if isAuthenticated();
        allow write: if isAdmin() ||
                       (isConsultant() && get(/databases/$(database)/documents/consultants/$(consultantId)).data.userId == request.auth.uid);
      }

      match /certifications/{certId} {
        allow read: if isAuthenticated();
        allow write: if isAdmin() ||
                       (isConsultant() && get(/databases/$(database)/documents/consultants/$(consultantId)).data.userId == request.auth.uid);
      }

      match /documents/{docId} {
        allow read: if isAdmin() ||
                      (isConsultant() && get(/databases/$(database)/documents/consultants/$(consultantId)).data.userId == request.auth.uid);
        allow write: if isAdmin();
      }

      match /evaluations/{evalId} {
        allow read: if isAdmin() ||
                      isChefProjet() ||
                      (isConsultant() && get(/databases/$(database)/documents/consultants/$(consultantId)).data.userId == request.auth.uid);
        allow write: if isAdmin() || isChefProjet();
      }
    }

    // Conges collection
    match /conges/{congeId} {
      allow read: if isAuthenticated();
      allow create: if isConsultant();
      allow update: if isAdmin() ||
                      isChefProjet() ||
                      (isConsultant() && resource.data.consultantId == request.auth.uid && resource.data.status == 'BROUILLON');
      allow delete: if isAdmin() ||
                      (isConsultant() && resource.data.consultantId == request.auth.uid && resource.data.status == 'BROUILLON');
    }

    // Projects collection
    match /projects/{projectId} {
      allow read: if isAuthenticated();
      allow create: if isAdmin() || isChefProjet();
      allow update: if isAdmin() ||
                      (isChefProjet() && resource.data.chefProjetId == request.auth.uid);
      allow delete: if isAdmin();

      match /assignments/{assignmentId} {
        allow read: if isAuthenticated();
        allow write: if isAdmin() ||
                       (isChefProjet() && get(/databases/$(database)/documents/projects/$(projectId)).data.chefProjetId == request.auth.uid);
      }

      match /missions/{missionId} {
        allow read: if isAuthenticated();
        allow write: if isAdmin() || isChefProjet();
      }

      match /risks/{riskId} {
        allow read: if isAuthenticated();
        allow write: if isAdmin() || isChefProjet();
      }
    }

    // Tasks collection
    match /tasks/{taskId} {
      allow read: if isAuthenticated();
      allow create: if isAdmin() || isChefProjet();
      allow update: if isAuthenticated();
      allow delete: if isAdmin() || isChefProjet();

      match /comments/{commentId} {
        allow read: if isAuthenticated();
        allow create: if isAuthenticated();
        allow update: if isAuthenticated() && resource.data.authorId == request.auth.uid;
        allow delete: if isAdmin() || resource.data.authorId == request.auth.uid;
      }
    }

    // Time Tracking collection
    match /timeTracking/{timeEntryId} {
      allow read: if isAuthenticated();
      allow create: if isConsultant();
      allow update: if isAdmin() ||
                      isChefProjet() ||
                      (isConsultant() && resource.data.consultantId == request.auth.uid && !resource.data.isValidated);
      allow delete: if isAdmin() ||
                      (isConsultant() && resource.data.consultantId == request.auth.uid && !resource.data.isValidated);
    }

    // Notifications collection
    match /notifications/{notificationId} {
      allow read: if isAuthenticated() && resource.data.userId == request.auth.uid;
      allow update: if isAuthenticated() && resource.data.userId == request.auth.uid;
      allow create, delete: if isAdmin();
    }

    // Activity Logs collection
    match /activityLogs/{logId} {
      allow read: if isAdmin();
      allow write: if false; // Écrit uniquement par Cloud Functions
    }

    // Settings collection
    match /settings/{settingId} {
      allow read: if isAuthenticated();
      allow write: if isAdmin();
    }
  }
}
```

---

## 📈 Index Composites Recommandés

Pour optimiser les requêtes Firestore:

```javascript
// Consultants
consultants: [status, availability]
consultants: [department, status]

// Conges
conges: [consultantId, status]
conges: [status, startDate]
conges: [consultantId, startDate, DESC]

// Projects
projects: [status, startDate]
projects: [chefProjetId, status]
projects: [type, status]

// Tasks
tasks: [projectId, status]
tasks: [assignedTo, status]
tasks: [assignedTo, dueDate]
tasks: [projectId, priority, status]
tasks: [status, dueDate]

// Time Tracking
timeTracking: [consultantId, date, DESC]
timeTracking: [projectId, date, DESC]
timeTracking: [consultantId, isValidated]

// Notifications
notifications: [userId, isRead, createdAt, DESC]
notifications: [userId, type, createdAt, DESC]
```

---

## 🔄 Stratégie de Backup

1. **Firestore Backup Automatique**
   - Backup quotidien via Cloud Scheduler
   - Rétention 30 jours
   - Export vers Cloud Storage

2. **Données critiques**
   - Double sauvegarde pour `users`, `consultants`, `projects`
   - Export hebdomadaire en JSON

---

## 📊 Stratégie de Scaling

- **Sharding pour grandes collections**: Si >10000 documents
- **Pagination**: Limiter à 50 documents par requête
- **Cache local**: Utiliser cache Firestore pour données fréquentes
- **Indexes**: Créer indexes pour toutes les queries complexes

---

**Version:** 1.0
**Date:** 17 Novembre 2025
**Type:** Firebase Firestore NoSQL
