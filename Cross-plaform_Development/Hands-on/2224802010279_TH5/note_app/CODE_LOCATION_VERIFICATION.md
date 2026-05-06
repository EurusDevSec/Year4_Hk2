# 🔍 Xác Minh Chi Tiết - Code Location & Tính Năng

## 📝 Yêu Cầu 1: Màn Hình Chính - DANH SÁCH GHI CHÚ

### 1.1 Hiển thị danh sách ghi chú
- **File**: `lib/screens/home_screen.dart` (dòng 150-240)
- **Code**:
  ```dart
  ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount: notes.length,
    itemBuilder: (context, index) {
      // Tạo từng card ghi chú
    }
  )
  ```
- **Trạng thái**: ✅ Hiển thị tất cả ghi chú

### 1.2 Tiêu đề ghi chú
- **File**: `lib/screens/home_screen.dart` (dòng 170-176)
- **Code**:
  ```dart
  Text(
    note.title,
    style: const TextStyle(
      fontWeight: FontWeight.bold,  // In đậm
      fontSize: 16,
    ),
  )
  ```
- **Trạng thái**: ✅ Hiển thị tiêu đề in đậm

### 1.3 Nội dung ngắn (preview)
- **File**: `lib/models/note.dart` (dòng 62-67)
- **Code**:
  ```dart
  String getContentPreview() {
    if (content.length > 50) {
      return '${content.substring(0, 50)}...';  // 50 ký tự
    }
    return content;
  }
  ```
- **File**: `lib/screens/home_screen.dart` (dòng 177-184)
- **Code**:
  ```dart
  Text(
    note.getContentPreview(),  // Gọi phương thức
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
  )
  ```
- **Trạng thái**: ✅ Hiển thị 50 ký tự đầu tiên

### 1.4 Thời gian tạo
- **File**: `lib/screens/home_screen.dart` (dòng 165-166)
- **Code**:
  ```dart
  final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  final createdDate = dateFormat.format(note.createdAt);
  ```
- **File**: `lib/screens/home_screen.dart` (dòng 185-191)
- **Code**:
  ```dart
  Text(
    createdDate,  // Định dạng: DD/MM/YYYY HH:MM
    style: TextStyle(color: Colors.grey[500], fontSize: 12),
  )
  ```
- **Trạng thái**: ✅ Hiển thị thời gian định dạng

### 1.5 Nút thêm ghi chú (+)
- **File**: `lib/screens/home_screen.dart` (dòng 245-250)
- **Code**:
  ```dart
  floatingActionButton: FloatingActionButton(
    onPressed: _addNote,
    tooltip: 'Add Note',
    child: const Icon(Icons.add),  // Biểu tượng +
  )
  ```
- **Trạng thái**: ✅ Floating Action Button để thêm ghi chú

### 1.6 Trạng thái rỗng
- **File**: `lib/screens/home_screen.dart` (dòng 136-156)
- **Code**:
  ```dart
  notes.isEmpty
    ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_outlined, size: 64),
            Text('No notes yet'),
            Text('Tap the + button to create your first note'),
          ],
        ),
      )
    : ListView(...)
  ```
- **Trạng thái**: ✅ Hiển thị thông báo khi danh sách trống

---

## ➕ Yêu Cầu 2: THÊM GHI CHÚ

### 2.1 Nhập tiêu đề
- **File**: `lib/screens/note_screen.dart` (dòng 106-120)
- **Code**:
  ```dart
  TextField(
    controller: _titleController,
    decoration: InputDecoration(hintText: 'Note Title'),
    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    maxLines: 1,  // Một dòng
  )
  ```
- **Trạng thái**: ✅ TextField cho tiêu đề

### 2.2 Nhập nội dung
- **File**: `lib/screens/note_screen.dart` (dòng 124-142)
- **Code**:
  ```dart
  TextField(
    controller: _contentController,
    decoration: InputDecoration(hintText: 'Note Content'),
    maxLines: null,      // Đa dòng
    minLines: 10,        // Tối thiểu 10 dòng
  )
  ```
