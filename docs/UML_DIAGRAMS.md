# 🎨 Diagrammes UML - Application de Gestion de Consulting

## 1. Diagramme de Cas d'Utilisation (Use Case Diagram)

```plantuml
@startuml
left to right direction
skinparam packageStyle rectangle

actor Administrateur as admin
actor "Chef de Projet" as chef
actor Consultant as cons

rectangle "Système de Gestion de Consulting" {

  package "Module Authentification" {
    usecase (Se connecter) as UC1
    usecase (Se déconnecter) as UC2
    usecase (Récupérer mot de passe) as UC3
  }

  package "Module RH" {
    usecase (Gérer les consultants) as UC4
    usecase (Consulter profil consultant) as UC5
    usecase (Mettre à jour compétences) as UC6
    usecase (Demander un congé) as UC7
    usecase (Valider un congé) as UC8
    usecase (Gérer les évaluations) as UC9
    usecase (Consulter disponibilité) as UC10
    usecase (Gérer les documents RH) as UC11
  }

  package "Module Gestion Projets" {
    usecase (Créer un projet) as UC12
    usecase (Assigner des consultants) as UC13
    usecase (Gérer les tâches) as UC14
    usecase (Saisir temps de travail) as UC15
    usecase (Suivre avancement projet) as UC16
    usecase (Gérer les risques) as UC17
    usecase (Valider les livrables) as UC18
  }

  package "Module Dashboard" {
    usecase (Consulter KPI globaux) as UC19
    usecase (Consulter KPI projets) as UC20
    usecase (Consulter statistiques personnelles) as UC21
    usecase (Exporter des rapports) as UC22
  }

  package "Module Notifications" {
    usecase (Recevoir notifications) as UC23
    usecase (Configurer alertes) as UC24
  }
}

' Relations Administrateur
admin --> UC1
admin --> UC2
admin --> UC4
admin --> UC5
admin --> UC8
admin --> UC9
admin --> UC11
admin --> UC12
admin --> UC13
admin --> UC16
admin --> UC17
admin --> UC18
admin --> UC19
admin --> UC22
admin --> UC24

' Relations Chef de Projet
chef --> UC1
chef --> UC2
chef --> UC5
chef --> UC7
chef --> UC8
chef --> UC10
chef --> UC12
chef --> UC13
chef --> UC14
chef --> UC15
chef --> UC16
chef --> UC17
chef --> UC18
chef --> UC20
chef --> UC22
chef --> UC23

' Relations Consultant
cons --> UC1
cons --> UC2
cons --> UC5
cons --> UC6
cons --> UC7
cons --> UC10
cons --> UC14
cons --> UC15
cons --> UC21
cons --> UC23

' Includes et Extends
UC7 ..> UC23 : <<include>>
UC8 ..> UC23 : <<include>>
UC12 ..> UC13 : <<include>>
UC14 ..> UC15 : <<extend>>

@enduml
```

---

## 2. Diagramme de Classes (Class Diagram)

