import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/consultant_model.dart';
import '../../providers/consultant_provider.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/status_chip.dart';
import '../../widgets/common/avatar_widget.dart';
import '../../widgets/common/custom_card.dart';
import '../../core/constants/app_constants.dart';
import '../../utils/extensions.dart';

class ConsultantsListScreen extends ConsumerStatefulWidget {
  const ConsultantsListScreen({super.key});

  @override
  ConsumerState<ConsultantsListScreen> createState() => _ConsultantsListScreenState();
}

class _ConsultantsListScreenState extends ConsumerState<ConsultantsListScreen> {
  String _searchQuery = '';
  ConsultantStatus? _filterStatus;

  @override
  Widget build(BuildContext context) {
    final consultantsAsync = ref.watch(consultantsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filtrer',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un consultant...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),

          // Filter chips
          if (_filterStatus != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
              ),
              child: Row(
                children: [
                  const Text('Filtre: '),
                  const SizedBox(width: 8),
                  StatusChip.consultantStatus(_filterStatus!),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () {
                      setState(() => _filterStatus = null);
                    },
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text('Effacer'),
                  ),
                ],
              ),
            ),

          // Consultants list
          Expanded(
            child: consultantsAsync.when(
              data: (consultants) {
                // Apply filters
                var filteredConsultants = consultants;

                // Search filter
                if (_searchQuery.isNotEmpty) {
                  filteredConsultants = filteredConsultants
                      .where((c) =>
                          c.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          c.email.toLowerCase().contains(_searchQuery.toLowerCase()))
                      .toList();
                }

                // Status filter
                if (_filterStatus != null) {
                  filteredConsultants =
                      filteredConsultants.where((c) => c.status == _filterStatus).toList();
                }

                if (filteredConsultants.isEmpty) {
                  return EmptyState(
                    icon: Icons.people_outline,
                    title: 'Aucun consultant trouvé',
                    message: _searchQuery.isNotEmpty || _filterStatus != null
                        ? 'Essayez de modifier vos filtres'
                        : 'Créez votre premier consultant pour commencer',
                    action: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Navigate to create consultant
                        context.showSnackBar('Création de consultant - À venir');
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Ajouter un consultant'),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(consultantsListProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    itemCount: filteredConsultants.length,
                    itemBuilder: (context, index) {
                      final consultant = filteredConsultants[index];
                      return _ConsultantCard(
                        consultant: consultant,
                        onTap: () {
                          // TODO: Navigate to consultant details
                          context.showSnackBar('Détails consultant - À venir');
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => const LoadingWidget(message: 'Chargement des consultants...'),
              error: (error, stack) => CustomErrorWidget(
                error: error.toString(),
                onRetry: () {
                  ref.invalidate(consultantsListProvider);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to create consultant
          context.showSnackBar('Création de consultant - À venir');
        },
        icon: const Icon(Icons.add),
        label: const Text('Nouveau'),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrer par statut'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FilterOption(
              label: 'Tous',
              selected: _filterStatus == null,
              onTap: () {
                setState(() => _filterStatus = null);
                Navigator.pop(context);
              },
            ),
            _FilterOption(
              label: 'Actifs',
              selected: _filterStatus == ConsultantStatus.actif,
              onTap: () {
                setState(() => _filterStatus = ConsultantStatus.actif);
                Navigator.pop(context);
              },
            ),
            _FilterOption(
              label: 'En congé',
              selected: _filterStatus == ConsultantStatus.enConge,
              onTap: () {
                setState(() => _filterStatus = ConsultantStatus.enConge);
                Navigator.pop(context);
              },
            ),
            _FilterOption(
              label: 'En mission',
              selected: _filterStatus == ConsultantStatus.enMission,
              onTap: () {
                setState(() => _filterStatus = ConsultantStatus.enMission);
                Navigator.pop(context);
              },
            ),
            _FilterOption(
              label: 'Inactifs',
              selected: _filterStatus == ConsultantStatus.inactif,
              onTap: () {
                setState(() => _filterStatus = ConsultantStatus.inactif);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsultantCard extends StatelessWidget {
  final ConsultantModel consultant;
  final VoidCallback onTap;

  const _ConsultantCard({
    required this.consultant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Avatar
          AvatarWidget(
            imageUrl: consultant.photoUrl,
            name: consultant.fullName,
            radius: 28,
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  consultant.fullName,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                if (consultant.position != null)
                  Text(
                    consultant.position!,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    StatusChip.consultantStatus(consultant.status),
                    const SizedBox(width: 8),
                    _AvailabilityIndicator(availability: consultant.availability),
                  ],
                ),
              ],
            ),
          ),

          // Arrow
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

class _AvailabilityIndicator extends StatelessWidget {
  final double availability;

  const _AvailabilityIndicator({required this.availability});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    if (availability >= 50) {
      color = Colors.green;
      label = 'Disponible';
    } else if (availability >= 20) {
      color = Colors.orange;
      label = 'Partiellement dispo';
    } else {
      color = Colors.red;
      label = 'Non disponible';
    }

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '${availability.toStringAsFixed(0)}%',
          style: context.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _FilterOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: selected ? const Icon(Icons.check) : null,
      onTap: onTap,
    );
  }
}
