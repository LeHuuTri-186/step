import 'package:step/core/utils/notification_helper.dart';
import 'package:step/features/home/di/home_di.dart';

Future<void> setupDependencyInjection() async {
  await initHome();
}