```plantuml
@startuml
skinparam classAttributeIconSize 0

class User {
  - id: String
  - email: String
  - password: String (hash)
  - role: UserRole
  - createdAt: DateTime
  - lastLogin: DateTime
  - isActive: Boolean
  + login()
  + logout()
  + resetPassword()
  + updateProfile()
}

enum UserRole {
  ADMIN
  CHEF_PROJET
  CONSULTANT
}

class Consultant {
  - id: String
  - userId: String
  - firstName: String
  - lastName: String
  - phone: String
  - photoUrl: String
  - position: String
  - department: String
  - dateJoined: DateTime
  - status: ConsultantStatus
  - yearsExperience: int
  - hourlyRate: double
  - availability: double (%)
  - skills: List<Skill>
  - certifications: List<Certification>
  - documents: List<Document>
  + getFullName(): String
  + getCurrentProjects(): List<Project>
  + getAvailability(): double
  + updateSkills()
  + calculateWorkload(): double
}

enum ConsultantStatus {
  ACTIF
  EN_CONGE
  INACTIF
  EN_MISSION
}

class Skill {
  - id: String
  - name: String
  - category: String
  - level: SkillLevel
  - yearsOfExperience: int
}

enum SkillLevel {
  DEBUTANT
  INTERMEDIAIRE
  AVANCE
  EXPERT
}

class Certification {
  - id: String
  - name: String
  - issuingOrganization: String
  - issueDate: DateTime
  - expirationDate: DateTime?
  - credentialUrl: String?
}

class Document {
  - id: String
  - title: String
  - type: DocumentType
  - fileUrl: String
  - uploadedAt: DateTime
  - uploadedBy: String
  - size: int
}

enum DocumentType {
  CV
  CONTRACT
  CERTIFICATE
  ADMINISTRATIVE
  OTHER
}

class Conge {
  - id: String
  - consultantId: String
  - type: CongeType
  - startDate: DateTime
  - endDate: DateTime
  - numberOfDays: int
  - reason: String?
  - status: CongeStatus
  - requestDate: DateTime
  - validatedByChef: Boolean
  - validatedByAdmin: Boolean
  - chefComment: String?
  - adminComment: String?
  + submit()
  + approve()
  - reject()
  + cancel()
}

enum CongeType {
  CONGE_PAYE
  RTT
  MALADIE
  SANS_SOLDE
  FORMATION
  AUTRE
}

enum CongeStatus {
  BROUILLON
  EN_ATTENTE
  VALIDE_CHEF
  APPROUVE
  REJETE
  ANNULE
}

class Evaluation {
  - id: String
  - consultantId: String
  - evaluatorId: String
  - evaluationDate: DateTime
  - period: String
  - objectives: List<Objective>
  - achievements: String
  - strengths: String
  - improvements: String
  - globalRating: double
  - comments: String
  - developmentPlan: String
  + calculateAverageRating(): double
  + exportToPDF()
}

class Objective {
  - id: String
  - title: String
  - description: String
  - targetDate: DateTime
  - progress: double (%)
  - status: ObjectiveStatus
}

enum ObjectiveStatus {
  EN_COURS
  ATTEINT
  NON_ATTEINT
  ABANDONNE
}

class Project {
  - id: String
  - code: String (unique)
  - name: String
  - description: String
  - clientName: String
  - clientContact: String
  - type: ProjectType
  - status: ProjectStatus
  - startDate: DateTime
  - endDate: DateTime
  - budget: double?
  - chefProjetId: String
  - consultants: List<ProjectAssignment>
  - milestones: List<Milestone>
  - risks: List<Risk>
  - progress: double (%)
  + calculateProgress(): double
  + isDelayed(): Boolean
  + getTotalHours(): double
  + getTeamMembers(): List<Consultant>
}

enum ProjectType {
  INTERNE
  EXTERNE
  R_AND_D
}

enum ProjectStatus {
  PLANIFIE
  EN_COURS
  EN_PAUSE
  TERMINE
  ANNULE
  EN_RETARD
}

class ProjectAssignment {
  - consultantId: String
  - projectId: String
  - role: String
  - allocatedLoad: double (%)
  - startDate: DateTime
  - endDate: DateTime?
}

class Milestone {
  - id: String
  - projectId: String
  - name: String
  - description: String
  - targetDate: DateTime
  - completedDate: DateTime?
  - status: MilestoneStatus
}

enum MilestoneStatus {
  A_FAIRE
  EN_COURS
  TERMINE
  EN_RETARD
}

class Mission {
  - id: String
  - projectId: String
  - name: String
  - description: String
  - objective: String
  - consultantIds: List<String>
  - startDate: DateTime
  - endDate: DateTime
  - status: TaskStatus
  - deliverables: List<Deliverable>
}

class Task {
  - id: String
  - projectId: String
  - missionId: String?
  - title: String
  - description: String
  - assignedTo: String
  - priority: Priority
  - status: TaskStatus
  - createdAt: DateTime
  - dueDate: DateTime
  - startDate: DateTime?
  - completedDate: DateTime?
  - estimatedHours: double
  - actualHours: double
  - subtasks: List<Subtask>
  - tags: List<String>
  - comments: List<Comment>
  + isOverdue(): Boolean
  + calculateProgress(): double
}

enum Priority {
  BASSE
  MOYENNE
  HAUTE
  CRITIQUE
}

enum TaskStatus {
  A_FAIRE
  EN_COURS
  EN_REVUE
  TERMINEE
  BLOQUEE
}

class Subtask {
  - id: String
  - title: String
  - isCompleted: Boolean
}

class Comment {
  - id: String
  - authorId: String
  - content: String
  - createdAt: DateTime
  - attachments: List<String>
}

class Deliverable {
  - id: String
  - name: String
  - description: String
  - dueDate: DateTime
  - deliveredDate: DateTime?
  - fileUrl: String?
  - isValidated: Boolean
}

class TimeTracking {
  - id: String
  - consultantId: String
  - projectId: String
  - missionId: String?
  - taskId: String?
  - date: DateTime
  - hours: double
  - description: String
  - activityType: ActivityType
  - isValidated: Boolean
  - validatedBy: String?
  + getWeeklyTotal(): double
  + getMonthlyTotal(): double
}

enum ActivityType {
  DEVELOPPEMENT
  REUNION
  FORMATION
  DOCUMENTATION
  SUPPORT
  AUTRE
}

class Risk {
  - id: String
  - projectId: String
  - description: String
  - probability: RiskLevel
  - impact: RiskLevel
  - mitigationPlan: String
  - responsibleId: String
  - status: RiskStatus
  - identifiedDate: DateTime
}

enum RiskLevel {
  FAIBLE
  MOYEN
  ELEVE
  CRITIQUE
}

enum RiskStatus {
  IDENTIFIE
  EN_COURS
  RESOLU
  ACCEPTE
}

class Notification {
  - id: String
  - userId: String
  - title: String
  - message: String
  - type: NotificationType
  - isRead: Boolean
  - createdAt: DateTime
  - relatedEntityId: String?
  - actionUrl: String?
}

enum NotificationType {
  CONGE_REQUEST
  CONGE_APPROVED
  CONGE_REJECTED
  TASK_ASSIGNED
  PROJECT_UPDATE
  DEADLINE_REMINDER
  SYSTEM_ALERT
  EVALUATION_DUE
}

' Relations
User "1" -- "0..1" Consultant : has >
Consultant "1" -- "*" Skill : possesses >
Consultant "1" -- "*" Certification : holds >
Consultant "1" -- "*" Document : uploads >
Consultant "1" -- "*" Conge : requests >
Consultant "1" -- "*" Evaluation : receives >
Consultant "1" -- "*" TimeTracking : logs >

Project "1" -- "*" ProjectAssignment : has >
ProjectAssignment "*" -- "1" Consultant : assigns >
Project "1" -- "*" Milestone : contains >
Project "1" -- "*" Mission : includes >
Project "1" -- "*" Task : manages >
Project "1" -- "*" Risk : identifies >
Project "1" -- "1" Consultant : led by (chef) >

Mission "1" -- "*" Task : contains >
Mission "1" -- "*" Deliverable : produces >

Task "1" -- "*" Subtask : breaks into >
Task "1" -- "*" Comment : has >
Task "1" -- "0..1" TimeTracking : tracked by >

User "1" -- "*" Notification : receives >

Evaluation "1" -- "*" Objective : evaluates >

@enduml
```

