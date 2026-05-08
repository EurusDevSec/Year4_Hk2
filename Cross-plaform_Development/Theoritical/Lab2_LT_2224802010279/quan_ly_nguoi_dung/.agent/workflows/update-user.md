# Workflow: Cập nhật Người dùng

## Mục tiêu

Cho phép người dùng chỉnh sửa thông tin user đã tồn tại.

## Flow

### 1. Điều hướng

```
HomeScreen (List)
  └─ Tap user item hoặc Edit button
      └─ EditUserScreen (với dữ liệu user)
```

### 2. Form Pre-filled

```
EditUserScreen (form pre-filled với dữ liệu cũ)
  ├─ Name field (TextFormField with initial value)
  ├─ Email field (TextFormField with initial value)
  ├─ Age field (TextFormField with initial value)
  ├─ Validate button
  └─ Update button
```

### 3. Validation

```
On Submit:
  ├─ Check name not empty
  ├─ Check email format (contains @)
  ├─ Check age is valid number (0-150)
  └─ If all valid → Submit
     Else → Show error messages in field
```

### 4. Submit to Firestore

```
User presses "Update User"
  ↓
Validate input
  ↓
Show CircularProgressIndicator
  ↓
Call FirestoreService.updateUser(id, user)
  ↓
Firebase Firestore updates document
  ↓
Show SnackBar: "User updated successfully"
  ↓
Navigate back to HomeScreen
  ↓
StreamBuilder detects updated data → Update UI
```

## Implementation

### EditUserScreen

```dart
class EditUserScreen extends ConsumerStatefulWidget {
  final User user;

  const EditUserScreen({required this.user});

  @override
  ConsumerState<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends ConsumerState<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _ageController = TextEditingController(text: widget.user.age.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _updateUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedUser = widget.user.copyWith(
        name: _nameController.text,
        email: _emailController.text,
        age: int.parse(_ageController.text),
      );

      final firestoreService = ref.read(firestoreServiceProvider);
      await firestoreService.updateUser(widget.user.id, updatedUser);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User updated successfully')),
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
      appBar: AppBar(title: Text('Edit User')),
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
                  : Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _updateUser,
                            child: Text('Update'),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Key Differences from AddUserScreen

- Form pre-filled với dữ liệu cũ
- Gọi `updateUser()` thay vì `addUser()`
- Sử dụng `copyWith()` để tạo user object mới
- Có Cancel button để quay lại mà không save
- Không reset form (navigate back thay vì clear)

## Validation Rules

Giống như AddUserScreen:
| Field | Rule | Message |
|-------|------|---------|
| Name | Not empty | "Please enter name" |
| Email | Not empty + contains @ | "Please enter valid email" |
| Age | Valid number 0-150 | "Please enter valid age" |

## Error Handling

- Firebase error → Show SnackBar with error message
- Network error → Show "Check your connection"
- Validation error → Show in TextFormField error text

## After Success

1. Show success SnackBar
2. Navigate back to HomeScreen
3. StreamBuilder automatically updates with changed user
4. UI shows updated user info in list
