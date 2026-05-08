import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String usersCollection = 'users';

  // Create - Thêm user mới
  Future<String> addUser(User user) async {
    try {
      final docRef = await _firestore
          .collection(usersCollection)
          .add(user.toMap());
      debugPrint('User added with ID: ${docRef.id}');
      return docRef.id;
    } on FirebaseException catch (e) {
      debugPrint('Firebase Error adding user: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Error adding user: $e');
      rethrow;
    }
  }

  // Read - Stream (Real-time)
  Stream<List<User>> getUsersStream() {
    try {
      return _firestore
          .collection(usersCollection)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) => User.fromFirestore(doc)).toList();
          })
          .handleError((error) {
            debugPrint('Error getting users stream: $error');
            throw error;
          });
    } catch (e) {
      debugPrint('Error setting up users stream: $e');
      rethrow;
    }
  }

  // Read - Single document
  Future<User?> getUserById(String id) async {
    try {
      final doc = await _firestore.collection(usersCollection).doc(id).get();
      if (doc.exists) {
        debugPrint('User found: ${doc.id}');
        return User.fromFirestore(doc);
      }
      debugPrint('User not found: $id');
      return null;
    } on FirebaseException catch (e) {
      debugPrint('Firebase Error getting user: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Error getting user: $e');
      rethrow;
    }
  }

  // Update - Cập nhật user
  Future<void> updateUser(String id, User user) async {
    try {
      await _firestore.collection(usersCollection).doc(id).update(user.toMap());
      debugPrint('User updated: $id');
    } on FirebaseException catch (e) {
      debugPrint('Firebase Error updating user: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Error updating user: $e');
      rethrow;
    }
  }

  // Delete - Xóa user
  Future<void> deleteUser(String id) async {
    try {
      await _firestore.collection(usersCollection).doc(id).delete();
      debugPrint('User deleted: $id');
    } on FirebaseException catch (e) {
      debugPrint('Firebase Error deleting user: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Error deleting user: $e');
      rethrow;
    }
  }
}
