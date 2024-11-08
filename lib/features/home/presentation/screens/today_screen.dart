import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:step/features/home/presentation/widgets/today_title.dart';
import '../../../../core/utils/notification_helper.dart';
import '../../../../extensions/app_localization_string_builder.dart';
import '../bloc/flower_display_cubit.dart';
import '../bloc/scroll_cubit.dart';
import '../bloc/scroll_state.dart';
import '../bloc/today/todo_bloc.dart';
import '../bloc/today/todo_event.dart';
import '../bloc/today/todo_state.dart';
import '../components/add_todo_panel.dart';
import '../components/no_todo_panel.dart';
import '../components/todo_body_panel.dart';
import '../components/todo_panel.dart';
import '../widgets/add_todo_floating_button.dart';

import '../../domain/entities/todo.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({
    super.key,
  });

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
    _loadTodayTodo();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: _buildTodoFloatingButton(),
        appBar: _buildAppBar(),
        body: _buildTodoBody(),
      ),
    );
  }

  void _loadTodayTodo() {
    context.read<TodoBloc>().add(LoadTodayTodo());
  }

  Widget _buildTodoFloatingButton() {
    return AddTodoFloatingButton(
      onPressed: _showBottomSheet,
    );
  }

  Widget _buildTodoBody() {
    return BlocBuilder<TodoBloc, TodoState>(
        builder: (_, state) => TodoBodyPanel(
            title: const TodayTitle(),
            scrollController: _scrollController,
            child: _buildChildForState(state)));
  }

  Widget _buildChildForState(TodoState state) {
    if (state is TodayLoaded) {
      return _buildTodoPanel(state.todoList);
    } else if (state is NoTodoToday) {
      return _buildNoTodoPanel();
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildTodoPanel(List<Todo> todoList) {
    return TodoPanel(
      onUpdate: _onUpdateTodo,
        toDoList: todoList,
        onRemove: _removeTodoItem,
        onToggle: _toggleTodoStatus);
  }

  Widget _buildNoTodoPanel() {
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
      title: BlocBuilder<ScrollCubit, ScrollState>(
          builder: (context, state) => state is Scrolled
              ? Text(context.getLocaleString(value: 'today'))
              : const Text("")),
    );
  }

  void _scrollListener() {
    final scrollState = context.read<ScrollCubit>();

    scrollState.onScroll(_scrollController.position.pixels);
  }

  void _toggleTodoStatus(Todo todo) async {
    context.read<TodoBloc>().add(ToggleTodoCompletion(todo.id));
  }

  void _removeTodoItem(Todo todo) async {
    context.read<TodoBloc>().add(RemoveTodoEvent(removedTodo: todo));
  }

  void _onCreateTodo(Todo todo) {
    debugPrint(todo.deadline?.toIso8601String());

    if (todo.deadline != null) {
      NotificationHelper.scheduleNotification(todo: todo);
    }
    context.read<TodoBloc>().add(AddTodoEvent(newTodo: todo));
  }

  void _onUpdateTodo(Todo todo) {
    context.read<TodoBloc>().add(UpdateTodoEvent(todo: todo));
  }
}
