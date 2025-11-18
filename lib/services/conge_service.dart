import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/conge_model.dart';
import '../core/constants/app_constants.dart';
import '../utils/logger.dart';

class CongeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============================================
  // CRUD Congés
  // ============================================

  /// Get all conges
  Stream<List<CongeModel>> getAllConges() {
    try {
      return _firestore
          .collection(FirebaseCollections.conges)
          .orderBy('requestDate', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => CongeModel.fromFirestore(doc))
              .toList());
    } catch (e) {
      AppLogger.error('Failed to get all conges', e);
      rethrow;
    }
  }

  /// Get conges by consultant
  Stream<List<CongeModel>> getCongesByConsultant(String consultantId) {
    try {
      return _firestore
          .collection(FirebaseCollections.conges)
          .where('consultantId', isEqualTo: consultantId)
          .orderBy('startDate', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => CongeModel.fromFirestore(doc))
              .toList());
    } catch (e) {
      AppLogger.error('Failed to get conges by consultant', e);
      rethrow;
    }
  }

  /// Get conges by status
  Stream<List<CongeModel>> getCongesByStatus(CongeStatus status) {
    try {
      return _firestore
          .collection(FirebaseCollections.conges)
          .where('status', isEqualTo: status.toString().split('.').last)
          .orderBy('requestDate', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => CongeModel.fromFirestore(doc))
              .toList());
    } catch (e) {
      AppLogger.error('Failed to get conges by status', e);
      rethrow;
    }
  }

  /// Get pending conges (waiting for validation)
  Stream<List<CongeModel>> getPendingConges() {
    return getCongesByStatus(CongeStatus.enAttente);
  }

  /// Get conges pending chef validation
  Stream<List<CongeModel>> getCongesPendingChef() {
    return getCongesByStatus(CongeStatus.enAttente);
  }

  /// Get conges pending admin validation
  Stream<List<CongeModel>> getCongesPendingAdmin() {
    return getCongesByStatus(CongeStatus.valideChef);
  }

  /// Get approved conges
  Stream<List<CongeModel>> getApprovedConges() {
    return getCongesByStatus(CongeStatus.approuve);
  }

  /// Get upcoming conges (approved and in the future)
  Stream<List<CongeModel>> getUpcomingConges() {
    try {
      final now = DateTime.now();
      
      return _firestore
          .collection(FirebaseCollections.conges)
          .where('status', isEqualTo: 'APPROUVE')
          .where('startDate', isGreaterThan: Timestamp.fromDate(now))
          .orderBy('startDate')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => CongeModel.fromFirestore(doc))
              .toList());
    } catch (e) {
      AppLogger.error('Failed to get upcoming conges', e);
      rethrow;
    }
  }

  /// Get current conges (approved and ongoing)
  Stream<List<CongeModel>> getCurrentConges() {
    try {
      final now = DateTime.now();
      
      return _firestore
          .collection(FirebaseCollections.conges)
          .where('status', isEqualTo: 'APPROUVE')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => CongeModel.fromFirestore(doc))
              .where((conge) =>
                  conge.startDate.isBefore(now) &&
                  conge.endDate.isAfter(now))
              .toList());
    } catch (e) {
      AppLogger.error('Failed to get current conges', e);
      rethrow;
    }
  }

  /// Get conge by ID
  Future<CongeModel?> getCongeById(String id) async {
    try {
      final doc = await _firestore
          .collection(FirebaseCollections.conges)
          .doc(id)
          .get();

      if (!doc.exists) return null;
      return CongeModel.fromFirestore(doc);
    } catch (e) {
      AppLogger.error('Failed to get conge by ID', e);
      rethrow;
    }
  }

  /// Create conge request
  Future<String> createConge(CongeModel conge) async {
    try {
      AppLogger.info('Creating conge request for: ${conge.consultantId}');
      
      // Validate dates
      if (conge.endDate.isBefore(conge.startDate)) {
        throw Exception('La date de fin doit être après la date de début');
      }

      // Calculate number of days if not provided
      final numberOfDays = conge.numberOfDays > 0
          ? conge.numberOfDays
          : _calculateWorkingDays(conge.startDate, conge.endDate);

      final congeWithDays = conge.copyWith(numberOfDays: numberOfDays);

      final docRef = await _firestore
          .collection(FirebaseCollections.conges)
          .add(congeWithDays.toJson());

      AppLogger.info('Conge request created with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      AppLogger.error('Failed to create conge', e);
      rethrow;
    }
  }

  /// Update conge
  Future<void> updateConge(String id, Map<String, dynamic> data) async {
    try {
      AppLogger.info('Updating conge: $id');
      
      await _firestore
          .collection(FirebaseCollections.conges)
          .doc(id)
          .update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      AppLogger.info('Conge updated successfully');
    } catch (e) {
      AppLogger.error('Failed to update conge', e);
      rethrow;
    }
  }

  /// Submit conge for approval
  Future<void> submitConge(String id) async {
    try {
      await updateConge(id, {
        'status': CongeStatus.enAttente.toString().split('.').last,
      });
      AppLogger.info('Conge submitted for approval');
    } catch (e) {
      AppLogger.error('Failed to submit conge', e);
      rethrow;
    }
  }

  /// Validate by Chef de Projet
  Future<void> validateByChef(
    String id,
    String chefId,
    String? comment,
  ) async {
    try {
      await updateConge(id, {
        'status': CongeStatus.valideChef.toString().split('.').last,
        'validations.chefProjet': {
          'validated': true,
          'validatedBy': chefId,
          'validatedAt': FieldValue.serverTimestamp(),
          'comment': comment,
        },
      });
      AppLogger.info('Conge validated by chef');
    } catch (e) {
      AppLogger.error('Failed to validate conge by chef', e);
      rethrow;
    }
  }

  /// Reject by Chef de Projet
  Future<void> rejectByChef(
    String id,
    String chefId,
    String reason,
  ) async {
    try {
      await updateConge(id, {
        'status': CongeStatus.rejete.toString().split('.').last,
        'validations.chefProjet': {
          'validated': false,
          'validatedBy': chefId,
          'validatedAt': FieldValue.serverTimestamp(),
          'comment': reason,
        },
      });
      AppLogger.info('Conge rejected by chef');
    } catch (e) {
      AppLogger.error('Failed to reject conge by chef', e);
      rethrow;
    }
  }

  /// Approve by Admin (final approval)
  Future<void> approveByAdmin(
    String id,
    String adminId,
    String? comment,
  ) async {
    try {
      await updateConge(id, {
        'status': CongeStatus.approuve.toString().split('.').last,
        'validations.admin': {
          'validated': true,
          'validatedBy': adminId,
          'validatedAt': FieldValue.serverTimestamp(),
          'comment': comment,
        },
      });
      AppLogger.info('Conge approved by admin');
      
      // TODO: Update consultant balance
    } catch (e) {
      AppLogger.error('Failed to approve conge by admin', e);
      rethrow;
    }
  }

  /// Reject by Admin
  Future<void> rejectByAdmin(
    String id,
    String adminId,
    String reason,
  ) async {
    try {
      await updateConge(id, {
        'status': CongeStatus.rejete.toString().split('.').last,
        'validations.admin': {
          'validated': false,
          'validatedBy': adminId,
          'validatedAt': FieldValue.serverTimestamp(),
          'comment': reason,
        },
      });
      AppLogger.info('Conge rejected by admin');
    } catch (e) {
      AppLogger.error('Failed to reject conge by admin', e);
      rethrow;
    }
  }

  /// Cancel conge
  Future<void> cancelConge(String id) async {
    try {
      await updateConge(id, {
        'status': CongeStatus.annule.toString().split('.').last,
      });
      AppLogger.info('Conge cancelled');
    } catch (e) {
      AppLogger.error('Failed to cancel conge', e);
      rethrow;
    }
  }

  /// Delete conge
  Future<void> deleteConge(String id) async {
    try {
      AppLogger.info('Deleting conge: $id');
      
      await _firestore
          .collection(FirebaseCollections.conges)
          .doc(id)
          .delete();

      AppLogger.info('Conge deleted successfully');
    } catch (e) {
      AppLogger.error('Failed to delete conge', e);
      rethrow;
    }
  }

  // ============================================
  // Statistics & Queries
  // ============================================

  /// Get conge count by status
  Future<int> getCongeCountByStatus(CongeStatus status) async {
    try {
      final snapshot = await _firestore
          .collection(FirebaseCollections.conges)
          .where('status', isEqualTo: status.toString().split('.').last)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      AppLogger.error('Failed to get conge count by status', e);
      return 0;
    }
  }

  /// Get pending conge count
  Future<int> getPendingCongeCount() async {
    return getCongeCountByStatus(CongeStatus.enAttente);
  }

  /// Get consultant conge balance
  Future<Map<String, int>> getConsultantCongeBalance(String consultantId) async {
    try {
      // Get all approved conges for current year
      final now = DateTime.now();
      final startOfYear = DateTime(now.year, 1, 1);
      
      final snapshot = await _firestore
          .collection(FirebaseCollections.conges)
          .where('consultantId', isEqualTo: consultantId)
          .where('status', isEqualTo: 'APPROUVE')
          .where('startDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfYear))
          .get();

      final conges = snapshot.docs
          .map((doc) => CongeModel.fromFirestore(doc))
          .toList();

      int congesPayesUsed = 0;
      int rttUsed = 0;
      int formationUsed = 0;

      for (final conge in conges) {
        switch (conge.type) {
          case CongeType.congePaye:
            congesPayesUsed += conge.numberOfDays;
            break;
          case CongeType.rtt:
            rttUsed += conge.numberOfDays;
            break;
          case CongeType.formation:
            formationUsed += conge.numberOfDays;
            break;
          default:
            break;
        }
      }

      return {
        'congesPayesAvailable': AppConstants.defaultCongesPayesPerYear - congesPayesUsed,
        'congesPayesUsed': congesPayesUsed,
        'rttAvailable': AppConstants.defaultRttPerYear - rttUsed,
        'rttUsed': rttUsed,
        'formationAvailable': AppConstants.defaultFormationDaysPerYear - formationUsed,
        'formationUsed': formationUsed,
      };
    } catch (e) {
      AppLogger.error('Failed to get consultant conge balance', e);
      rethrow;
    }
  }

  /// Check if conge dates overlap with existing approved conges
  Future<bool> hasOverlap(
    String consultantId,
    DateTime startDate,
    DateTime endDate,
    {String? excludeCongeId}
  ) async {
    try {
      final snapshot = await _firestore
          .collection(FirebaseCollections.conges)
          .where('consultantId', isEqualTo: consultantId)
          .where('status', isEqualTo: 'APPROUVE')
          .get();

      final existingConges = snapshot.docs
          .map((doc) => CongeModel.fromFirestore(doc))
          .where((conge) => conge.id != excludeCongeId)
          .toList();

      for (final conge in existingConges) {
        if (_datesOverlap(startDate, endDate, conge.startDate, conge.endDate)) {
          return true;
        }
      }

      return false;
    } catch (e) {
      AppLogger.error('Failed to check conge overlap', e);
      rethrow;
    }
  }

  // ============================================
  // Helper Methods
  // ============================================

  /// Calculate working days between two dates
  int _calculateWorkingDays(DateTime startDate, DateTime endDate) {
    int workingDays = 0;
    DateTime current = startDate;

    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      // Skip weekends (Saturday = 6, Sunday = 7)
      if (current.weekday != DateTime.saturday &&
          current.weekday != DateTime.sunday) {
        workingDays++;
      }
      current = current.add(const Duration(days: 1));
    }

    return workingDays;
  }

  /// Check if two date ranges overlap
  bool _datesOverlap(
    DateTime start1,
    DateTime end1,
    DateTime start2,
    DateTime end2,
  ) {
    return start1.isBefore(end2) && end1.isAfter(start2);
  }
}
