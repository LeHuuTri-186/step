import 'package:flutter/material.dart';
import 'package:step/features/step_app.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'core/di/service_locator.dart';
import 'core/utils/notification_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.init();
  await setupDependencyInjection();
  tz.initializeTimeZones();

  runApp(const StepApp());
}