- **Trạng thái**: ✅ TextField đa dòng cho nội dung

### 2.3 Nút lưu
- **File**: `lib/screens/note_screen.dart` (dòng 69-85)
- **Code**:
  ```dart
  AppBar(
    title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
    actions: [
      TextButton(
        onPressed: _saveNote,
        child: const Text('Save'),
      )
    ],
  )
  ```
- **Trạng thái**: ✅ Nút "Save" trong AppBar

### 2.4 Kiểm tra tiêu đề không rỗng
- **File**: `lib/screens/note_screen.dart` (dòng 35-38)
- **Code**:
  ```dart
  if (_titleController.text.isEmpty) {
    _showErrorSnackBar('Please enter a title');
    return;
  }
  ```
- **Trạng thái**: ✅ Kiểm tra tiêu đề

### 2.5 Kiểm tra nội dung không rỗng
- **File**: `lib/screens/note_screen.dart` (dòng 40-43)
- **Code**:
  ```dart
  if (_contentController.text.isEmpty) {
    _showErrorSnackBar('Please enter some content');
    return;
  }
  ```
- **Trạng thái**: ✅ Kiểm tra nội dung

### 2.6 Lưu ghi chú mới
- **File**: `lib/screens/note_screen.dart` (dòng 45-56)
- **Code**:
  ```dart
  if (widget.note == null) {
    // Thêm mới
    await widget.noteService.addNote(
      _titleController.text,
      _contentController.text,
    );
    _showSuccessSnackBar('Note saved successfully');
  }
  ```
- **File**: `lib/services/note_service.dart` (dòng 34-47)
- **Code**:
  ```dart
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
  ```
- **Trạng thái**: ✅ Lưu ghi chú mới

### 2.7 Quay về danh sách
- **File**: `lib/screens/note_screen.dart` (dòng 60-62)
- **Code**:
  ```dart
  if (mounted) {
    Navigator.pop(context, true);  // Quay về
  }
  ```
- **File**: `lib/screens/home_screen.dart` (dòng 39-45)
- **Code**:
  ```dart
  void _addNote() {
    Navigator.push(...)
      .then((result) {
        if (result == true) {
          _loadNotes();  // Reload danh sách
        }
      });
  }
  ```
- **Trạng thái**: ✅ Quay về và reload danh sách

---

## ✏️ Yêu Cầu 3: CHỈNH SỬA GHI CHÚ

### 3.1 Nhấp vào ghi chú để sửa
- **File**: `lib/screens/home_screen.dart` (dòng 193-194)
- **Code**:
  ```dart
  onTap: () => _editNote(note),
  ```
- **File**: `lib/screens/home_screen.dart` (dòng 47-56)
- **Code**:
  ```dart
  void _editNote(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteScreen(
          noteService: widget.noteService,
          note: note,  // Truyền ghi chú hiện có
        ),
      ),
    ).then((result) {
      if (result == true) {
        _loadNotes();
      }
    });
  }
  ```
- **Trạng thái**: ✅ Mở NoteScreen với ghi chú

### 3.2 Pre-fill dữ liệu cũ
- **File**: `lib/screens/note_screen.dart` (dòng 22-26)
- **Code**:
  ```dart
  _titleController = TextEditingController(
    text: widget.note?.title ?? ''  // Dữ liệu cũ hoặc rỗng
  );
  _contentController = TextEditingController(
    text: widget.note?.content ?? ''
  );
  ```
- **Trạng thái**: ✅ Pre-fill thông tin cũ

### 3.3 Cập nhật ghi chú
- **File**: `lib/screens/note_screen.dart` (dòng 57-66)
- **Code**:
  ```dart
  } else {
    // Cập nhật
    await widget.noteService.updateNote(
      widget.note!.id,
      _titleController.text,
      _contentController.text,
    );
    _showSuccessSnackBar('Note updated successfully');
  }
  ```
