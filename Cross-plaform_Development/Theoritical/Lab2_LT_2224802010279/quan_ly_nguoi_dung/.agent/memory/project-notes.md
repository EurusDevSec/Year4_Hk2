# Project Notes - Quản lý Người dùng

## Project Overview

- **Name**: quan_ly_nguoi_dung
- **Type**: Flutter App (Cross-platform)
- **Backend**: Firebase Firestore
- **State Management**: Riverpod / Provider
- **Target Platforms**: Android, iOS, Web, Linux, macOS, Windows

## Key Features Implemented

- [x] User model with id, name, email, age
- [ ] Firebase initialization and Firestore setup
- [ ] CRUD operations (Create, Read, Update, Delete)
- [ ] Real-time data synchronization
- [ ] Error handling and logging
- [ ] Loading states (CircularProgressIndicator)
- [ ] Form validation
- [ ] Navigation between screens

## Project Structure

```
lib/
├── main.dart                 # Entry point
├── models/                   # Data models
├── services/                 # Firebase/Firestore
├── providers/                # State management
├── screens/                  # UI screens
├── widgets/                  # Reusable widgets
└── utils/                    # Helpers & validators
```

## Firestore Schema

**Collection: users**

```json
{
  "id": "string (auto-generated)",
  "name": "string",
  "email": "string",
  "age": "number"
}
```

## Important Libraries

```yaml
dependencies:
  firebase_core: ^latest
  cloud_firestore: ^latest
  riverpod: ^latest
  flutter_riverpod: ^latest
```

## Setup Checklist

- [ ] Create Firebase project
- [ ] Add Firebase credentials to Flutter
- [ ] Create Firestore collection and indexes
- [ ] Setup security rules
- [ ] Create User model
- [ ] Create FirestoreService
- [ ] Create Riverpod providers
- [ ] Create HomeScreen with list
- [ ] Create AddUserScreen
- [ ] Create EditUserScreen
- [ ] Test CRUD operations

## Testing Strategy

- Unit tests for models
- Service tests with mocking
- Widget tests for forms
- Integration tests for CRUD flow

## Known Issues

(None yet)

## TODO

1. Implement main.dart with Firebase initialization
2. Create User model and conversions
3. Create FirestoreService with CRUD
4. Create providers for state management
5. Create HomeScreen with StreamBuilder
6. Create AddUserScreen with form
7. Create EditUserScreen with form
8. Implement error handling
9. Implement loading states
10. Test all features

## Performance Notes

- StreamBuilder used for real-time updates
- Separate widgets for efficient rebuild
- Error boundary for graceful failure

## Security Considerations

- Validate all input data
- Handle Firebase errors
- Log errors for debugging
- Implement proper security rules
- Future: Add authentication

## Documentation Links

- [Firebase Flutter Plugin](https://firebase.flutter.dev)
- [Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Riverpod Documentation](https://riverpod.dev)
- [Flutter StreamBuilder](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html)
