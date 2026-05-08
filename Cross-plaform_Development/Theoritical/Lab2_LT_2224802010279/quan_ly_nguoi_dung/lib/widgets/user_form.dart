import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../utils/validators.dart';

class UserForm extends StatefulWidget {
  final User? user; // null nếu create, có giá trị nếu update
  final Function(User) onSubmit;
  final String submitButtonText;

  const UserForm({
    super.key,
    required this.onSubmit,
    required this.submitButtonText,
    this.user,
  });

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _ageController = TextEditingController(
      text: widget.user?.age.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final user = User(
        id: widget.user?.id ?? '',
        name: _nameController.text,
        email: _emailController.text,
        age: int.parse(_ageController.text),
      );
      widget.onSubmit(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
              prefixIcon: const Icon(Icons.person),
            ),
            validator: AppValidators.validateName,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              prefixIcon: const Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: AppValidators.validateEmail,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _ageController,
            decoration: InputDecoration(
              labelText: 'Age',
              border: OutlineInputBorder(),
              prefixIcon: const Icon(Icons.cake),
            ),
            keyboardType: TextInputType.number,
            validator: AppValidators.validateAge,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            child: Text(widget.submitButtonText),
          ),
        ],
      ),
    );
  }
}
