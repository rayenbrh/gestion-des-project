import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/consultants/consultants_list_screen.dart';
import '../../screens/conges/conges_list_screen.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../constants/app_constants.dart';

// Router configuration
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: RouteNames.login,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthenticated = authState.value != null;
      final isLoggingIn = state.matchedLocation == RouteNames.login;

      // If not authenticated and not on login page, redirect to login
      if (!isAuthenticated && !isLoggingIn) {
        return RouteNames.login;
      }

      // If authenticated and on login page, redirect to dashboard
      if (isAuthenticated && isLoggingIn) {
        return RouteNames.dashboard;
      }

      // No redirect needed
      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        name: 'forgot-password',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Forgot Password Screen - Coming Soon'),
          ),
        ),
      ),

      // Dashboard route
      GoRoute(
        path: RouteNames.dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),

      // Consultants routes
      GoRoute(
        path: RouteNames.consultants,
        name: 'consultants',
        builder: (context, state) => const ConsultantsListScreen(),
      ),

      // Projects routes
      GoRoute(
        path: RouteNames.projects,
        name: 'projects',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Projects Screen - Coming Soon'),
          ),
        ),
      ),

      // Tasks routes
      GoRoute(
        path: RouteNames.tasks,
        name: 'tasks',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Tasks Screen - Coming Soon'),
          ),
        ),
      ),

      // Conges routes
      GoRoute(
        path: RouteNames.conges,
        name: 'conges',
        builder: (context, state) => const CongesListScreen(),
      ),

      // Time Tracking route
      GoRoute(
        path: RouteNames.timeTracking,
        name: 'time-tracking',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Time Tracking Screen - Coming Soon'),
          ),
        ),
      ),

      // Settings route
      GoRoute(
        path: RouteNames.settings,
        name: 'settings',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Settings Screen - Coming Soon'),
          ),
        ),
      ),

      // Notifications route
      GoRoute(
        path: RouteNames.notifications,
        name: 'notifications',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Notifications Screen - Coming Soon'),
          ),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              '404 - Page introuvable',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.matchedLocation,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go(RouteNames.dashboard),
              icon: const Icon(Icons.home),
              label: const Text('Retour à l\'accueil'),
            ),
          ],
        ),
      ),
    ),
  );
});
