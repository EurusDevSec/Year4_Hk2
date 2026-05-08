# Skill: Database Analyzer

## Mục tiêu

Phân tích cấu trúc Firestore database, validate data, và cung cấp recommendations.

## Chức năng

### 1. Analyze Collection Structure

- Check tất cả documents trong collection
- Verify fields có tên đúng và kiểu dữ liệu đúng
- Detect missing required fields
- Suggest missing indexes

### 2. Data Validation

```dart
class DatabaseAnalyzer {
  final FirebaseFirestore _firestore;

  DatabaseAnalyzer(this._firestore);

  Future<List<String>> validateUsers() async {
    final errors = <String>[];
    final snapshot = await _firestore.collection('users').get();

    for (final doc in snapshot.docs) {
      final data = doc.data();

      if (!data.containsKey('name') || data['name']?.isEmpty ?? true) {
        errors.add('Doc ${doc.id}: Missing or empty name');
      }
      if (!data.containsKey('email') || data['email']?.isEmpty ?? true) {
        errors.add('Doc ${doc.id}: Missing or empty email');
      }
      if (!data.containsKey('age') || data['age'] is! int) {
        errors.add('Doc ${doc.id}: Invalid age type');
      }
    }

    return errors;
  }
}
```

### 3. Performance Analysis

- Count documents
- Check for N+1 query patterns
- Suggest query optimization
- Monitor Firestore usage

### 4. Security Analysis

- Check collection security rules
- Verify read/write permissions
- Recommend security improvements

## Usage

```dart
final analyzer = DatabaseAnalyzer(FirebaseFirestore.instance);
final errors = await analyzer.validateUsers();

if (errors.isNotEmpty) {
  print('Database issues found:');
  errors.forEach(print);
} else {
  print('Database validation passed!');
}
```

## Integration with Project

1. Chạy analyzer khi app starts
2. Log results để debugging
3. Show warnings nếu data invalid
4. Trigger data migration nếu cần

## Recommendations

- Run regularly để detect issues early
- Automate validation checks
- Monitor collection growth
- Plan for scaling
