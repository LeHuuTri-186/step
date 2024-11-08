import 'package:flutter/material.dart';
import 'package:step/extensions/app_localization_string_builder.dart';

class NoTodoPanel extends StatelessWidget {
  final String imagePath;

  const NoTodoPanel({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Center(
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: 275,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
              child: Text(
                context.getLocaleString(value: "noTodoHeader"),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Text(
              context.getLocaleString(value: "noTodoBody"),
              maxLines: 2,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
