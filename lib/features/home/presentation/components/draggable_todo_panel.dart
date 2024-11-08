import 'package:flutter/material.dart';
import 'package:step/extensions/app_localization_string_builder.dart';

import '../../domain/entities/todo.dart';
import '../widgets/collapsible_task_list.dart';

class DraggableTodoPanel extends StatefulWidget {
  final List<Todo> allTodos;
  final List<Todo> upcomingTodos;
  final List<Todo> todayTodos;
  final Function(Todo) onToggle;
  final List<String> sectionOrder;
  final ValueChanged<Todo> onChanged;

  DraggableTodoPanel({
    required this.allTodos,
    required this.upcomingTodos,
    required this.todayTodos,
    required this.onToggle,
    required this.sectionOrder,
    required this.onChanged,
  });

  @override
  _DraggableTodoPanelState createState() => _DraggableTodoPanelState();
}

class _DraggableTodoPanelState extends State<DraggableTodoPanel> {

  Widget _buildTodoPanel() {
    List<String> sectionOrder = widget.sectionOrder;
    return SingleChildScrollView(
      child: Column(
        children: sectionOrder.map((section) {
          // Determine the todos for each section
          List<Todo> todos;
          if (section == context.getLocaleString(value: 'today')) {
            todos = widget.todayTodos;
          } else if (section == context.getLocaleString(value: 'upcoming')) {
            todos = widget.upcomingTodos;
          } else {
            todos = widget.allTodos;
          }

          return LongPressDraggable<String>(
            data: section,
            feedback: Material(
              color: Colors.grey.withOpacity(0.5),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                child: CollapsibleTodoList(
                  onUpdate: widget.onChanged,
                  todos: todos,
                  title: section,
                  onToggle: widget.onToggle,
                  isDragged: true,
                ),
              ),
            ),
            childWhenDragging: Container(), // Placeholder when dragging
            child: DragTarget<String>(
              onAcceptWithDetails: (details) {
                setState(() {
                  final fromIndex = sectionOrder.indexOf(details.data);
                  final toIndex = sectionOrder.indexOf(section);
                  sectionOrder.removeAt(fromIndex);
                  sectionOrder.insert(toIndex, details.data);
                });
              },
              onWillAcceptWithDetails: (draggedSection) => draggedSection.data != section,
              builder: (context, candidateData, rejectedData) {
                return CollapsibleTodoList(
                  onUpdate: widget.onChanged,
                  todos: todos,
                  title: section,
                  onToggle: widget.onToggle,
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTodoPanel();
  }
}