- **File**: `lib/services/note_service.dart` (dòng 49-65)
- **Code**:
  ```dart
  Future<Note> updateNote(String id, String title, String content) async {
    final List<Note> notes = await getAllNotes();
    final int index = notes.indexWhere((note) => note.id == id);

    if (index != -1) {
      final updatedNote = notes[index].copyWith(
        title: title,
        content: content,
        updatedAt: DateTime.now(),  // Cập nhật timestamp
      );
      notes[index] = updatedNote;
      await _saveNotes(notes);
      return updatedNote;
    }
  }
  ```
- **Trạng thái**: ✅ Cập nhật ghi chú với updatedAt

### 3.4 Reload danh sách
- **File**: `lib/screens/home_screen.dart` (dòng 47-56)
- **Code**:
  ```dart
  .then((result) {
    if (result == true) {
      _loadNotes();  // Reload
    }
  });
  ```
- **Trạng thái**: ✅ Reload danh sách tự động

---

## 🗑️ Yêu Cầu 4: XÓA GHI CHÚ

### 4.1 Long press để hiển thị menu
- **File**: `lib/screens/home_screen.dart` (dòng 163-164)
- **Code**:
  ```dart
  GestureDetector(
    onLongPress: () => _showDeleteMenu(note),  // Long press
    child: ListTile(...)
  )
  ```
- **File**: `lib/screens/home_screen.dart` (dòng 97-113)
- **Code**:
  ```dart
  void _showDeleteMenu(Note note) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Note'),
              onTap: () => _deleteNote(note),
            ),
            ListTile(
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
  ```
- **Trạng thái**: ✅ Long press → BottomSheet menu

### 4.2 Popup menu để xóa
- **File**: `lib/screens/home_screen.dart` (dòng 195-217)
- **Code**:
  ```dart
  trailing: PopupMenuButton(
    itemBuilder: (context) => [
      PopupMenuItem(
        child: const Row(
          children: [Icon(Icons.edit), Text('Edit')],
        ),
        onTap: () => _editNote(note),
      ),
      PopupMenuItem(
        child: const Row(
          children: [
            Icon(Icons.delete, color: Colors.red),
            Text('Delete', style: TextStyle(color: Colors.red)),
          ],
        ),
        onTap: () => _deleteNote(note),
      ),
    ],
  )
  ```
- **Trạng thái**: ✅ Popup menu với Edit & Delete

### 4.3 Dialog xác nhận
- **File**: `lib/screens/home_screen.dart` (dòng 119-141)
- **Code**:
  ```dart
  Future<void> _deleteNote(Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: Text('Are you sure you want to delete "${note.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  ```
- **Trạng thái**: ✅ AlertDialog xác nhận

### 4.4 Xóa ghi chú
- **File**: `lib/screens/home_screen.dart` (dòng 143-148)
- **Code**:
  ```dart
  if (confirmed == true) {
    try {
      await widget.noteService.deleteNote(note.id);
      _loadNotes();
      _showSuccessSnackBar('Note deleted');
    }
  }
  ```
- **File**: `lib/services/note_service.dart` (dòng 67-71)
- **Code**:
  ```dart
  Future<void> deleteNote(String id) async {
    final List<Note> notes = await getAllNotes();
    notes.removeWhere((note) => note.id == id);
    await _saveNotes(notes);
  }
  ```
- **Trạng thái**: ✅ Xóa ghi chú và reload

---

## 💾 Yêu Cầu 5: LƯU TRỮ DỮ LIỆU

### 5.1 SharedPreferences initialization
- **File**: `lib/services/note_service.dart` (dòng 8-11)
- **Code**:
  ```dart
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  ```
- **File**: `lib/main.dart` (dòng 6-12)
- **Code**:
  ```dart
  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    final noteService = NoteService();
    await noteService.init();  // Khởi tạo
    runApp(MyApp(noteService: noteService));
  }
  ```
- **Trạng thái**: ✅ Khởi tạo SharedPreferences

### 5.2 Lưu JSON
- **File**: `lib/services/note_service.dart` (dòng 85-91)
- **Code**:
  ```dart
  Future<void> _saveNotes(List<Note> notes) async {
    final String notesJson = jsonEncode(
      notes.map((note) => note.toJson()).toList()
    );
    await _prefs.setString(_notesKey, notesJson);
  }
  ```
