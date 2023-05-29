import 'package:flutter/material.dart';

import 'widgets/login_widget.dart';

SnackBar createErrorSnackBar(String? content) {
  return SnackBar(
    backgroundColor: Colors.red[900],
    content: Text(content ?? 'An error occurred'),
  );
}

class Goto {
  static LoginScreen(BuildContext context) {
    Future.microtask(() => {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const LoginWidget(
                        title: 'Login',
                      )))
        });
  }
}
