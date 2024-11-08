import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:step/features/home/presentation/bloc/upcoming/upcoming_event.dart';
import 'package:step/features/home/presentation/widgets/upcoming_title.dart';
import '../../../../core/utils/notification_helper.dart';
import '../../../../extensions/app_localization_string_builder.dart';
import '../bloc/flower_display_cubit.dart';
import '../bloc/scroll_cubit.dart';
import '../bloc/scroll_state.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
    _loadUpcomingTodo();
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
        body: _buildUpcomingBody(),
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
            scrollController: _scrollController,
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
      title: BlocBuilder<ScrollCubit, ScrollState>(
          builder: (context, state) => state is Scrolled
              ? Text(context.getLocaleString(value: 'upcoming'))
              : const Text("")),
    );
  }

  void _scrollListener() {
    final scrollState = context.read<ScrollCubit>();

    scrollState.onScroll(_scrollController.position.pixels);
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
