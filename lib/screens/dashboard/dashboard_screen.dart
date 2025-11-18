import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../models/user_model.dart';
import '../../utils/extensions.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDataProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          // Theme toggle
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
            tooltip: isDarkMode ? 'Mode clair' : 'Mode sombre',
          ),
          // Settings
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go(RouteNames.settings),
            tooltip: 'Paramètres',
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildDrawer(context, ref, currentUser.value),
      body: currentUser.when(
        data: (user) => _buildDashboardContent(context, ref, user),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Erreur: $error'),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, WidgetRef ref, UserModel? user) {
    return Drawer(
      child: Column(
        children: [
          // User header
          UserAccountsDrawerHeader(
            accountName: Text(user?.email.split('@').first.capitalize() ?? 'Utilisateur'),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: context.colorScheme.primary,
              child: Text(
                user?.email[0].toUpperCase() ?? 'U',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
            ),
          ),

          // Menu items based on role
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.dashboard,
                  title: 'Tableau de bord',
                  route: RouteNames.dashboard,
                ),
                const Divider(),

                // Admin menu items
                if (user?.role == UserRole.admin || user?.role == UserRole.chefProjet) ...[
                  _buildDrawerItem(
                    context,
                    icon: Icons.people,
                    title: 'Consultants',
                    route: RouteNames.consultants,
                  ),
                ],

                _buildDrawerItem(
                  context,
                  icon: Icons.work,
                  title: 'Projets',
                  route: RouteNames.projects,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.task,
                  title: 'Tâches',
                  route: RouteNames.tasks,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.access_time,
                  title: 'Suivi des temps',
                  route: RouteNames.timeTracking,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.calendar_today,
                  title: 'Congés',
                  route: RouteNames.conges,
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.notifications,
                  title: 'Notifications',
                  route: RouteNames.notifications,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings,
                  title: 'Paramètres',
                  route: RouteNames.settings,
                ),
              ],
            ),
          ),

          // Logout button
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Déconnexion',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              await ref.read(authControllerProvider.notifier).signOut();
              if (context.mounted) {
                context.go(RouteNames.login);
              }
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    final isSelected = GoRouterState.of(context).matchedLocation == route;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? context.colorScheme.primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? context.colorScheme.primary : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      selected: isSelected,
      selectedTileColor: context.colorScheme.primary.withOpacity(0.1),
      onTap: () {
        Navigator.pop(context); // Close drawer
        context.go(route);
      },
    );
  }

  Widget _buildDashboardContent(BuildContext context, WidgetRef ref, UserModel? user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome message
          Text(
            'Bienvenue, ${user?.email.split('@').first.capitalize() ?? 'Utilisateur'} !',
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Rôle: ${_getRoleLabel(user?.role)}',
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 32),

          // Stats cards
          _buildStatsCards(context, user),
          const SizedBox(height: 32),

          // Quick actions
          Text(
            'Actions rapides',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildQuickActions(context, user),
        ],
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context, UserModel? user) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = context.isDesktop ? 4 : (context.isTablet ? 2 : 1);
        return GridView.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          children: [
            _buildStatCard(
              context,
              icon: Icons.work,
              title: 'Projets actifs',
              value: '0',
              color: Colors.blue,
            ),
            _buildStatCard(
              context,
              icon: Icons.task,
              title: 'Tâches en cours',
              value: '0',
              color: Colors.orange,
            ),
            _buildStatCard(
              context,
              icon: Icons.people,
              title: 'Consultants',
              value: '0',
              color: Colors.green,
            ),
            _buildStatCard(
              context,
              icon: Icons.calendar_today,
              title: 'Congés à venir',
              value: '0',
              color: Colors.purple,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: color),
            const Spacer(),
            Text(
              value,
              style: context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, UserModel? user) {
    final actions = _getQuickActions(user?.role);

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: actions
          .map((action) => ElevatedButton.icon(
                onPressed: () => context.go(action['route'] as String),
                icon: Icon(action['icon'] as IconData),
                label: Text(action['label'] as String),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ))
          .toList(),
    );
  }

  List<Map<String, dynamic>> _getQuickActions(UserRole? role) {
    final baseActions = [
      {'icon': Icons.task_alt, 'label': 'Mes tâches', 'route': RouteNames.tasks},
      {'icon': Icons.access_time, 'label': 'Saisir temps', 'route': RouteNames.timeTracking},
      {'icon': Icons.beach_access, 'label': 'Demander congé', 'route': RouteNames.conges},
    ];

    if (role == UserRole.admin || role == UserRole.chefProjet) {
      return [
        {'icon': Icons.add_circle, 'label': 'Nouveau projet', 'route': RouteNames.projects},
        ...baseActions,
      ];
    }

    return baseActions;
  }

  String _getRoleLabel(UserRole? role) {
    switch (role) {
      case UserRole.admin:
        return 'Administrateur';
      case UserRole.chefProjet:
        return 'Chef de Projet';
      case UserRole.consultant:
        return 'Consultant';
      default:
        return 'Utilisateur';
    }
  }
}
