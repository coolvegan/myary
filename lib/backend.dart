import 'package:appwrite/appwrite.dart';
import 'package:appwrite_test/constants.dart' as constants;

import 'constants.dart';

class Backend {
  static final Backend instance = Backend._internal();
  static const String endpoint = constants.appwriteEndpoint;
  static const String projectId = constants.appwriteProjectId;
  static const String databaseid = constants.appwriteDatabaseId;
  static const String todocollection = constants.appwriteCollectionId;
  static const String happynessdiarycolleciton =
      constants.appwriteCollectionHappyDiary;

  late final Client client;
  late Account account;
  late Realtime realtime;
  late RealtimeSubscription subscription;

  //Damit stellen wir sicher, dass wir eine Instanz und nur eine Instanz erzeugen.
  factory Backend() {
    return instance;
  }

  //Anmelden als Beobachter um keine Änderungen zu verpassen.
  subscribeTodos(Client c) {
    final realtime = Realtime(c);
    subscription = realtime.subscribe(
        ['databases.$databaseid.collections.$todocollection.documents']);
    return subscription;
  }

  subscribeHappynessDiaries(Client c) {
    final realtime = Realtime(c);
    subscription = realtime.subscribe([
      'databases.$databaseid.collections.$happynessdiarycolleciton.documents'
    ]);
    return subscription;
  }

  Future<bool> login(String email, String password) async {
    try {
      account.createEmailSession(email: email, password: password);
    } catch (error) {
      return false;
    }
    return true;
  }

  logout() {
    account.deleteSession(sessionId: 'current');
  }

  //Singleton
  Backend._internal() {
    client = Client().setEndpoint(endpoint).setProject(projectId);
  }
}
