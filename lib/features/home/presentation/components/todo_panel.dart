import 'package:flutter/material.dart';
import 'package:step/features/home/presentation/widgets/todo_list_item.dart';

import '../../domain/entities/todo.dart';

class TodoPanel extends StatefulWidget {
  final List<Todo> toDoList;
  final void Function(Todo) onRemove;
  final void Function(Todo) onToggle;
  final ValueChanged<Todo> onUpdate;

  const TodoPanel({
    super.key,
    required this.toDoList,
    required this.onRemove,
    required this.onToggle,
    required this.onUpdate,
  });

  @override
  _TodoPanelState createState() => _TodoPanelState();
}

class _TodoPanelState extends State<TodoPanel> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemCount: widget.toDoList.length,
      itemBuilder: (context, index) {
        return Dismissible(
          background: Container(
            color: Colors.redAccent,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.delete_forever_outlined,
                    color: Colors.white,
                    size: 35,
                  ),
                )
              ],
            ),
          ),
          key: Key(widget.toDoList[index].id),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            Todo todo = widget.toDoList[index];
            widget.toDoList.removeAt(index);
            widget.onRemove(todo);
          },
          child: TodoListItem(
            todo: widget.toDoList[index],
            onChanged: (bool? value) {
              widget.onToggle(widget.toDoList[index]);
            }, onUpdate: widget.onUpdate,
          ),
        );
      },
      separatorBuilder: (context, index) => const Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Divider(
          thickness: 1.5,
        ),
      ),
    );
  }
}