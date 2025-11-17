import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import '../core/constants/app_constants.dart';
import '../utils/logger.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload file
  Future<String> uploadFile({
    required String path,
    required dynamic file, // File for mobile, Uint8List for web
    String? fileName,
    Function(double)? onProgress,
  }) async {
    try {
      AppLogger.info('Uploading file to: $path');

      final ref = _storage.ref().child(path);
      UploadTask uploadTask;

      if (kIsWeb) {
        // Web upload
        uploadTask = ref.putData(file as Uint8List);
      } else {
        // Mobile upload
        uploadTask = ref.putFile(file as File);
      }

      // Listen to upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress?.call(progress);
      });

      // Wait for upload to complete
      final snapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      AppLogger.info('File uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      AppLogger.error('File upload failed', e);
      rethrow;
    }
  }

  // Upload consultant avatar
  Future<String> uploadConsultantAvatar({
    required String consultantId,
    required dynamic file,
    Function(double)? onProgress,
  }) async {
    final path = StoragePaths.consultantAvatar(consultantId);
    return uploadFile(
      path: '$path/avatar.jpg',
      file: file,
      onProgress: onProgress,
    );
  }

  // Upload consultant document
  Future<String> uploadConsultantDocument({
    required String consultantId,
    required String documentId,
    required String fileName,
    required dynamic file,
    Function(double)? onProgress,
  }) async {
    final path = StoragePaths.consultantDocument(consultantId, documentId);
    return uploadFile(
      path: '$path/$fileName',
      file: file,
      onProgress: onProgress,
    );
  }

  // Upload project document
  Future<String> uploadProjectDocument({
    required String projectId,
    required String documentId,
    required String fileName,
    required dynamic file,
    Function(double)? onProgress,
  }) async {
    final path = StoragePaths.projectDocument(projectId, documentId);
    return uploadFile(
      path: '$path/$fileName',
      file: file,
      onProgress: onProgress,
    );
  }

  // Upload task attachment
  Future<String> uploadTaskAttachment({
    required String taskId,
    required String attachmentId,
    required String fileName,
    required dynamic file,
    Function(double)? onProgress,
  }) async {
    final path = StoragePaths.taskAttachment(taskId, attachmentId);
    return uploadFile(
      path: '$path/$fileName',
      file: file,
      onProgress: onProgress,
    );
  }

  // Delete file
  Future<void> deleteFile(String path) async {
    try {
      AppLogger.info('Deleting file: $path');
      final ref = _storage.ref().child(path);
      await ref.delete();
      AppLogger.info('File deleted successfully');
    } catch (e) {
      AppLogger.error('File deletion failed', e);
      rethrow;
    }
  }

  // Delete file by URL
  Future<void> deleteFileByUrl(String url) async {
    try {
      AppLogger.info('Deleting file by URL: $url');
      final ref = _storage.refFromURL(url);
      await ref.delete();
      AppLogger.info('File deleted successfully');
    } catch (e) {
      AppLogger.error('File deletion failed', e);
      rethrow;
    }
  }

  // Get file metadata
  Future<FullMetadata> getFileMetadata(String path) async {
    try {
      final ref = _storage.ref().child(path);
      return await ref.getMetadata();
    } catch (e) {
      AppLogger.error('Failed to get file metadata', e);
      rethrow;
    }
  }

  // Get download URL
  Future<String> getDownloadUrl(String path) async {
    try {
      final ref = _storage.ref().child(path);
      return await ref.getDownloadURL();
    } catch (e) {
      AppLogger.error('Failed to get download URL', e);
      rethrow;
    }
  }

  // List files in directory
  Future<List<Reference>> listFiles(String path) async {
    try {
      final ref = _storage.ref().child(path);
      final result = await ref.listAll();
      return result.items;
    } catch (e) {
      AppLogger.error('Failed to list files', e);
      rethrow;
    }
  }

  // Validate file size
  bool validateFileSize(int fileSize) {
    return fileSize <= AppConstants.maxFileSize;
  }

  // Validate file extension
  bool validateFileExtension(String fileName, List<String> allowedExtensions) {
    final extension = fileName.split('.').last.toLowerCase();
    return allowedExtensions.contains(extension);
  }

  // Validate image file
  bool validateImageFile(String fileName, int fileSize) {
    return validateFileSize(fileSize) &&
        validateFileExtension(fileName, AppConstants.allowedImageExtensions);
  }

  // Validate document file
  bool validateDocumentFile(String fileName, int fileSize) {
    return validateFileSize(fileSize) &&
        validateFileExtension(fileName, AppConstants.allowedDocExtensions);
  }
}
