# Workflow: Hiển thị Danh sách Người dùng

## Mục tiêu

Hiển thị danh sách người dùng từ Firestore với real-time updates.

## Flow

### 1. Khởi tạo

```
HomeScreen init
  ↓
FirestoreService.getUsersStream() -> Stream<List<User>>
```

### 2. UI Layer

```
StreamBuilder<List<User>>
  ├─ connectionState.waiting → CircularProgressIndicator
  ├─ hasError → ErrorWidget (show error message)
  ├─ data.isEmpty → Center(Text('No users found'))
  └─ data.isNotEmpty → ListView.builder
      └─ UserListItem (mỗi user)
          ├─ name (title)
          ├─ email (subtitle)
          ├─ age (trailing)
          ├─ Edit button (tap → EditScreen)
          └─ Delete button (tap → DeleteConfirmDialog)
```

### 3. Tương tác

- **Tap user item** → Navigate to EditUserScreen
- **Tap Edit button** → Navigate to EditUserScreen
- **Tap Delete button** → Show DeleteConfirmDialog
- **FAB (Floating Action Button)** → Navigate to AddUserScreen

### 4. State Management

```dart
final usersStreamProvider = StreamProvider<List<User>>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getUsersStream();
});
```

### 5. Real-time Updates

- Firestore trả về Stream của snapshots
- Khi có user mới, sửa, hoặc xóa → Stream emit event mới
- UI tự động rebuild với dữ liệu mới

## Implementation

### HomeScreen Implementation

```dart
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsyncValue = ref.watch(usersStreamProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: usersAsyncValue.when(
        data: (users) {
          if (users.isEmpty) {
            return Center(
              child: Text('No users found. Tap + to add new user.'),
            );
          }
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return UserListItem(
                user: user,
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditUserScreen(user: user),
                    ),
                  );
                },
                onDelete: () => _showDeleteConfirm(context, user),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUserScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

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
        SnackBar(content: Text('User deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }
}
```

### UserListItem Widget

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
```

## Error Handling

- Network error → Show error message
- Firebase error → Show error message
- Empty list → Show "No users found"

## Performance Considerations

- Sử dụng StreamBuilder để tránh rebuild toàn bộ UI
- Mỗi UserListItem là separate widget để rebuild efficiently
- Pagination nếu có quá nhiều users
