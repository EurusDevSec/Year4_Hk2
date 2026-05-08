# Workflow: Xóa Người dùng

## Mục tiêu

Cho phép người dùng xóa một user khỏi hệ thống sau khi xác nhận.

## Flow

### 1. Trigger Delete

```
HomeScreen (List)
  └─ Tap Delete button on UserListItem
      └─ Show DeleteConfirmDialog
```

### 2. Confirmation Dialog

```
DeleteConfirmDialog
  ├─ Title: "Delete User?"
  ├─ Message: "Are you sure you want to delete {userName}?"
  ├─ Cancel button → Close dialog (do nothing)
  └─ Delete button → Proceed with deletion
```

### 3. Delete from Firestore

```
User confirms deletion
  ↓
Show CircularProgressIndicator (on list hoặc dialog)
  ↓
Call FirestoreService.deleteUser(userId)
  ↓
Firebase Firestore removes document
  ↓
Show SnackBar: "User deleted successfully"
  ↓
StreamBuilder detects removed user → Update UI automatically
  ↓
User removed from list
```

## Implementation

### Dialog Method in HomeScreen

```dart
void _showDeleteConfirm(BuildContext context, User user) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Delete User?'),
      content: Text('Are you sure you want to delete ${user.name}?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _deleteUser(context, user.id);
          },
          child: Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

void _deleteUser(BuildContext context, String userId) async {
  try {
    final firestoreService = FirestoreService();
    await firestoreService.deleteUser(userId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User deleted successfully'),
        backgroundColor: Colors.green,
      ),
    );
  } on FirebaseException catch (e) {
    _showErrorSnackBar(context, 'Firebase Error: ${e.message}');
  } on SocketException catch (e) {
    _showErrorSnackBar(context, 'Network Error: Check your connection');
  } catch (e) {
    _showErrorSnackBar(context, 'Error: $e');
  }
}

void _showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}
```

### Using in UserListItem

```dart
class UserListItem extends StatelessWidget {
  final User user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UserListItem({
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onTap: onEdit,
        title: Text(user.name),
        subtitle: Text(user.email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${user.age}'),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

// In HomeScreen:
UserListItem(
  user: user,
  onEdit: () {
    // Navigate to edit screen
  },
  onDelete: () => _showDeleteConfirm(context, user),
)
```

## Alternative: Swipe to Delete

```dart
Dismissible(
  key: Key(user.id),
  direction: DismissDirection.endToStart,
  confirmDismiss: (direction) async {
    return await _showDeleteConfirm(context, user);
  },
  onDismissed: (direction) {
    _deleteUser(context, user.id);
  },
  background: Container(
    color: Colors.red,
    child: Icon(Icons.delete, color: Colors.white),
    alignment: Alignment.centerRight,
    padding: EdgeInsets.only(right: 16),
  ),
  child: UserListItem(
    user: user,
    onEdit: () => _navigateToEdit(context, user),
    onDelete: () => _showDeleteConfirm(context, user),
  ),
)
```

## Error Handling

- Firebase error → Show SnackBar with error message
- Network error → Show "Check your connection"
- User cancels → Do nothing (dialog closes)

## After Success

1. Show success SnackBar
2. StreamBuilder detects deleted user → List updates automatically
3. User removed from list
4. Dialog closes automatically

## UI Feedback

- Loading: Can show loading on dialog or full screen
- Success: Green SnackBar "User deleted successfully"
- Error: Red SnackBar with error message
- Confirmation: AlertDialog requires explicit yes/no

## Best Practices

1. Luôn hiển thị confirmation dialog trước delete
2. Không cho phép undo (hoặc implement undo nếu cần)
3. Hiển thị user name trong confirmation message
4. Handle network errors gracefully
5. Log deletion action cho audit trail
