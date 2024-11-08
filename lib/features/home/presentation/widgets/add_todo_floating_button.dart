import 'package:flutter/material.dart';

class AddTodoFloatingButton extends StatelessWidget {
  const AddTodoFloatingButton({super.key, this.onPressed});
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.redAccent,
      shape: const OvalBorder(),
      child: const Icon(
        Icons.add,
        size: 35,
        color: Colors.white,
      ),
    );
  }
}
