import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/conge_model.dart';
import '../services/conge_service.dart';
import '../utils/logger.dart';

// Conge service provider
final congeServiceProvider = Provider<CongeService>((ref) {
  return CongeService();
});

// All conges stream provider
final congesListProvider = StreamProvider<List<CongeModel>>((ref) {
  final service = ref.watch(congeServiceProvider);
  return service.getAllConges();
});

// Conges by consultant provider
final congesByConsultantProvider = StreamProvider.family<List<CongeModel>, String>((ref, consultantId) {
  final service = ref.watch(congeServiceProvider);
  return service.getCongesByConsultant(consultantId);
});

// Conges by status provider
final congesByStatusProvider = StreamProvider.family<List<CongeModel>, CongeStatus>((ref, status) {
  final service = ref.watch(congeServiceProvider);
  return service.getCongesByStatus(status);
});

// Pending conges provider (en attente)
final pendingCongesProvider = StreamProvider<List<CongeModel>>((ref) {
  final service = ref.watch(congeServiceProvider);
  return service.getPendingConges();
});

// Conges pending chef validation
final congesPendingChefProvider = StreamProvider<List<CongeModel>>((ref) {
  final service = ref.watch(congeServiceProvider);
  return service.getCongesPendingChef();
});

// Conges pending admin validation
final congesPendingAdminProvider = StreamProvider<List<CongeModel>>((ref) {
  final service = ref.watch(congeServiceProvider);
  return service.getCongesPendingAdmin();
});

// Approved conges provider
final approvedCongesProvider = StreamProvider<List<CongeModel>>((ref) {
  final service = ref.watch(congeServiceProvider);
  return service.getApprovedConges();
});

// Upcoming conges provider
final upcomingCongesProvider = StreamProvider<List<CongeModel>>((ref) {
  final service = ref.watch(congeServiceProvider);
  return service.getUpcomingConges();
});

// Current conges provider (ongoing)
final currentCongesProvider = StreamProvider<List<CongeModel>>((ref) {
  final service = ref.watch(congeServiceProvider);
  return service.getCurrentConges();
});

// Conge by ID provider
final congeByIdProvider = FutureProvider.family<CongeModel?, String>((ref, id) async {
  final service = ref.watch(congeServiceProvider);
  return service.getCongeById(id);
});

// Pending conge count provider
final pendingCongeCountProvider = FutureProvider<int>((ref) async {
  final service = ref.watch(congeServiceProvider);
  return service.getPendingCongeCount();
});

// Consultant conge balance provider
final consultantCongeBalanceProvider = FutureProvider.family<Map<String, int>, String>((ref, consultantId) async {
  final service = ref.watch(congeServiceProvider);
  return service.getConsultantCongeBalance(consultantId);
});

// ============================================
// Conge Controller
// ============================================

class CongeController extends StateNotifier<AsyncValue<void>> {
  final CongeService _service;

  CongeController(this._service) : super(const AsyncValue.data(null));

  // Create conge request
  Future<String?> createConge(CongeModel conge) async {
    state = const AsyncValue.loading();
    try {
      // Check for overlaps
      final hasOverlap = await _service.hasOverlap(
        conge.consultantId,
        conge.startDate,
        conge.endDate,
      );

      if (hasOverlap) {
        throw Exception('Ces dates chevauchent un congé existant');
      }

      final id = await _service.createConge(conge);
      state = const AsyncValue.data(null);
      AppLogger.info('Conge request created successfully: $id');
      return id;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      AppLogger.error('Failed to create conge', e);
      return null;
    }
  }

  // Update conge
  Future<bool> updateConge(String id, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await _service.updateConge(id, data);
      state = const AsyncValue.data(null);
      AppLogger.info('Conge updated successfully');
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      AppLogger.error('Failed to update conge', e);
      return false;
    }
  }

  // Submit conge for approval
  Future<bool> submitConge(String id) async {
    state = const AsyncValue.loading();
    try {
      await _service.submitConge(id);
      state = const AsyncValue.data(null);
      AppLogger.info('Conge submitted for approval');
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      AppLogger.error('Failed to submit conge', e);
      return false;
    }
  }

  // Validate by Chef de Projet
  Future<bool> validateByChef(
    String id,
    String chefId, {
    String? comment,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _service.validateByChef(id, chefId, comment);
      state = const AsyncValue.data(null);
      AppLogger.info('Conge validated by chef');
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      AppLogger.error('Failed to validate conge by chef', e);
      return false;
    }
  }

  // Reject by Chef de Projet
  Future<bool> rejectByChef(
    String id,
    String chefId,
    String reason,
  ) async {
    state = const AsyncValue.loading();
    try {
      await _service.rejectByChef(id, chefId, reason);
      state = const AsyncValue.data(null);
      AppLogger.info('Conge rejected by chef');
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      AppLogger.error('Failed to reject conge by chef', e);
      return false;
    }
  }

  // Approve by Admin (final approval)
  Future<bool> approveByAdmin(
    String id,
    String adminId, {
    String? comment,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _service.approveByAdmin(id, adminId, comment);
      state = const AsyncValue.data(null);
      AppLogger.info('Conge approved by admin');
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      AppLogger.error('Failed to approve conge by admin', e);
      return false;
    }
  }

  // Reject by Admin
  Future<bool> rejectByAdmin(
    String id,
    String adminId,
    String reason,
  ) async {
    state = const AsyncValue.loading();
    try {
      await _service.rejectByAdmin(id, adminId, reason);
      state = const AsyncValue.data(null);
      AppLogger.info('Conge rejected by admin');
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      AppLogger.error('Failed to reject conge by admin', e);
      return false;
    }
  }

  // Cancel conge
  Future<bool> cancelConge(String id) async {
    state = const AsyncValue.loading();
    try {
      await _service.cancelConge(id);
      state = const AsyncValue.data(null);
      AppLogger.info('Conge cancelled');
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      AppLogger.error('Failed to cancel conge', e);
      return false;
    }
  }

  // Delete conge
  Future<bool> deleteConge(String id) async {
    state = const AsyncValue.loading();
    try {
      await _service.deleteConge(id);
      state = const AsyncValue.data(null);
      AppLogger.info('Conge deleted successfully');
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      AppLogger.error('Failed to delete conge', e);
      return false;
    }
  }
}

// Conge controller provider
final congeControllerProvider =
    StateNotifierProvider<CongeController, AsyncValue<void>>((ref) {
  final service = ref.watch(congeServiceProvider);
  return CongeController(service);
});
