# Note App - Flutter Application

## Overview

A fully functional personal note-taking application built with Flutter. The app allows users to create, read, update, and delete notes with persistent local storage using SharedPreferences.

## Features Implemented

### ✅ Main Screen (Home Screen)

- **Display Notes List**: Shows all saved notes with:
  - Note title (bold, prominent)
  - Content preview (first 50 characters)
  - Creation date and time in format: DD/MM/YYYY HH:MM
- **Add Note Button**: Floating Action Button (+) to create new notes
- **Empty State**: User-friendly message when no notes exist
- **Loading State**: Loading indicator while fetching notes

### ✅ Add Note

- Clean input screen with two fields:
  - Title input field
  - Content input field (multi-line)
- Save button in AppBar
- Form validation (title and content required)
- Success notification after saving
- Automatic return to main screen on save

### ✅ Edit Note

- Tap on any note to open edit screen
- Pre-populated fields with existing note data
- Update timestamp when note is modified
- Same validation and save mechanism as add note
- Automatic list refresh after update

### ✅ Delete Note

Multiple ways to delete:

1. **Long Press**: Long press on note card to show delete menu
2. **Popup Menu**: Tap the menu button (⋮) on each note
3. **Confirmation Dialog**: User must confirm before deletion
4. **Success Message**: Notification shown after deletion

### ✅ Data Persistence

- **Storage**: SharedPreferences (local JSON storage)
- **Automatic Serialization**: Notes stored as JSON objects
- **Sorting**: Notes sorted by creation date (newest first)
- **Persistence**: Data survives app restart

## Project Structure

```
lib/
├── main.dart                 # App entry point and initialization
├── models/
│   └── note.dart            # Note data model with JSON serialization
├── services/
│   └── note_service.dart    # Business logic and data persistence layer
└── screens/
    ├── home_screen.dart     # Main note list screen
    └── note_screen.dart     # Add/Edit note screen
```

## Classes & Models

### Note Model

```dart
class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Methods:
  // - toJson() / fromJson() : Serialization
  // - copyWith() : Create modified copy
  // - getContentPreview() : Get first 50 chars
}
```

### NoteService

Handles all data operations:

- `getAllNotes()` : Fetch all notes
- `addNote()` : Create new note
- `updateNote()` : Edit existing note
- `deleteNote()` : Remove note by ID
- `getNoteById()` : Get single note
- `clearAllNotes()` : Clear all data

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.2.2 # Local data persistence
  intl: ^0.19.0 # Date formatting
```

## How to Run

1. **Get Dependencies**:

   ```bash
   flutter pub get
   ```

2. **Run the App**:

   ```bash
   flutter run
   ```

3. **Build Release**:
   ```bash
   flutter build apk
   ```

## Usage Guide

### Creating a Note

1. Tap the **+** button in bottom right
2. Enter a title
3. Enter content
4. Tap **Save** button
5. Note appears in list

### Editing a Note

1. Tap on a note in the list
2. Modify title/content
3. Tap **Save** button
4. Changes are saved

### Deleting a Note

**Option 1 - Long Press**:

1. Long press on a note card
2. Tap "Delete Note"
3. Confirm deletion

**Option 2 - Popup Menu**:

1. Tap the menu button (⋮) on a note
2. Tap "Delete"
3. Confirm deletion

## UI Components

- **AppBar**: Material Design top navigation
- **ListView**: Scrollable note list
- **Card**: Individual note container with Material elevation
- **TextField**: Input fields with validation
- **FloatingActionButton**: Primary action (add note)
- **PopupMenuButton**: Quick actions menu
- **BottomSheet**: Delete confirmation menu
- **AlertDialog**: Delete confirmation dialog
- **SnackBar**: Success/error notifications

## State Management

The app uses simple StatefulWidget state management:

- **HomeScreen**: Manages note list state
- **NoteScreen**: Manages note edit/add state
- **NoteService**: Singleton service for data operations

## Date Formatting

Notes display creation time using:

- Format: `DD/MM/YYYY HH:MM`
- Example: `05/05/2026 14:30`

## Error Handling

- Validation for empty title/content
- Error messages shown in SnackBar
- Try-catch blocks in all async operations
- Graceful error recovery

## Storage Format

Notes are stored in SharedPreferences as JSON:

```json
[
  {
    "id": "1715000000000",
    "title": "My Note",
    "content": "Note content here",
    "createdAt": "2026-05-05T14:30:00.000Z",
    "updatedAt": "2026-05-05T15:00:00.000Z"
  }
]
```

## Theme

- Material Design 3 with blue seed color
- Light theme with Material components
- Responsive design for all screen sizes
- Proper contrast and accessibility

## Future Enhancements

Possible improvements:

- Rich text editor (bold, italic, colors)
- Categories/Tags for notes
- Search functionality
- Cloud sync
- Note backup/export
- Dark theme
- Widgets preview

---

**Author**: Built for educational purposes  
**Language**: Dart/Flutter  
**Last Updated**: May 6, 2026
