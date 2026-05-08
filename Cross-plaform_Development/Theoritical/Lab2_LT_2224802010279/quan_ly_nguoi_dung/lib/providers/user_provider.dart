import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

// Firestore Service Provider
final firestoreServiceProvider = Provider((ref) => FirestoreService());

// Users Stream Provider - Real-time updates
final usersStreamProvider = StreamProvider<List<User>>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getUsersStream();
});

// Single User Provider
final userProvider = FutureProvider.family<User?, String>((ref, userId) async {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getUserById(userId);
});

// Loading State Provider
final isLoadingProvider = StateProvider<bool>((ref) => false);

// Error Message Provider
final errorMessageProvider = StateProvider<String?>((ref) => null);
