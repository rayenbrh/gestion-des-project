import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/conge_model.dart';
import '../../providers/conge_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/status_chip.dart';
import '../../widgets/common/custom_card.dart';
import '../../core/constants/app_constants.dart';
import '../../utils/extensions.dart';

class CongesListScreen extends ConsumerStatefulWidget {
  const CongesListScreen({super.key});

  @override
  ConsumerState<CongesListScreen> createState() => _CongesListScreenState();
}

class _CongesListScreenState extends ConsumerState<CongesListScreen> {
  CongeStatus? _filterStatus;

  @override
  Widget build(BuildContext context) {
    final congesAsync = ref.watch(congesListProvider);
    final currentUser = ref.watch(currentUserDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Congés'),
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
          // Filter chips
          if (_filterStatus != null)
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Row(
                children: [
                  const Text('Filtre: '),
                  const SizedBox(width: 8),
                  StatusChip.congeStatus(_filterStatus!),
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

          // Stats cards
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: _StatsRow(),
          ),

          // Conges list
          Expanded(
            child: congesAsync.when(
              data: (conges) {
                // Apply filter
                var filteredConges = conges;
                if (_filterStatus != null) {
                  filteredConges = filteredConges.where((c) => c.status == _filterStatus).toList();
                }

                if (filteredConges.isEmpty) {
                  return EmptyState(
                    icon: Icons.beach_access,
                    title: 'Aucun congé trouvé',
                    message: _filterStatus != null
                        ? 'Aucun congé avec ce statut'
                        : 'Créez votre première demande de congé',
                    action: ElevatedButton.icon(
                      onPressed: () {
                        context.showSnackBar('Demande de congé - À venir');
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Nouvelle demande'),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(congesListProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    itemCount: filteredConges.length,
                    itemBuilder: (context, index) {
                      final conge = filteredConges[index];
                      return _CongeCard(
                        conge: conge,
                        onTap: () {
                          context.showSnackBar('Détails congé - À venir');
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => const LoadingWidget(message: 'Chargement des congés...'),
              error: (error, stack) => CustomErrorWidget(
                error: error.toString(),
                onRetry: () {
                  ref.invalidate(congesListProvider);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.showSnackBar('Nouvelle demande de congé - À venir');
        },
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle demande'),
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
              label: 'En attente',
              selected: _filterStatus == CongeStatus.enAttente,
              onTap: () {
                setState(() => _filterStatus = CongeStatus.enAttente);
                Navigator.pop(context);
              },
            ),
            _FilterOption(
              label: 'Approuvés',
              selected: _filterStatus == CongeStatus.approuve,
              onTap: () {
                setState(() => _filterStatus = CongeStatus.approuve);
                Navigator.pop(context);
              },
            ),
            _FilterOption(
              label: 'Rejetés',
              selected: _filterStatus == CongeStatus.rejete,
              onTap: () {
                setState(() => _filterStatus = CongeStatus.rejete);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingCountAsync = ref.watch(pendingCongeCountProvider);
    final upcomingCongesAsync = ref.watch(upcomingCongesProvider);

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.pending_actions,
            title: 'En attente',
            value: pendingCountAsync.when(
              data: (count) => count.toString(),
              loading: () => '...',
              error: (_, __) => '0',
            ),
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.event_available,
            title: 'À venir',
            value: upcomingCongesAsync.when(
              data: (conges) => conges.length.toString(),
              loading: () => '...',
              error: (_, __) => '0',
            ),
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: context.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CongeCard extends StatelessWidget {
  final CongeModel conge;
  final VoidCallback onTap;

  const _CongeCard({
    required this.conge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final typeLabel = _getTypeLabel(conge.type);

    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getTypeIcon(conge.type),
                          size: 16,
                          color: context.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          typeLabel,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${conge.numberOfDays} jour${conge.numberOfDays > 1 ? 's' : ''}',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              StatusChip.congeStatus(conge.status),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: context.colorScheme.onSurface.withOpacity(0.6),
              ),
              const SizedBox(width: 4),
              Text(
                '${conge.startDate.toDateString()} - ${conge.endDate.toDateString()}',
                style: context.textTheme.bodySmall,
              ),
            ],
          ),
          if (conge.reason != null && conge.reason!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              conge.reason!,
              style: context.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  String _getTypeLabel(CongeType type) {
    switch (type) {
      case CongeType.congePaye:
        return 'Congé payé';
      case CongeType.rtt:
        return 'RTT';
      case CongeType.maladie:
        return 'Maladie';
      case CongeType.sansSolde:
        return 'Sans solde';
      case CongeType.formation:
        return 'Formation';
      case CongeType.autre:
        return 'Autre';
    }
  }

  IconData _getTypeIcon(CongeType type) {
    switch (type) {
      case CongeType.congePaye:
        return Icons.beach_access;
      case CongeType.rtt:
        return Icons.event_available;
      case CongeType.maladie:
        return Icons.local_hospital;
      case CongeType.sansSolde:
        return Icons.money_off;
      case CongeType.formation:
        return Icons.school;
      case CongeType.autre:
        return Icons.more_horiz;
    }
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
