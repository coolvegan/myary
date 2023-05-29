import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:appwrite_test/backend.dart';

class AuthService {
  static final AuthService _authService = AuthService._internal();
  final Account _account = Account(Backend.instance.client);
  //models.User war in Appwrite 8 models.Account
  Future<models.User> signUp(
      {String? name, required String email, required String password}) async {
    await _account.create(
      userId: ID.unique(),
      email: email,
      password: password,
      name: name,
    );
    return login(email: email, password: password);
  }

  factory AuthService() {
    return _authService;
  }

  Future<models.User> login(
      {required String email, required String password}) async {
    await _account.createEmailSession(
      email: email,
      password: password,
    );
    return _account.get();
  }

  Future<void> logout() {
    return _account.deleteSession(sessionId: 'current');
  }

  Future<models.User> getUserId() {
    return _account.get();
  }

  AuthService._internal();
}
