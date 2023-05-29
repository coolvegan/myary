import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'widgets/login_widget.dart';
import 'state.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeDateFormatting('de_DE', null).then((_) {
    runApp(MyTodos());
  });
}

class MyTodos extends StatelessWidget {
  const MyTodos({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SessionState(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: getTheme(),
          home: const LoginWidget(
            title: "Login",
          ),
        ));
  }
}
