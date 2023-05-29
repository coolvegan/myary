import 'package:appwrite_test/show_todos.dart';
import 'package:flutter/material.dart';
import 'package:appwrite_test/constants.dart';
import '../show_happyness_diary.dart';

class BottomAppBarWidget extends StatelessWidget {
  showSnackbarNotImplemented(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Diese Methode ist nicht implementiert.')),
    );
  }

  final FloatingActionButtonLocation fabLocation =
      FloatingActionButtonLocation.endDocked;
  final NotchedShape shape = const CircularNotchedRectangle();

  static final List<FloatingActionButtonLocation> centerLocations =
      <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  BottomAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: shape,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          children: <Widget>[
            IconButton(
              tooltip: 'Open navigation menu',
              icon: const Icon(Icons.menu),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                showSnackbarNotImplemented(context);
              },
            ),
            if (centerLocations.contains(fabLocation)) const Spacer(),
            IconButton(
              tooltip: 'Search',
              icon: const Icon(Icons.build_circle_rounded),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ShowTodos()));
                showSnackbarNotImplemented(context);
              },
            ),
            IconButton(
              tooltip: 'Favorite',
              icon: const Icon(Icons.favorite),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ShowHappynessDiary()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
