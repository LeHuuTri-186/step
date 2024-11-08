import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step/features/home/presentation/screens/all_screen.dart';
import 'package:step/features/home/presentation/screens/search_screen.dart';
import 'package:step/features/home/presentation/screens/today_screen.dart';
import 'package:step/features/home/presentation/screens/upcoming_screen.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';
import 'widgets/bottom_navigation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return _buildView(state);
          },
        ),
        bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return BottomNavigation(
              currentDay: state.currentDate.day,
              selectedIndex: state.selectedIndex,
              onTap: (index) {
                context.read<HomeBloc>().add(IndexChanged(index));
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildView(HomeState state) {
    final pageMap = {
      0: const TodayPage(),
      1: const UpcomingPage(),
      2: const SearchPage(),
      3: const AllPage(),
    };

    return pageMap[state.selectedIndex] ?? const Placeholder();
  }
}
