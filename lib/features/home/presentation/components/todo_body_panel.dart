import 'package:flutter/material.dart';

class TodoBodyPanel extends StatelessWidget {
  const TodoBodyPanel(
      {super.key, required this.child, this.title});
  final Widget child;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: child,
    );
  }
}
