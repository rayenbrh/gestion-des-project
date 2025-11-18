import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/consultant_model.dart';
import '../models/skill_model.dart';
import '../models/certification_model.dart';
import '../models/document_model.dart';
import '../models/evaluation_model.dart';
import '../core/constants/app_constants.dart';
import '../utils/logger.dart';

class ConsultantService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============================================
  // CRUD Consultants
  // ============================================

  /// Get all consultants
  Stream<List<ConsultantModel>> getAllConsultants() {
    try {
      return _firestore
          .collection(FirebaseCollections.consultants)
          .orderBy('lastName')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ConsultantModel.fromFirestore(doc))
              .toList());
    } catch (e) {
      AppLogger.error('Failed to get all consultants', e);
      rethrow;
    }
  }

  /// Get consultants by status
  Stream<List<ConsultantModel>> getConsultantsByStatus(ConsultantStatus status) {
    try {
      return _firestore
          .collection(FirebaseCollections.consultants)
          .where('status', isEqualTo: status.toString().split('.').last)
          .orderBy('lastName')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ConsultantModel.fromFirestore(doc))
              .toList());
    } catch (e) {
      AppLogger.error('Failed to get consultants by status', e);
      rethrow;
    }
  }

  /// Get available consultants (availability > threshold)
  Stream<List<ConsultantModel>> getAvailableConsultants({double minAvailability = 20.0}) {
    try {
      return _firestore
          .collection(FirebaseCollections.consultants)
          .where('availability', isGreaterThanOrEqualTo: minAvailability)
          .where('status', isEqualTo: 'ACTIF')
          .orderBy('availability', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ConsultantModel.fromFirestore(doc))
              .toList());
    } catch (e) {
      AppLogger.error('Failed to get available consultants', e);
      rethrow;
    }
  }

  /// Get consultant by ID
  Future<ConsultantModel?> getConsultantById(String id) async {
    try {
      final doc = await _firestore
          .collection(FirebaseCollections.consultants)
          .doc(id)
          .get();

      if (!doc.exists) return null;
      return ConsultantModel.fromFirestore(doc);
    } catch (e) {
      AppLogger.error('Failed to get consultant by ID', e);
      rethrow;
    }
  }

  /// Get consultant by user ID
  Future<ConsultantModel?> getConsultantByUserId(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseCollections.consultants)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;
      return ConsultantModel.fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      AppLogger.error('Failed to get consultant by user ID', e);
      rethrow;
    }
  }

  /// Create consultant
  Future<String> createConsultant(ConsultantModel consultant) async {
    try {
      AppLogger.info('Creating consultant: ${consultant.fullName}');
      
      final docRef = await _firestore
          .collection(FirebaseCollections.consultants)
          .add(consultant.toJson());

      AppLogger.info('Consultant created with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      AppLogger.error('Failed to create consultant', e);
      rethrow;
    }
  }

  /// Update consultant
  Future<void> updateConsultant(String id, Map<String, dynamic> data) async {
    try {
      AppLogger.info('Updating consultant: $id');
      
      await _firestore
          .collection(FirebaseCollections.consultants)
          .doc(id)
          .update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      AppLogger.info('Consultant updated successfully');
    } catch (e) {
      AppLogger.error('Failed to update consultant', e);
      rethrow;
    }
  }

  /// Delete consultant
  Future<void> deleteConsultant(String id) async {
    try {
      AppLogger.info('Deleting consultant: $id');
      
      await _firestore
          .collection(FirebaseCollections.consultants)
          .doc(id)
          .delete();

      AppLogger.info('Consultant deleted successfully');
    } catch (e) {
      AppLogger.error('Failed to delete consultant', e);
      rethrow;
    }
  }

  // ============================================
  // Skills Management
  // ============================================

  /// Get consultant skills
  Stream<List<SkillModel>> getConsultantSkills(String consultantId) {
    try {
      return _firestore
          .collection(FirebaseCollections.consultants)
          .doc(consultantId)
          .collection(FirebaseCollections.skills)
          .orderBy('name')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => SkillModel.fromFirestore(doc))
              .toList());
    } catch (e) {
      AppLogger.error('Failed to get consultant skills', e);
      rethrow;
    }
  }

  /// Add skill to consultant
  Future<String> addSkill(String consultantId, SkillModel skill) async {
    try {
      AppLogger.info('Adding skill: ${skill.name} to consultant: $consultantId');
      
      final docRef = await _firestore
          .collection(FirebaseCollections.consultants)
          .doc(consultantId)
          .collection(FirebaseCollections.skills)
          .add(skill.toJson());

      AppLogger.info('Skill added with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      AppLogger.error('Failed to add skill', e);
      rethrow;
    }
  }

  /// Update skill
  Future<void> updateSkill(
    String consultantId,
    String skillId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore
          .collection(FirebaseCollections.consultants)
          .doc(consultantId)
          .collection(FirebaseCollections.skills)
          .doc(skillId)
          .update(data);

      AppLogger.info('Skill updated successfully');
    } catch (e) {
      AppLogger.error('Failed to update skill', e);
      rethrow;
    }
  }

  /// Delete skill
  Future<void> deleteSkill(String consultantId, String skillId) async {
    try {
      await _firestore
          .collection(FirebaseCollections.consultants)
          .doc(consultantId)
          .collection(FirebaseCollections.skills)
          .doc(skillId)
          .delete();

      AppLogger.info('Skill deleted successfully');
    } catch (e) {
      AppLogger.error('Failed to delete skill', e);
      rethrow;
    }
  }

  // ============================================
  // Certifications Management
  // ============================================

  /// Get consultant certifications
  Stream<List<CertificationModel>> getConsultantCertifications(String consultantId) {
    try {
      return _firestore
          .collection(FirebaseCollections.consultants)
          .doc(consultantId)
          .collection(FirebaseCollections.certifications)
          .orderBy('issueDate', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => CertificationModel.fromFirestore(doc))
              .toList());
    } catch (e) {
      AppLogger.error('Failed to get consultant certifications', e);
      rethrow;
    }
  }

  /// Add certification
  Future<String> addCertification(
    String consultantId,
    CertificationModel certification,
  ) async {
    try {
      final docRef = await _firestore
          .collection(FirebaseCollections.consultants)
          .doc(consultantId)
          .collection(FirebaseCollections.certifications)
          .add(certification.toJson());

      AppLogger.info('Certification added with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      AppLogger.error('Failed to add certification', e);
      rethrow;
    }
  }

  /// Delete certification
  Future<void> deleteCertification(String consultantId, String certificationId) async {
    try {
      await _firestore
          .collection(FirebaseCollections.consultants)
          .doc(consultantId)
          .collection(FirebaseCollections.certifications)
          .doc(certificationId)
          .delete();

      AppLogger.info('Certification deleted successfully');
    } catch (e) {
      AppLogger.error('Failed to delete certification', e);
      rethrow;
    }
  }

  // ============================================
  // Documents Management
  // ============================================

  /// Get consultant documents
  Stream<List<DocumentModel>> getConsultantDocuments(String consultantId) {
    try {
      return _firestore
          .collection(FirebaseCollections.consultants)
          .doc(consultantId)
          .collection(FirebaseCollections.documents)
          .orderBy('uploadedAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => DocumentModel.fromFirestore(doc))
              .toList());
    } catch (e) {
      AppLogger.error('Failed to get consultant documents', e);
      rethrow;
    }
  }

  /// Add document
  Future<String> addDocument(
    String consultantId,
    DocumentModel document,
  ) async {
    try {
      final docRef = await _firestore
          .collection(FirebaseCollections.consultants)
          .doc(consultantId)
          .collection(FirebaseCollections.documents)
          .add(document.toJson());

      AppLogger.info('Document added with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      AppLogger.error('Failed to add document', e);
      rethrow;
    }
  }

  /// Delete document
  Future<void> deleteDocument(String consultantId, String documentId) async {
    try {
      await _firestore
          .collection(FirebaseCollections.consultants)
          .doc(consultantId)
          .collection(FirebaseCollections.documents)
          .doc(documentId)
          .delete();

      AppLogger.info('Document deleted successfully');
    } catch (e) {
      AppLogger.error('Failed to delete document', e);
      rethrow;
    }
  }

  // ============================================
  // Evaluations
  // ============================================

  /// Get consultant evaluations
  Stream<List<EvaluationModel>> getConsultantEvaluations(String consultantId) {
    try {
      return _firestore
          .collection(FirebaseCollections.consultants)
          .doc(consultantId)
          .collection(FirebaseCollections.evaluations)
          .orderBy('evaluationDate', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => EvaluationModel.fromFirestore(doc))
              .toList());
    } catch (e) {
      AppLogger.error('Failed to get consultant evaluations', e);
      rethrow;
    }
  }

  /// Add evaluation
  Future<String> addEvaluation(
    String consultantId,
    EvaluationModel evaluation,
  ) async {
    try {
      final docRef = await _firestore
          .collection(FirebaseCollections.consultants)
          .doc(consultantId)
          .collection(FirebaseCollections.evaluations)
          .add(evaluation.toJson());

      AppLogger.info('Evaluation added with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      AppLogger.error('Failed to add evaluation', e);
      rethrow;
    }
  }

  // ============================================
  // Statistics & Queries
  // ============================================

  /// Get consultant count
  Future<int> getConsultantCount() async {
    try {
      final snapshot = await _firestore
          .collection(FirebaseCollections.consultants)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      AppLogger.error('Failed to get consultant count', e);
      return 0;
    }
  }

  /// Get active consultant count
  Future<int> getActiveConsultantCount() async {
    try {
      final snapshot = await _firestore
          .collection(FirebaseCollections.consultants)
          .where('status', isEqualTo: 'ACTIF')
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      AppLogger.error('Failed to get active consultant count', e);
      return 0;
    }
  }

  /// Search consultants by name
  Future<List<ConsultantModel>> searchConsultants(String query) async {
    try {
      final queryLower = query.toLowerCase();
      
      final snapshot = await _firestore
          .collection(FirebaseCollections.consultants)
          .get();

      return snapshot.docs
          .map((doc) => ConsultantModel.fromFirestore(doc))
          .where((consultant) =>
              consultant.firstName.toLowerCase().contains(queryLower) ||
              consultant.lastName.toLowerCase().contains(queryLower) ||
              consultant.fullName.toLowerCase().contains(queryLower))
          .toList();
    } catch (e) {
      AppLogger.error('Failed to search consultants', e);
      rethrow;
    }
  }

  /// Update consultant workload
  Future<void> updateConsultantWorkload(
    String consultantId,
    double currentWorkload,
  ) async {
    try {
      final availability = 100.0 - currentWorkload;
      
      await updateConsultant(consultantId, {
        'currentWorkload': currentWorkload,
        'availability': availability,
      });

      AppLogger.info('Consultant workload updated: $currentWorkload%');
    } catch (e) {
      AppLogger.error('Failed to update consultant workload', e);
      rethrow;
    }
  }
}
