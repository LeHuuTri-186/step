import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:step/features/home/presentation/bloc/search/search_bloc.dart';
import 'package:step/features/home/presentation/widgets/search_bar.dart';
import '../../../../core/utils/notification_helper.dart';
import '../../../../extensions/app_localization_string_builder.dart';
import '../bloc/flower_display_cubit.dart';
import '../bloc/scroll_cubit.dart';
import '../bloc/search/search_event.dart';
import '../bloc/search/search_state.dart';
import '../components/add_todo_panel.dart';
import '../components/no_todo_panel.dart';
import '../components/todo_body_panel.dart';
import '../components/todo_panel.dart';
import '../widgets/add_todo_floating_button.dart';

import '../../domain/entities/todo.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);

    context.read<SearchBloc>().add(SearchTodos());
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


  Widget _buildTodoFloatingButton() {
    return AddTodoFloatingButton(
      onPressed: _showBottomSheet,
    );
  }

  Widget _buildTodoBody() {
    return BlocBuilder<SearchBloc, SearchState>(
        builder: (_, state) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: TodoSearchBar(onChanged: _onSearchChanged),
                ),
                const Divider(),
                Expanded(
                  child: TodoBodyPanel(
                      scrollController: _scrollController,
                      child: _buildChildForState(state)),
                ),
              ],
            ));
  }

  Widget _buildChildForState(SearchState state) {
    if (state is Searched) {
      return _buildTodoPanel(state.todoList);
    } else if (state is NoTodoFound) {
      return _buildNoTodoPanel();
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildTodoPanel(List<Todo> todoList) {
    return TodoPanel(
        toDoList: todoList,
        onRemove: _removeTodoItem,
        onToggle: _toggleTodoStatus,
        onUpdate: _onUpdateTodo,);
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
      title: Text(
        context.getLocaleString(
          value: 'search',
        ),
        style: Theme.of(context).textTheme.displayMedium,
      ),
      centerTitle: false,
    );
  }

  void _onSearchChanged(String query) {
    context.read<SearchBloc>().add(SearchTodos(title: query));
  }

  void _scrollListener() {
    final scrollState = context.read<ScrollCubit>();

    scrollState.onScroll(_scrollController.position.pixels);
  }

  void _toggleTodoStatus(Todo todo) async {
    context.read<SearchBloc>().add(ToggleTodoCompletion(todo.id));
  }

  void _removeTodoItem(Todo todo) async {
    context.read<SearchBloc>().add(RemoveTodoEvent(removedTodo: todo));
  }

  void _onCreateTodo(Todo todo) {
    debugPrint(todo.deadline?.toIso8601String());

    if (todo.deadline != null) {
      NotificationHelper.scheduleNotification(todo: todo);
    }
    context.read<SearchBloc>().add(AddTodoEvent(newTodo: todo));
  }

  void _onUpdateTodo(Todo todo) {
    context.read<SearchBloc>().add(UpdateTodoEvent(todo: todo));
  }
}
