// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appwrite_test/encryption.dart';
import 'package:appwrite_test/model/todo_dto.dart';
import 'package:appwrite_test/model/userdata.dart';
import 'package:appwrite_test/services/auth.dart';
import 'package:appwrite_test/services/todos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appwrite_test/constants.dart' as constants;

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {});
  test('Settings toJson test', () {
    // Erstellen einer Instanz von MeineKlasse mit Beispieldaten
    UserData settings =
        UserData(password: '12345678!§', username: 'todobenutzer');
    // Erwartetes JSON-String-Ergebnis
    String expectedJson = '{"username":"todobenutzer","password":"12345678!§"}';
    // Konvertieren des JSON-Objekts in einen JSON-String
    String actualJson = jsonEncode(settings);
    // Überprüfen, ob der erwartete JSON-String dem tatsächlichen JSON-String entspricht
    expect(actualJson, expectedJson);
  });
  test('Settings toJson test 2', () {
    // Erstellen einer Instanz von MeineKlasse mit Beispieldaten
    UserData settings =
        UserData(password: '12345678!§', username: 'todobenutzer');
    // Erwartetes JSON-String-Ergebnis
    String expectedJson = '{"username":"todobenutzer","password":"12345678!§"}';
    // Konvertieren des JSON-Objekts in einen JSON-String
    String actualJson = jsonEncode(settings);
    // Überprüfen, ob der erwartete JSON-String dem tatsächlichen JSON-String entspricht
    expect(actualJson, expectedJson);
  });

  test('Encryption / Decryption', () {
    //String key = "46G9R6W=r!u6)686M.@5K!#kbZ+-v5)h";
    String key = constants.Constants.securityKey;
    String to_encrypt = "MeinTextÖäü!\$§!#\"§";
    var encrypted = encrypt(to_encrypt, key);
    String decrypted_text = decrypt(encrypted, key);
    expect(decrypted_text, to_encrypt);
  });
  test('Decryption For UTF8 Test', () {
    //String key = "~,8<pNvVKy#sXT<7qwfd+-=La<m(RXT!";
    String key = constants.Constants.securityKey;
    String to_encrypt = "ÆÉÍÑæ  .!2#ý";
    var encrypted = encrypt(to_encrypt, key);
    String decrypted_text = decrypt(encrypted, key);
    expect(decrypted_text, to_encrypt);
  });

  test('Create JWT', () {
    AuthService authService = AuthService();
    Future<User> acc =
        authService.login(email: "marcokittel@web.de", password: "12345678");
  });
}
