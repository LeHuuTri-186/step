import 'package:flutter/material.dart';

class TodoBodyPanel extends StatelessWidget {
  const TodoBodyPanel(
      {super.key, required this.scrollController, required this.child, this.title});
  final ScrollController scrollController;
  final Widget child;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        title == null ? const SizedBox() : title!,
        Flexible(child: child,)
      ],
    );
  }
}
