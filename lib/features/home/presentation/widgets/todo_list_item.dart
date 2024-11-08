import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step/core/utils/datetime_util.dart';
import 'package:step/extensions/app_localization_string_builder.dart';
import 'package:step/features/home/presentation/components/edit_todo_panel.dart';

import '../../domain/entities/todo.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;
  final ValueChanged<bool?> onChanged;
  final ValueChanged<Todo> onUpdate;

  const TodoListItem({super.key,
    required this.todo,
    required this.onChanged,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    bool isDue = DateTimeUtil.isDayBefore(todo.dueDay, DateTime.now());

    if (todo.deadline != null) {
      isDue = todo.deadline!.isBefore(DateTime.now());
    }

    return ListTile(
      onTap: () => showModalBottomSheet(context: context, builder: (_) => EditTodoPanel(onUpdateTodo: onUpdate, todo: todo)),
      leading: Transform.translate(
        offset: const Offset(-10, -12),
        child: Checkbox(
          shape: const OvalBorder(
            eccentricity: 0.5
          ),
          activeColor: Colors.redAccent,
          checkColor: Colors.white,
          hoverColor: Colors.redAccent.withOpacity(0.5),
          focusColor: Colors.redAccent.withOpacity(0.5),
          value: todo.isDone,
          onChanged: onChanged,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            todo.title,
            style: GoogleFonts.aBeeZee(
              fontSize: 18,
              decoration: todo.isDone ? TextDecoration.lineThrough : TextDecoration.none,
              color: todo.isDone ? Colors.grey : Colors.black,
            ),
          ),
            Text(todo.description,
              style: GoogleFonts.aBeeZee(
                fontSize: 13,
                decoration: todo.isDone ? TextDecoration.lineThrough : TextDecoration.none,
                color: Colors.grey,
              )
          )
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          isDue ? Text(context.getLocaleString(value: 'overdue'),
              style: GoogleFonts.aBeeZee(
                fontSize: 13,
                decoration: todo.isDone ? TextDecoration.lineThrough : TextDecoration.none,
                color: Colors.redAccent,
              )
          ) : Text(
            _buildDisplayDay(context),
            style: GoogleFonts.aBeeZee(
              fontSize: 13,
              decoration: todo.isDone ? TextDecoration.lineThrough : TextDecoration.none,
              color: todo.isDone ? Colors.grey[600] : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  String _buildDisplayDay(BuildContext context) => DateTimeUtil.isSameDay(DateTime.now(), todo.dueDay) ? context.getLocaleString(value: 'today') : DateFormat('EEE, d/M/y', context.getLocaleString(value: 'locale')).format(todo.dueDay);
}