---

## 3. Diagrammes de Séquence

### 3.1 Séquence: Authentification Utilisateur

```plantuml
@startuml
actor Utilisateur
participant "UI Login" as UI
participant AuthProvider
participant AuthService
participant Firebase
database Firestore

Utilisateur -> UI: Saisit email/password
UI -> AuthProvider: login(email, password)
activate AuthProvider

AuthProvider -> AuthService: authenticate(email, password)
activate AuthService

AuthService -> Firebase: signInWithEmailAndPassword()
activate Firebase

alt Succès authentification
    Firebase --> AuthService: UserCredential
    AuthService -> Firestore: getUserData(uid)
    activate Firestore
    Firestore --> AuthService: UserData + Role
    deactivate Firestore

    AuthService --> AuthProvider: User + Token
    deactivate AuthService

    AuthProvider -> AuthProvider: saveToken()
    AuthProvider -> AuthProvider: setCurrentUser()

    AuthProvider --> UI: Success
    deactivate AuthProvider
    UI --> Utilisateur: Redirection vers Dashboard

else Échec authentification
    Firebase --> AuthService: Error
    deactivate Firebase
    AuthService --> AuthProvider: AuthError
    AuthProvider --> UI: Error Message
    UI --> Utilisateur: Affiche erreur
end

@enduml
```

### 3.2 Séquence: Demande de Congé

