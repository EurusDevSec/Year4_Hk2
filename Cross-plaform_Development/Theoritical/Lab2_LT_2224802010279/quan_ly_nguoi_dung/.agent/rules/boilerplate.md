# Mẫu Code (Boilerplate)

## User Model

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final int age;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
  });

  // Convert từ Firestore document
  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      age: data['age'] ?? 0,
    );
  }

  // Convert sang Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'age': age,
    };
  }

  // Copy with
  User copyWith({
    String? id,
    String? name,
    String? email,
    int? age,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
    );
  }
}
```

## Firebase Service

```dart
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      print('Firebase initialized successfully');
    } catch (e) {
      print('Error initializing Firebase: $e');
      rethrow;
    }
  }
}
```

## Firestore Service

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String usersCollection = 'users';

  // Create
  Future<String> addUser(User user) async {
    try {
      final docRef = await _firestore
          .collection(usersCollection)
          .add(user.toMap());
      return docRef.id;
    } catch (e) {
      print('Error adding user: $e');
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
            return snapshot.docs
                .map((doc) => User.fromFirestore(doc))
                .toList();
          });
    } catch (e) {
      print('Error getting users stream: $e');
      rethrow;
    }
  }

  // Read - Single document
  Future<User?> getUserById(String id) async {
    try {
      final doc = await _firestore
          .collection(usersCollection)
          .doc(id)
          .get();
      return doc.exists ? User.fromFirestore(doc) : null;
    } catch (e) {
      print('Error getting user: $e');
      rethrow;
    }
  }

  // Update
  Future<void> updateUser(String id, User user) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(id)
          .update(user.toMap());
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  // Delete
  Future<void> deleteUser(String id) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(id)
          .delete();
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }
}
```

## Provider Setup

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

final firestoreServiceProvider = Provider((ref) => FirestoreService());

final usersStreamProvider = StreamProvider<List<User>>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getUsersStream();
});

final isLoadingProvider = StateProvider<bool>((ref) => false);

final errorMessageProvider = StateProvider<String?>((ref) => null);
```

## Form Widget

```dart
class UserForm extends StatefulWidget {
  final User? user; // null nếu create, có giá trị nếu update
  final Function(User) onSubmit;

  const UserForm({
    required this.onSubmit,
    this.user,
  });

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _ageController = TextEditingController(text: widget.user?.age.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Please enter name';
              return null;
            },
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Please enter email';
              if (!value!.contains('@')) return 'Invalid email';
              return null;
            },
          ),
          TextFormField(
            controller: _ageController,
            decoration: InputDecoration(labelText: 'Age'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Please enter age';
              if (int.tryParse(value!) == null) return 'Age must be a number';
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final user = User(
                  id: widget.user?.id ?? '',
                  name: _nameController.text,
                  email: _emailController.text,
                  age: int.parse(_ageController.text),
                );
                widget.onSubmit(user);
              }
            },
            child: Text(widget.user == null ? 'Add User' : 'Update User'),
          ),
        ],
      ),
    );
  }
}
```

## StreamBuilder Usage

```dart
StreamBuilder<List<User>>(
  stream: firestoreService.getUsersStream(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }

    final users = snapshot.data ?? [];
    if (users.isEmpty) {
      return Center(child: Text('No users found'));
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          title: Text(user.name),
          subtitle: Text(user.email),
          trailing: Text(user.age.toString()),
        );
      },
    );
  },
)
```
