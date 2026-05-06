import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NoteService {
  static const String _notesKey = 'notes_list';
  late SharedPreferences _prefs;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Get all notes
  Future<List<Note>> getAllNotes() async {
    final String? notesJson = _prefs.getString(_notesKey);
    if (notesJson == null) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(notesJson);
      final List<Note> notes = decoded
          .map((note) => Note.fromJson(note as Map<String, dynamic>))
          .toList();

      // Sort by creation date (newest first)
      notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return notes;
    } catch (e) {
      return [];
    }
  }

  // Add a new note
  Future<Note> addNote(String title, String content) async {
    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );

    final List<Note> notes = await getAllNotes();
    notes.insert(0, note);
    await _saveNotes(notes);

    return note;
  }

  // Update an existing note
  Future<Note> updateNote(String id, String title, String content) async {
    final List<Note> notes = await getAllNotes();
    final int index = notes.indexWhere((note) => note.id == id);

    if (index != -1) {
      final updatedNote = notes[index].copyWith(
        title: title,
        content: content,
        updatedAt: DateTime.now(),
      );
      notes[index] = updatedNote;
      await _saveNotes(notes);
      return updatedNote;
    }

    throw Exception('Note not found');
  }

  // Delete a note
  Future<void> deleteNote(String id) async {
    final List<Note> notes = await getAllNotes();
    notes.removeWhere((note) => note.id == id);
    await _saveNotes(notes);
  }

  // Get a single note by ID
  Future<Note?> getNoteById(String id) async {
    final List<Note> notes = await getAllNotes();
    try {
      return notes.firstWhere((note) => note.id == id);
    } catch (e) {
      return null;
    }
  }

  // Save notes to SharedPreferences
  Future<void> _saveNotes(List<Note> notes) async {
    final String notesJson = jsonEncode(
      notes.map((note) => note.toJson()).toList(),
    );
    await _prefs.setString(_notesKey, notesJson);
  }

  // Clear all notes
  Future<void> clearAllNotes() async {
    await _prefs.remove(_notesKey);
  }
}
