import 'package:flutter/material.dart';
import 'package:step/features/home/presentation/widgets/todo_list_item.dart';

import '../../domain/entities/todo.dart';

class CollapsibleTodoList extends StatelessWidget {
  final List<Todo> todos;
  final String title;
  final void Function(Todo) onToggle;
  final bool isDragged;
  final ValueChanged<Todo> onUpdate;

  const CollapsibleTodoList({
    super.key,
    required this.todos,
    required this.title,
    required this.onToggle,
    this.isDragged = false, required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border(bottom: BorderSide(
            width: 2,
            color: Colors.grey.withOpacity(0.5),
          ))
        ),
        child: ExpansionTile(
          expansionAnimationStyle: AnimationStyle(
            curve: Curves.easeInOutQuint,
            duration: const Duration(milliseconds: 300),
            reverseCurve: Curves.decelerate,
            reverseDuration: const Duration(milliseconds: 300),
          ),
          collapsedIconColor: Colors.redAccent,
          iconColor: Colors.redAccent,
          shape: const RoundedRectangleBorder(),
          collapsedShape: const RoundedRectangleBorder(),
          backgroundColor: isDragged ? Colors.grey : Colors.transparent,
          enabled: todos.isNotEmpty,
          title: Text('$title (${todos.length})'),
          children: todos.map((todo) {
            return TodoListItem(todo: todo, onChanged: (_) => onToggle(todo), onUpdate: onUpdate,);
          }).toList(),
        ),
      ),
    );
  }
}
