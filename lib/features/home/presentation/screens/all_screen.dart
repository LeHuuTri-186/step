import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:step/features/home/presentation/bloc/all/all_event.dart';
import 'package:step/features/home/presentation/components/draggable_todo_panel.dart';
import 'package:step/features/home/presentation/widgets/today_title.dart';
import '../../../../core/utils/notification_helper.dart';
import '../../../../extensions/app_localization_string_builder.dart';
import '../bloc/all/all_bloc.dart';
import '../bloc/all/all_state.dart';
import '../bloc/flower_display_cubit.dart';
import '../bloc/scroll_cubit.dart';
import '../bloc/scroll_state.dart';
import '../components/add_todo_panel.dart';
import '../components/no_todo_panel.dart';
import '../components/todo_body_panel.dart';
import '../widgets/add_todo_floating_button.dart';

import '../../domain/entities/todo.dart';
import '../widgets/all_title.dart';

class AllPage extends StatefulWidget {
  const AllPage({
    super.key,
  });

  @override
  State<AllPage> createState() => _AllPageState();
}

class _AllPageState extends State<AllPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
    _loadAllTodo();
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

  void _loadAllTodo() {
    context.read<AllBloc>().add(RefreshAll());
  }

  Widget _buildTodoFloatingButton() {
    return AddTodoFloatingButton(
      onPressed: _showBottomSheet,
    );
  }

  Widget _buildTodoBody() {
    return BlocBuilder<AllBloc, AllState>(
        builder: (_, state) => TodoBodyPanel(
            title: const AllTitle(),
            scrollController: _scrollController,
            child: _buildChildForState(state)));
  }

  Widget _buildChildForState(AllState state) {
    if (state is AllLoaded) {
      return _buildTodoPanel(
        allTodos: state.allTodos,
        todayTodos: state.todayTodos,
        upcomingTodos: state.upcomingTodos,
      );
    } else if (state is NoTodoFound) {
      return _buildNoTodoPanel();
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildTodoPanel(
          {required List<Todo> allTodos,
          required List<Todo> upcomingTodos,
          required List<Todo> todayTodos}) =>
      DraggableTodoPanel(
        onChanged: _onUpdateTodo,
        allTodos: allTodos,
        upcomingTodos: upcomingTodos,
        todayTodos: todayTodos,
        onToggle: _toggleTodoStatus,
        sectionOrder: [
          context.getLocaleString(value: 'today'),
          context.getLocaleString(value: 'upcoming'),
          context.getLocaleString(value: 'all'),
        ],
      );

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
              ? Text(context.getLocaleString(value: 'all'))
              : const Text("")),
    );
  }

  void _scrollListener() {
    final scrollState = context.read<ScrollCubit>();

    scrollState.onScroll(_scrollController.position.pixels);
  }

  void _toggleTodoStatus(Todo todo) async {
    context.read<AllBloc>().add(ToggleTodoCompletion(todo.id));
  }

  void _onCreateTodo(Todo todo) {
    debugPrint(todo.deadline?.toIso8601String());

    if (todo.deadline != null) {
      NotificationHelper.scheduleNotification(todo: todo);
    }
    context.read<AllBloc>().add(AddTodoEvent(newTodo: todo));
  }

  void _onUpdateTodo(Todo todo) {
    context.read<AllBloc>().add(UpdateTodoEvent(todo: todo));
  }
}