- **File**: `lib/models/note.dart` (dòng 17-26)
- **Code**:
  ```dart
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
  ```
- **Trạng thái**: ✅ Lưu dữ liệu dưới dạng JSON

### 5.3 Tải JSON
- **File**: `lib/services/note_service.dart` (dòng 13-32)
- **Code**:
  ```dart
  Future<List<Note>> getAllNotes() async {
    final String? notesJson = _prefs.getString(_notesKey);
    if (notesJson == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(notesJson);
      final List<Note> notes = decoded
        .map((note) => Note.fromJson(note as Map<String, dynamic>))
        .toList();

      notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return notes;
    } catch (e) {
      return [];
    }
  }
  ```
- **File**: `lib/models/note.dart` (dòng 29-42)
- **Code**:
  ```dart
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'] as String)
        : null,
    );
  }
  ```
- **Trạng thái**: ✅ Tải và parse JSON

### 5.4 Dữ liệu tồn tại sau tắt app
- **Cơ Chế**: SharedPreferences lưu trữ trên device storage
- **Thời Điểm Khôi Phục**:
  - App start → `NoteService.init()`
  - HomeScreen → `_loadNotes()` → `getAllNotes()`
  - Tải JSON từ SharedPreferences
- **Trạng thái**: ✅ Dữ liệu tồn tại persistent

---

## ✅ TỔNG KẾT KIỂM CHỨNG

| Chức Năng | File | Dòng | Trạng Thái |
|-----------|------|------|-----------|
| Hiển thị danh sách | home_screen.dart | 150-240 | ✅ |
| Tiêu đề (bold) | home_screen.dart | 170-176 | ✅ |
| Nội dung (50 ký tự) | note.dart | 62-67 | ✅ |
| Thời gian (dd/MM/yyyy HH:mm) | home_screen.dart | 165-166, 185-191 | ✅ |
| Nút + thêm | home_screen.dart | 245-250 | ✅ |
| Trạng thái rỗng | home_screen.dart | 136-156 | ✅ |
| Nhập tiêu đề | note_screen.dart | 106-120 | ✅ |
| Nhập nội dung | note_screen.dart | 124-142 | ✅ |
| Nút Save | note_screen.dart | 69-85 | ✅ |
| Kiểm tra tiêu đề | note_screen.dart | 35-38 | ✅ |
| Kiểm tra nội dung | note_screen.dart | 40-43 | ✅ |
| Lưu mới | note_screen.dart, note_service.dart | 45-56, 34-47 | ✅ |
| Quay về | note_screen.dart, home_screen.dart | 60-62, 39-45 | ✅ |
| Nhấp để sửa | home_screen.dart | 193-194, 47-56 | ✅ |
| Pre-fill | note_screen.dart | 22-26 | ✅ |
| Cập nhật | note_screen.dart, note_service.dart | 57-66, 49-65 | ✅ |
| Reload | home_screen.dart | 47-56 | ✅ |
| Long press xóa | home_screen.dart | 163-164, 97-113 | ✅ |
| Popup menu xóa | home_screen.dart | 195-217 | ✅ |
| Dialog xác nhận | home_screen.dart | 119-141 | ✅ |
| Xóa ghi chú | home_screen.dart, note_service.dart | 143-148, 67-71 | ✅ |
| SharedPreferences init | note_service.dart, main.dart | 8-11, 6-12 | ✅ |
| Lưu JSON | note_service.dart, note.dart | 85-91, 17-26 | ✅ |
| Tải JSON | note_service.dart, note.dart | 13-32, 29-42 | ✅ |
| Lưu persistent | note_service.dart | 85-91 | ✅ |

---

**🎯 TẤT CẢ YÊU CẦU ĐÃ ĐƯỢC CÀI ĐẶT VÀ KIỂM CHỨNG ✅**

Mỗi dòng code có vị trí chính xác, có thể dễ dàng tìm thấy và xác minh.