```plantuml
@startuml
actor Consultant
participant "UI Congés" as UI
participant CongeProvider
participant CongeService
participant NotificationService
database Firestore

Consultant -> UI: Clique "Nouvelle demande"
UI --> Consultant: Affiche formulaire

Consultant -> UI: Remplit formulaire\n(type, dates, motif)
UI -> UI: Valide formulaire

Consultant -> UI: Soumet demande
UI -> CongeProvider: createCongeRequest(congeData)
activate CongeProvider

CongeProvider -> CongeService: createConge(congeData)
activate CongeService

CongeService -> CongeService: calculateNumberOfDays()
CongeService -> CongeService: checkAvailableBalance()

alt Solde suffisant
    CongeService -> Firestore: saveConge()
    activate Firestore
    Firestore --> CongeService: congeId
    deactivate Firestore

    CongeService -> NotificationService: notifyChefProjet()
    activate NotificationService
    NotificationService -> Firestore: createNotification(chefId)
    NotificationService --> CongeService: OK
    deactivate NotificationService

    CongeService --> CongeProvider: Success(conge)
    deactivate CongeService

    CongeProvider --> UI: Success
    deactivate CongeProvider

    UI --> Consultant: "Demande envoyée avec succès"

else Solde insuffisant
    CongeService --> CongeProvider: Error("Solde insuffisant")
    CongeProvider --> UI: Error
    UI --> Consultant: "Erreur: Solde de congés insuffisant"
end

@enduml
```

### 3.3 Séquence: Validation de Congé (Workflow)

```plantuml
@startuml
actor "Chef de Projet" as Chef
actor Administrateur as Admin
participant "UI Congés" as UI
participant CongeProvider
participant CongeService
participant NotificationService
database Firestore

== Validation par Chef de Projet ==

Chef -> UI: Consulte demandes en attente
UI -> CongeProvider: getPendingConges()
CongeProvider -> CongeService: fetchPendingConges(chefId)
CongeService -> Firestore: query conges (status=EN_ATTENTE)
Firestore --> CongeService: List<Conge>
CongeService --> CongeProvider: conges
CongeProvider --> UI: conges
UI --> Chef: Affiche liste

Chef -> UI: Clique "Valider" sur une demande
UI -> CongeProvider: validateCongeByChef(congeId, comment)
activate CongeProvider

CongeProvider -> CongeService: updateCongeStatus(congeId, VALIDE_CHEF)
activate CongeService
CongeService -> Firestore: update(congeId, {status, validatedByChef})
Firestore --> CongeService: OK

CongeService -> NotificationService: notifyAdmin(congeId)
activate NotificationService
NotificationService -> Firestore: createNotification(adminId)
NotificationService -> NotificationService: sendPushNotification()
deactivate NotificationService

CongeService -> NotificationService: notifyConsultant(congeId, "Validé par chef")
CongeService --> CongeProvider: Success
deactivate CongeService
CongeProvider --> UI: Success
deactivate CongeProvider

UI --> Chef: "Demande validée, en attente admin"

== Validation finale par Administrateur ==

Admin -> UI: Consulte demandes validées chef
UI -> CongeProvider: getCongesPendingAdmin()
CongeProvider -> CongeService: fetchCongesValidatedByChef()
CongeService -> Firestore: query (status=VALIDE_CHEF)
Firestore --> CongeService: List<Conge>
CongeService --> CongeProvider: conges
CongeProvider --> UI: conges
UI --> Admin: Affiche liste

Admin -> UI: Clique "Approuver définitivement"
UI -> CongeProvider: approveCongeByAdmin(congeId)
CongeProvider -> CongeService: finalApproval(congeId)
CongeService -> Firestore: update(congeId, {status: APPROUVE})
Firestore --> CongeService: OK

CongeService -> CongeService: updateConsultantBalance()
CongeService -> Firestore: updateConsultant(soldeConges)

CongeService -> NotificationService: notifyConsultant(congeId, "Approuvé")
CongeService -> NotificationService: notifyChef(congeId, "Approuvé par admin")

CongeService --> CongeProvider: Success
CongeProvider --> UI: Success
UI --> Admin: "Congé approuvé définitivement"

@enduml
```

### 3.4 Séquence: Création de Projet et Assignation

