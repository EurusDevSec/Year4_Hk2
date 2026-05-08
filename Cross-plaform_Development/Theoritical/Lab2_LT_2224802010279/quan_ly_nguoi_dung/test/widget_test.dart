import 'package:flutter_test/flutter_test.dart';
import 'package:quan_ly_nguoi_dung/models/user_model.dart';
import 'package:quan_ly_nguoi_dung/utils/validators.dart';

void main() {
  group('AppValidators', () {
    test('validateName returns error for empty value', () {
      expect(AppValidators.validateName(''), 'Please enter name');
    });

    test('validateEmail accepts valid email', () {
      expect(AppValidators.validateEmail('student@example.com'), isNull);
    });

    test('validateAge rejects invalid age', () {
      expect(
        AppValidators.validateAge('999'),
        'Please enter valid age (0-150)',
      );
    });
  });

  test('User.toMap serializes expected fields', () {
    final user = User(id: 'abc', name: 'An', email: 'an@mail.com', age: 22);

    final map = user.toMap();

    expect(map['name'], 'An');
    expect(map['email'], 'an@mail.com');
    expect(map['age'], 22);
  });
}
