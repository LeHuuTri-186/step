import 'package:flutter/cupertino.dart';
import 'package:step/extensions/app_localization_string_builder.dart';

import '../core/utils/date_of_month_icons.dart';

extension BottomNavItemBuilders on BuildContext {
  BottomNavigationBarItem buildBrowseBottomNavItem({bool isSelected = false}) =>
      BottomNavigationBarItem(
        icon: _buildBrowseIcon(isSelected: isSelected),
        label: getLocaleString(value: 'browse'),
      );

  Icon _buildBrowseIcon({bool isSelected = false}) => isSelected
      ? const Icon(DateOfMonthIconsUtil.browse_selected)
      : const Icon(DateOfMonthIconsUtil.browse);

  BottomNavigationBarItem buildSearchBottomNavItem({bool isSelected = false}) =>
      BottomNavigationBarItem(
        icon: _buildSearchIcon(isSelected: isSelected),
        label: getLocaleString(value: 'search'),
      );

  Icon _buildSearchIcon({bool isSelected = false}) => isSelected
      ? const Icon(DateOfMonthIconsUtil.search_selected)
      : const Icon(DateOfMonthIconsUtil.search);

  BottomNavigationBarItem buildUpcomingBottomNavItem(
          {bool isSelected = false}) =>
      BottomNavigationBarItem(
        icon: _buildUpcomingIcon(isSelected: isSelected),
        label: getLocaleString(value: 'upcoming'),
      );

  Icon _buildUpcomingIcon({bool isSelected = false}) => isSelected
      ? const Icon(DateOfMonthIconsUtil.upcoming_selected)
      : const Icon(DateOfMonthIconsUtil.upcoming);

  Icon _buildTodayIcon({bool isSelected = false, required int currentDay}) =>
      isSelected
          ? Icon(DateOfMonthIconsUtil.dateToSelectedIconMapper[currentDay])
          : Icon(DateOfMonthIconsUtil.dateToIconMapper[currentDay]);

  BottomNavigationBarItem buildTodayBottomNavItem(
          {bool isSelected = false, required int currentDay}) =>
      BottomNavigationBarItem(
        icon: _buildTodayIcon(isSelected: isSelected, currentDay: currentDay),
        label: getLocaleString(value: 'today'),
      );
}
