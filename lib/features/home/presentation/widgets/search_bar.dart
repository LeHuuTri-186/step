import 'package:flutter/material.dart';

class TodoSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String hintText;

  const TodoSearchBar({
    super.key,
    required this.onChanged,
    this.hintText = "Search...",
  });

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<TodoSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      widget.onChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.redAccent,
      controller: _controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.redAccent.withOpacity(0.5),
          )
        ),
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search, color: Colors.redAccent,),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.black),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged(""); // Clear the search text
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