```plantuml
@startuml
actor "Chef de Projet" as Chef
participant "UI Projet" as UI
participant ProjectProvider
participant ProjectService
participant ConsultantService
database Firestore

Chef -> UI: Clique "Nouveau Projet"
UI --> Chef: Affiche formulaire

Chef -> UI: Remplit informations projet\n(nom, client, dates, etc.)
Chef -> UI: Clique "Ajouter consultants"

UI -> ConsultantService: getAvailableConsultants(startDate, endDate)
activate ConsultantService
ConsultantService -> Firestore: query consultants disponibles
Firestore --> ConsultantService: List<Consultant>
ConsultantService --> UI: consultants
deactivate ConsultantService

UI --> Chef: Affiche liste consultants disponibles

Chef -> UI: Sélectionne consultants\net définit charges (%)
Chef -> UI: Soumet formulaire

UI -> ProjectProvider: createProject(projectData, assignments)
activate ProjectProvider

ProjectProvider -> ProjectService: createProject(projectData)
activate ProjectService

ProjectService -> Firestore: saveProject()
activate Firestore
Firestore --> ProjectService: projectId
deactivate Firestore

loop Pour chaque consultant assigné
    ProjectService -> ProjectService: createAssignment(consultantId, projectId)
    ProjectService -> Firestore: saveAssignment()

    ProjectService -> ConsultantService: updateConsultantWorkload(consultantId)
    activate ConsultantService
    ConsultantService -> Firestore: update consultant.availability
    deactivate ConsultantService

    ProjectService -> NotificationService: notifyConsultant(assignmentInfo)
end

ProjectService --> ProjectProvider: Success(project)
deactivate ProjectService

ProjectProvider --> UI: Success
deactivate ProjectProvider

UI --> Chef: "Projet créé avec succès"

@enduml
```

### 3.5 Séquence: Saisie de Temps de Travail

```plantuml
@startuml
actor Consultant
participant "UI Time Tracking" as UI
participant TimeTrackingProvider
participant TimeTrackingService
participant ProjectService
participant TaskService
database Firestore

Consultant -> UI: Accède à Time Tracking
UI -> TimeTrackingProvider: getConsultantProjects()
activate TimeTrackingProvider

TimeTrackingProvider -> ProjectService: getProjectsByConsultant(consultantId)
activate ProjectService
ProjectService -> Firestore: query projects
Firestore --> ProjectService: projects
ProjectService --> TimeTrackingProvider: projects
deactivate ProjectService

TimeTrackingProvider --> UI: projects
deactivate TimeTrackingProvider
UI --> Consultant: Affiche projets actifs

Consultant -> UI: Sélectionne projet
UI -> TaskService: getTasksByProject(projectId)
activate TaskService
TaskService -> Firestore: query tasks
Firestore --> TaskService: tasks
TaskService --> UI: tasks
deactivate TaskService

UI --> Consultant: Affiche tâches

Consultant -> UI: Sélectionne tâche (optionnel)
Consultant -> UI: Saisit date, heures, description

Consultant -> UI: Clique "Enregistrer"
UI -> TimeTrackingProvider: logTime(timeData)
activate TimeTrackingProvider

TimeTrackingProvider -> TimeTrackingService: createTimeEntry(timeData)
activate TimeTrackingService

TimeTrackingService -> Firestore: saveTimeEntry()
activate Firestore
Firestore --> TimeTrackingService: timeEntryId
deactivate Firestore

alt Lié à une tâche
    TimeTrackingService -> TaskService: updateTaskActualHours(taskId, hours)
    activate TaskService
    TaskService -> Firestore: update task.actualHours
    deactivate TaskService
end

TimeTrackingService -> ProjectService: updateProjectTotalHours(projectId)
activate ProjectService
ProjectService -> Firestore: update project stats
deactivate ProjectService

TimeTrackingService --> TimeTrackingProvider: Success
deactivate TimeTrackingService

TimeTrackingProvider --> UI: Success
deactivate TimeTrackingProvider

UI --> Consultant: "Temps enregistré avec succès"

@enduml
```

---

## 4. Diagramme d'États (State Diagram)

### 4.1 États d'un Congé

```plantuml
@startuml
[*] --> Brouillon : Création

Brouillon --> EnAttente : Soumission
Brouillon --> [*] : Suppression

EnAttente --> ValideChef : Validation Chef
EnAttente --> Rejete : Rejet Chef
EnAttente --> Brouillon : Modification

ValideChef --> Approuve : Approbation Admin
ValideChef --> Rejete : Rejet Admin

Approuve --> [*] : Archivage
Rejete --> [*] : Archivage

Approuve --> Annule : Annulation exceptionnelle
Annule --> [*] : Archivage

note right of EnAttente
  Notification envoyée
  au Chef de Projet
end note

note right of ValideChef
  Notification envoyée
  à l'Administrateur
end note

note right of Approuve
  Solde de congés
  mis à jour
end note

@enduml
```

