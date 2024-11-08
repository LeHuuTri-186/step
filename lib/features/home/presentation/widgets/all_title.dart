import 'package:flutter/material.dart';
import 'package:step/extensions/app_localization_string_builder.dart';

class AllTitle extends StatelessWidget {
  const AllTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Text(context.getLocaleString(value: 'all'),
            style: Theme.of(context).textTheme.displayLarge),
      ),
    );
  }
}
