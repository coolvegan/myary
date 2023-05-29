import 'dart:convert';

import 'package:appwrite_test/constants.dart' as constants;
import 'package:appwrite/models.dart';
import 'package:appwrite_test/encryption.dart';
import 'package:appwrite_test/show_todos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:appwrite_test/services/auth.dart';

import '../model/userdata.dart';
import '../state.dart';

class LoginWidget extends StatefulWidget {
  final String title;
  const LoginWidget({super.key, required this.title});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  UserData? settings;
  User? user = null;
  AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  gotoHomePage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ShowTodos()));
  }

  Future<void> saveUsernameToSharedPref(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(constants.sharedPrefUserdataKey, data);
  }

  Future<String?> loadData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(constants.sharedPrefUserdataKey);
  }

  loadsharedPrefsStrings() async {
    String? json;
    json = await loadData(constants.sharedPrefUserdataKey);
    if (json == null) {
      return;
    }
    settings = UserData.fromJson(jsonDecode(json));
    if (settings?.username != null) {
      emailController.text = decrypt(settings!.username, constants.securityKey);
    }
    if (settings?.password != null) {
      passwordController.text =
          decrypt(settings!.password, constants.securityKey);
    }
  }

  @override
  void initState() {
    super.initState();
    loadsharedPrefsStrings();
    if (user != null) {
      gotoHomePage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = Provider.of<SessionState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Email"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (sessionState.isLoggedIn) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Bereits eingelogged.')),
                        );
                        gotoHomePage(context);
                        return;
                      }

                      var message = "";
                      try {
                        user = await authService.login(
                            email: emailController.text,
                            password: passwordController.text);
                        sessionState.login();

                        UserData settings = UserData(
                            username: encrypt(
                                emailController.text, constants.securityKey),
                            password: encrypt(passwordController.text,
                                constants.securityKey));
                        saveUsernameToSharedPref(jsonEncode(settings.toJson()));
                        gotoHomePage(context);
                      } catch (e) {
                        if (e.toString().contains("general_argument_invalid") &&
                            e.toString().contains("password")) {
                          message = "Das Passwort ist nicht korrekt.";
                        } else if (e
                            .toString()
                            .contains("general_rate_limit_exceeded")) {
                          message =
                              "Zuviele kurzfristige Einwahlversuche. Bitte probiere es später nocheinmal.";
                        } else if (e
                                .toString()
                                .contains("general_argument_invalid") &&
                            e.toString().contains("email")) {
                          message =
                              "Sie müssen eine gültige Email Adresse eingeben.";
                        } else {
                          message = "Ein unerwarteter Fehler ist aufgetreten.";
                        }
                        sessionState.logout();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message)),
                        );
                      }
                    },
                    child: Text(constants.textLogin),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
