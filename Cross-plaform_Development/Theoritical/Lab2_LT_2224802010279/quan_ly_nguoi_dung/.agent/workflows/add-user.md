# Workflow: Thêm Người dùng

## Mục tiêu

Cho phép người dùng tạo mới một user và lưu vào Firestore.

## Flow

### 1. Điều hướng

```
HomeScreen
  └─ FAB (Add button) or Menu
      └─ AddUserScreen
```

### 2. Form Input

```
AddUserScreen (empty form)
  ├─ Name field (TextFormField)
  ├─ Email field (TextFormField)
  ├─ Age field (TextFormField)
  ├─ Validate button
  └─ Submit button (Add User)
```

### 3. Validation

```
On Submit:
  ├─ Check name not empty
  ├─ Check email format (contains @)
  ├─ Check age is valid number (0-150)
  └─ If all valid → Submit
     Else → Show error messages
```

### 4. Submit to Firestore

```
User presses "Add User"
  ↓
Validate input
  ↓
Show CircularProgressIndicator
  ↓
Call FirestoreService.addUser(user)
  ↓
Firebase Firestore saves document
  ↓
Return new document ID
  ↓
Show SnackBar: "User added successfully"
  ↓
Navigate back to HomeScreen
  ↓
StreamBuilder detects new data → Update UI
```

## Implementation

### AddUserScreen

```dart
class AddUserScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends ConsumerState<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _addUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = User(
        id: '',
        name: _nameController.text,
        email: _emailController.text,
        age: int.parse(_ageController.text),
      );

      final firestoreService = ref.read(firestoreServiceProvider);
      await firestoreService.addUser(user);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User added successfully')),
      );
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      _showErrorSnackBar('Firebase Error: ${e.message}');
    } on SocketException catch (e) {
      _showErrorSnackBar('Network Error: Check your connection');
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New User')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter email';
                  }
                  if (!value!.contains('@')) {
                    return 'Please enter valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter age';
                  }
                  final age = int.tryParse(value!);
                  if (age == null || age < 0 || age > 150) {
                    return 'Please enter valid age';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _addUser,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 48),
                      ),
                      child: Text('Add User'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Validation Rules

| Field | Rule                   | Message                    |
| ----- | ---------------------- | -------------------------- |
| Name  | Not empty              | "Please enter name"        |
| Email | Not empty + contains @ | "Please enter valid email" |
| Age   | Valid number 0-150     | "Please enter valid age"   |

## Error Handling

- Firebase error → Show SnackBar with error message
- Network error → Show "Check your connection"
- Validation error → Show in TextFormField error text

## After Success

1. Show success SnackBar
2. Navigate back to HomeScreen
3. StreamBuilder automatically updates with new user
4. Form cleared (not needed since navigate back)

## UI Feedback

- Loading state: CircularProgressIndicator
- Success: SnackBar
- Error: SnackBar with red background
