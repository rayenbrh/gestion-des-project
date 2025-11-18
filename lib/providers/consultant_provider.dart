import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/consultant_model.dart';
import '../models/skill_model.dart';
import '../models/certification_model.dart';
import '../models/document_model.dart';
import '../models/evaluation_model.dart';
import '../services/consultant_service.dart';
import '../utils/logger.dart';

// Consultant service provider
final consultantServiceProvider = Provider<ConsultantService>((ref) {
  return ConsultantService();
});

// All consultants stream provider
final consultantsListProvider = StreamProvider<List<ConsultantModel>>((ref) {
  final service = ref.watch(consultantServiceProvider);
  return service.getAllConsultants();
});

// Active consultants stream provider
final activeConsultantsProvider = StreamProvider<List<ConsultantModel>>((ref) {
  final service = ref.watch(consultantServiceProvider);
  return service.getConsultantsByStatus(ConsultantStatus.actif);
});

// Available consultants stream provider
final availableConsultantsProvider = StreamProvider<List<ConsultantModel>>((ref) {
  final service = ref.watch(consultantServiceProvider);
  return service.getAvailableConsultants();
});

// Consultant by ID provider
final consultantByIdProvider = FutureProvider.family<ConsultantModel?, String>((ref, id) async {
  final service = ref.watch(consultantServiceProvider);
  return service.getConsultantById(id);
});

// Consultant by user ID provider
final consultantByUserIdProvider = FutureProvider.family<ConsultantModel?, String>((ref, userId) async {
  final service = ref.watch(consultantServiceProvider);
  return service.getConsultantByUserId(userId);
});

// Consultant skills provider
final consultantSkillsProvider = StreamProvider.family<List<SkillModel>, String>((ref, consultantId) {
  final service = ref.watch(consultantServiceProvider);
  return service.getConsultantSkills(consultantId);
});

// Consultant certifications provider
final consultantCertificationsProvider = StreamProvider.family<List<CertificationModel>, String>((ref, consultantId) {
  final service = ref.watch(consultantServiceProvider);
  return service.getConsultantCertifications(consultantId);
});

// Consultant documents provider
final consultantDocumentsProvider = StreamProvider.family<List<DocumentModel>, String>((ref, consultantId) {
  final service = ref.watch(consultantServiceProvider);
  return service.getConsultantDocuments(consultantId);
});

// Consultant evaluations provider
final consultantEvaluationsProvider = StreamProvider.family<List<EvaluationModel>, String>((ref, consultantId) {
  final service = ref.watch(consultantServiceProvider);
  return service.getConsultantEvaluations(consultantId);
});

// Consultant count provider
final consultantCountProvider = FutureProvider<int>((ref) async {
  final service = ref.watch(consultantServiceProvider);
  return service.getConsultantCount();
});

// Active consultant count provider
final activeConsultantCountProvider = FutureProvider<int>((ref) async {
  final service = ref.watch(consultantServiceProvider);
  return service.getActiveConsultantCount();
});

// Search consultants provider
final searchConsultantsProvider = FutureProvider.family<List<ConsultantModel>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final service = ref.watch(consultantServiceProvider);
  return service.searchConsultants(query);
});

// ============================================
// Consultant Controller
// ============================================

class ConsultantController extends StateNotifier<AsyncValue<void>> {
  final ConsultantService _service;

  ConsultantController(this._service) : super(const AsyncValue.data(null));

  // Create consultant
  Future<String?> createConsultant(ConsultantModel consultant) async {
    state = const AsyncValue.loading();
    try {
      final id = await _service.createConsultant(consultant);
      state = const AsyncValue.data(null);
      AppLogger.info('Consultant created successfully: $id');
      return id;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      AppLogger.error('Failed to create consultant', e);
      return null;
    }
  }

  // Update consultant
  Future<bool> updateConsultant(String id, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await _service.updateConsultant(id, data);
      state = const AsyncValue.data(null);
      AppLogger.info('Consultant updated successfully');
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      AppLogger.error('Failed to update consultant', e);
      return false;
    }
  }

  // Delete consultant
  Future<bool> deleteConsultant(String id) async {
    state = const AsyncValue.loading();
    try {
      await _service.deleteConsultant(id);
      state = const AsyncValue.data(null);
      AppLogger.info('Consultant deleted successfully');
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      AppLogger.error('Failed to delete consultant', e);
      return false;
    }
  }

  // Add skill
  Future<String?> addSkill(String consultantId, SkillModel skill) async {
    state = const AsyncValue.loading();
    try {
      final id = await _service.addSkill(consultantId, skill);
      state = const AsyncValue.data(null);
      return id;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  // Update skill
  Future<bool> updateSkill(
    String consultantId,
    String skillId,
    Map<String, dynamic> data,
  ) async {
    state = const AsyncValue.loading();
    try {
      await _service.updateSkill(consultantId, skillId, data);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  // Delete skill
  Future<bool> deleteSkill(String consultantId, String skillId) async {
    state = const AsyncValue.loading();
    try {
      await _service.deleteSkill(consultantId, skillId);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  // Add certification
  Future<String?> addCertification(
    String consultantId,
    CertificationModel certification,
  ) async {
    state = const AsyncValue.loading();
    try {
      final id = await _service.addCertification(consultantId, certification);
      state = const AsyncValue.data(null);
      return id;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  // Delete certification
  Future<bool> deleteCertification(String consultantId, String certificationId) async {
    state = const AsyncValue.loading();
    try {
      await _service.deleteCertification(consultantId, certificationId);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  // Add document
  Future<String?> addDocument(
    String consultantId,
    DocumentModel document,
  ) async {
    state = const AsyncValue.loading();
    try {
      final id = await _service.addDocument(consultantId, document);
      state = const AsyncValue.data(null);
      return id;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  // Delete document
  Future<bool> deleteDocument(String consultantId, String documentId) async {
    state = const AsyncValue.loading();
    try {
      await _service.deleteDocument(consultantId, documentId);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  // Add evaluation
  Future<String?> addEvaluation(
    String consultantId,
    EvaluationModel evaluation,
  ) async {
    state = const AsyncValue.loading();
    try {
      final id = await _service.addEvaluation(consultantId, evaluation);
      state = const AsyncValue.data(null);
      return id;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  // Update workload
  Future<bool> updateWorkload(String consultantId, double workload) async {
    state = const AsyncValue.loading();
    try {
      await _service.updateConsultantWorkload(consultantId, workload);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}

// Consultant controller provider
final consultantControllerProvider =
    StateNotifierProvider<ConsultantController, AsyncValue<void>>((ref) {
  final service = ref.watch(consultantServiceProvider);
  return ConsultantController(service);
});
