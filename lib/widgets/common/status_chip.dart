import 'package:flutter/material.dart';
import '../../models/consultant_model.dart';
import '../../models/conge_model.dart';
import '../../models/project_model.dart';
import '../../models/task_model.dart';

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const StatusChip({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  // Factory constructors for different status types

  factory StatusChip.consultantStatus(ConsultantStatus status) {
    switch (status) {
      case ConsultantStatus.actif:
        return const StatusChip(
          label: 'Actif',
          color: Colors.green,
          icon: Icons.check_circle,
        );
      case ConsultantStatus.enConge:
        return const StatusChip(
          label: 'En congé',
          color: Colors.orange,
          icon: Icons.beach_access,
        );
      case ConsultantStatus.inactif:
        return const StatusChip(
          label: 'Inactif',
          color: Colors.grey,
          icon: Icons.cancel,
        );
      case ConsultantStatus.enMission:
        return const StatusChip(
          label: 'En mission',
          color: Colors.blue,
          icon: Icons.work,
        );
    }
  }

  factory StatusChip.congeStatus(CongeStatus status) {
    switch (status) {
      case CongeStatus.brouillon:
        return const StatusChip(
          label: 'Brouillon',
          color: Colors.grey,
          icon: Icons.edit,
        );
      case CongeStatus.enAttente:
        return const StatusChip(
          label: 'En attente',
          color: Colors.orange,
          icon: Icons.access_time,
        );
      case CongeStatus.valideChef:
        return const StatusChip(
          label: 'Validé chef',
          color: Colors.blue,
          icon: Icons.thumb_up,
        );
      case CongeStatus.approuve:
        return const StatusChip(
          label: 'Approuvé',
          color: Colors.green,
          icon: Icons.check_circle,
        );
      case CongeStatus.rejete:
        return const StatusChip(
          label: 'Rejeté',
          color: Colors.red,
          icon: Icons.cancel,
        );
      case CongeStatus.annule:
        return const StatusChip(
          label: 'Annulé',
          color: Colors.grey,
          icon: Icons.block,
        );
    }
  }

  factory StatusChip.projectStatus(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.planifie:
        return const StatusChip(
          label: 'Planifié',
          color: Colors.blue,
          icon: Icons.schedule,
        );
      case ProjectStatus.enCours:
        return const StatusChip(
          label: 'En cours',
          color: Colors.green,
          icon: Icons.play_arrow,
        );
      case ProjectStatus.enPause:
        return const StatusChip(
          label: 'En pause',
          color: Colors.orange,
          icon: Icons.pause,
        );
      case ProjectStatus.termine:
        return const StatusChip(
          label: 'Terminé',
          color: Colors.purple,
          icon: Icons.check_circle,
        );
      case ProjectStatus.annule:
        return const StatusChip(
          label: 'Annulé',
          color: Colors.grey,
          icon: Icons.cancel,
        );
      case ProjectStatus.enRetard:
        return const StatusChip(
          label: 'En retard',
          color: Colors.red,
          icon: Icons.warning,
        );
    }
  }

  factory StatusChip.taskStatus(TaskStatus status) {
    switch (status) {
      case TaskStatus.aFaire:
        return const StatusChip(
          label: 'À faire',
          color: Colors.grey,
          icon: Icons.radio_button_unchecked,
        );
      case TaskStatus.enCours:
        return const StatusChip(
          label: 'En cours',
          color: Colors.blue,
          icon: Icons.play_arrow,
        );
      case TaskStatus.enRevue:
        return const StatusChip(
          label: 'En revue',
          color: Colors.orange,
          icon: Icons.rate_review,
        );
      case TaskStatus.terminee:
        return const StatusChip(
          label: 'Terminée',
          color: Colors.green,
          icon: Icons.check_circle,
        );
      case TaskStatus.bloquee:
        return const StatusChip(
          label: 'Bloquée',
          color: Colors.red,
          icon: Icons.block,
        );
    }
  }

  factory StatusChip.priority(Priority priority) {
    switch (priority) {
      case Priority.basse:
        return const StatusChip(
          label: 'Basse',
          color: Colors.grey,
          icon: Icons.arrow_downward,
        );
      case Priority.moyenne:
        return const StatusChip(
          label: 'Moyenne',
          color: Colors.blue,
          icon: Icons.remove,
        );
      case Priority.haute:
        return const StatusChip(
          label: 'Haute',
          color: Colors.orange,
          icon: Icons.arrow_upward,
        );
      case Priority.critique:
        return const StatusChip(
          label: 'Critique',
          color: Colors.red,
          icon: Icons.priority_high,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: icon != null
          ? Icon(
              icon,
              size: 18,
              color: color,
            )
          : null,
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color, width: 1),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}
