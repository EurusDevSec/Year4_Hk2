import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const CustomSearchBar({
    Key? key,
    required this.onChanged,
    required this.onClear,
  }) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Tìm trong danh sách...',
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: const Icon(Icons.search, color: Colors.white54),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.white54),
                onPressed: () {
                  _controller.clear();
                  widget.onClear();
                  setState(() {});
                },
              )
            : null,
        filled: true,
        fillColor: Colors.grey[850], // Dark input background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      onChanged: (value) {
        setState(() {});
        widget.onChanged(value);
      },
    );
  }
}