### 4.2 États d'un Projet

```plantuml
@startuml
[*] --> Planifie : Création

Planifie --> EnCours : Démarrage
Planifie --> Annule : Annulation

EnCours --> EnPause : Mise en pause
EnCours --> Termine : Finalisation
EnCours --> EnRetard : Deadline dépassée

EnPause --> EnCours : Reprise
EnPause --> Annule : Annulation

EnRetard --> EnCours : Mise à jour deadline
EnRetard --> Termine : Finalisation tardive

Termine --> [*] : Archivage
Annule --> [*] : Archivage

note right of EnRetard
  Alerte automatique
  si deadline dépassée
end note

note right of Termine
  Rapport final généré
  Ressources libérées
end note

@enduml
```

### 4.3 États d'une Tâche

```plantuml
@startuml
[*] --> AFaire : Création

AFaire --> EnCours : Démarrage
AFaire --> Bloquee : Blocage

EnCours --> EnRevue : Soumission revue
EnCours --> Bloquee : Blocage
EnCours --> AFaire : Mise en attente

EnRevue --> Terminee : Validation
EnRevue --> EnCours : Modifications demandées

Bloquee --> AFaire : Déblocage
Bloquee --> EnCours : Déblocage et reprise

Terminee --> [*] : Archivage

note right of Bloquee
  Nécessite intervention
  externe ou résolution
  de dépendance
end note

@enduml
```

---

## 5. Diagramme de Composants

```plantuml
@startuml
package "Frontend Flutter" {
  [UI Layer] as UI
  [Providers (Riverpod)] as Providers
  [Routing (GoRouter)] as Router

  package "Screens" {
    [Auth Screens]
    [Dashboard Screens]
    [HR Screens]
    [Project Screens]
  }

  package "Widgets" {
    [Common Widgets]
    [Charts]
    [Forms]
  }
}

package "Business Logic" {
  [Services Layer] as Services
  [Models] as Models
  [Repositories] as Repos
}

package "Backend Firebase" {
  database "Firestore" as FS
  [Firebase Auth] as FAuth
  [Firebase Storage] as FStorage
  [Cloud Functions] as Functions
  [FCM] as FCM
}

UI --> Providers
Providers --> Services
Services --> Models
Services --> Repos
Repos --> FS
Repos --> FAuth
Repos --> FStorage
Services --> Functions

Router --> UI
[Auth Screens] --> UI
[Dashboard Screens] --> UI
[HR Screens] --> UI
[Project Screens] --> UI

[Common Widgets] --> UI
[Charts] --> UI
[Forms] --> UI

FCM --> Providers : Push Notifications

@enduml
```

---

## 6. Diagramme de Déploiement

```plantuml
@startuml
node "Client Web" {
  [Flutter Web App]
}

node "Mobile iOS" {
  [Flutter iOS App]
}

node "Mobile Android" {
  [Flutter Android App]
}

cloud "Firebase" {
  database "Firestore" as DB
  [Firebase Auth]
  [Firebase Storage]
  [Cloud Functions]
  node "Firebase Hosting" {
    [Static Web Files]
  }
  [FCM Server]
}

cloud "Apple Services" {
  [App Store]
  [APNs]
}

cloud "Google Services" {
  [Play Store]
  [Google Sign-In]
}

[Flutter Web App] --> [Firebase Hosting] : HTTPS
[Flutter Web App] --> DB : API
[Flutter Web App] --> [Firebase Auth] : Auth
[Flutter Web App] --> [Firebase Storage] : Upload/Download

[Flutter iOS App] --> DB : API
[Flutter iOS App] --> [Firebase Auth] : Auth
[Flutter iOS App] --> [APNs] : Notifications
[Flutter iOS App] --> [App Store] : Download

[Flutter Android App] --> DB : API
[Flutter Android App] --> [Firebase Auth] : Auth
[Flutter Android App] --> [FCM Server] : Notifications
[Flutter Android App] --> [Play Store] : Download

[Cloud Functions] --> DB : CRUD
[Cloud Functions] --> [Firebase Storage] : Process Files
[FCM Server] --> [APNs] : iOS Push

@enduml
```

---

**Note:** Ces diagrammes UML peuvent être rendus avec PlantUML. Ils fournissent une vue complète de l'architecture, des flux de données et des interactions du système.

**Version:** 1.0
**Date:** 17 Novembre 2025
