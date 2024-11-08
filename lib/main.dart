import 'package:flutter/material.dart';
import 'package:step/features/home/presentation/home_screen.dart';
import 'package:step/features/step_app.dart';

import 'core/di/service_locator.dart';
import 'core/utils/notification_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencyInjection();
  await NotificationHelper.init();
  runApp(const StepApp());
}