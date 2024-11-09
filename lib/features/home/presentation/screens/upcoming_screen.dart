import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:step/extensions/app_localization_string_builder.dart';
import 'package:step/features/home/presentation/bloc/upcoming/upcoming_event.dart';
import 'package:step/features/home/presentation/widgets/upcoming_title.dart';
import '../../../../core/utils/notification_helper.dart';
import '../bloc/flower_display_cubit.dart';
import '../bloc/upcoming/upcoming_bloc.dart';
import '../bloc/upcoming/upcoming_state.dart';
import '../components/add_todo_panel.dart';
import '../components/no_todo_panel.dart';
import '../components/todo_body_panel.dart';
import '../components/todo_panel.dart';
import '../widgets/add_todo_floating_button.dart';

import '../../domain/entities/todo.dart';

class UpcomingPage extends StatefulWidget {
  const UpcomingPage({
    super.key,
  });

  @override
  State<UpcomingPage> createState() => _UpcomingPageState();
}

class _UpcomingPageState extends State<UpcomingPage> {

  @override
  void initState() {
    super.initState();
    _loadUpcomingTodo();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: _buildTodoFloatingButton(),
        appBar: _buildAppBar(),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: _buildUpcomingBody(),
        ),
      ),
    );
  }

  void _loadUpcomingTodo() {
    context.read<UpcomingBloc>().add(LoadUpcomingTodo());
  }

  Widget _buildTodoFloatingButton() {
    return AddTodoFloatingButton(
      onPressed: _showBottomSheet,
    );
  }

  Widget _buildUpcomingBody() {
    return BlocBuilder<UpcomingBloc, UpcomingState>(
        builder: (_, state) => TodoBodyPanel(
            title: const UpcomingTitle(),
            child: _buildChildForState(state)));
  }

  Widget _buildChildForState(UpcomingState state) {
    if (state is UpcomingLoaded) {
      return _buildUpcomingPanel(state.todoList);
    } else if (state is NoUpcomingTodo) {
      return _buildNoUpcomingPanel();
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildUpcomingPanel(List<Todo> todoList) {
    return TodoPanel(
        onUpdate: _onUpdateTodo,
        toDoList: todoList,
        onRemove: _removeTodoItem,
        onToggle: _toggleTodoStatus);
  }

  Widget _buildNoUpcomingPanel() {
    context.read<FlowerDisplayCubit>().onDisplay();

    return BlocBuilder<FlowerDisplayCubit, String>(
            builder: (BuildContext context, String state) =>
                NoTodoPanel(imagePath: state))
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 300));
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (_) => AddTodoPanel(
        onCreateTodo: _onCreateTodo,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          context.getLocaleString(value: 'upcoming'),
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
              ),
        ),
      ),
        centerTitle: false,
    );
  }


  void _toggleTodoStatus(Todo todo) async {
    context.read<UpcomingBloc>().add(ToggleTodoCompletion(todo.id));
  }

  void _removeTodoItem(Todo todo) async {
    context.read<UpcomingBloc>().add(RemoveTodoEvent(removedTodo: todo));
  }

  void _onCreateTodo(Todo todo) {
    debugPrint(todo.deadline?.toIso8601String());

    if (todo.deadline != null) {
      NotificationHelper.scheduleNotification(todo: todo);
    }
    context.read<UpcomingBloc>().add(AddTodoEvent(newTodo: todo));
  }

  void _onUpdateTodo(Todo todo) {
    context.read<UpcomingBloc>().add(UpdateTodoEvent(todo: todo));
  }
}
