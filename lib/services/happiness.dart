import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appwrite_test/constants.dart' as constants;
import 'package:appwrite_test/model/happiness_dto.dart';
import 'package:appwrite_test/model/todo_dto.dart';
import 'package:appwrite_test/services/auth.dart';
import '../backend.dart';

class HappynessService {
  final Databases _databases = Databases(Backend.instance.client);
  var latest_created_happiness_entry_show_first = true;
  Future<List<HappinessDto>> fetch() async {
    User user = await AuthService().getUserId();
    final documentList = await _databases.listDocuments(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.appwriteCollectionHappyDiary,
        queries: [
          Query.equal('userId', user.$id),
          latest_created_happiness_entry_show_first
              ? Query.orderDesc('\$createdAt')
              : Query.orderAsc('\$createdAt'),
        ]);
    return documentList.documents
        .map((e) => HappinessDto.fromMap(e.data))
        .toList();
  }

  Future<List<HappinessDto>> fetchCompletedTodos() async {
    User user = await AuthService().getUserId();
    final documentList = await _databases.listDocuments(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.appwriteCollectionId,
        queries: [
          Query.equal('userId', user.$id),
          latest_created_happiness_entry_show_first
              ? Query.orderDesc('\$createdAt')
              : Query.orderAsc('\$createdAt'),
        ]);
    return documentList.documents
        .map((e) => HappinessDto.fromMap(e.data))
        .toList();
  }

  Future<List<HappinessDto>> fetchOpenTodos() async {
    User user = await AuthService().getUserId();
    final documentList = await _databases.listDocuments(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.appwriteCollectionHappyDiary,
        queries: [
          Query.equal('userId', user.$id),
          latest_created_happiness_entry_show_first
              ? Query.orderDesc('\$createdAt')
              : Query.orderAsc('\$createdAt'),
        ]);
    return documentList.documents
        .map((e) => HappinessDto.fromMap(e.data))
        .toList();
  }

  Future<HappinessDto> create({required String text}) async {
    User user = await AuthService().getUserId();
    final document = await _databases.createDocument(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.appwriteCollectionHappyDiary,
      documentId: ID.unique(),
      data: {"text": text, "userId": user.$id},
    );

    return HappinessDto.fromMap(document.data);
  }

  Future<HappinessDto> update({required HappinessDto happiness}) async {
    final document = await _databases.updateDocument(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.appwriteCollectionHappyDiary,
      documentId: happiness.id,
      data: happiness.toMap(),
    );

    return HappinessDto.fromMap(document.data);
  }

  Future<void> delete({required String id}) async {
    return _databases.deleteDocument(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.appwriteCollectionHappyDiary,
      documentId: id,
    );
  }
}
