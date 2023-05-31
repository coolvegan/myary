import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appwrite_test/constants.dart' as constants;
import 'package:appwrite_test/model/todo_dto.dart';
import 'package:appwrite_test/services/auth.dart';
import '../backend.dart';

class TodosService {
  final Databases _databases = Databases(Backend.instance.client);
  var latest_created_todo_show_first = false;
  Future<List<TodoDto>> fetch() async {
    User user = await AuthService().getUserId();
    final documentList = await _databases.listDocuments(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.appwriteCollectionId,
        queries: [Query.equal('userId', user.$id)]);
    return documentList.documents.map((e) => TodoDto.fromMap(e.data)).toList();
  }

  Future<List<TodoDto>> fetchCompletedTodos() async {
    User user = await AuthService().getUserId();
    final documentList = await _databases.listDocuments(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.appwriteCollectionId,
        queries: [
          Query.equal('isComplete', true),
          Query.equal('userId', user.$id),
          latest_created_todo_show_first
              ? Query.orderDesc('\$createdAt')
              : Query.orderAsc('\$createdAt'),
        ]);
    return documentList.documents.map((e) => TodoDto.fromMap(e.data)).toList();
  }

  Future<List<TodoDto>> fetchOpenTodos() async {
    User user = await AuthService().getUserId();
    final documentList = await _databases.listDocuments(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.appwriteCollectionId,
        queries: [
          Query.equal('isComplete', false),
          Query.equal('userId', user.$id),
          latest_created_todo_show_first
              ? Query.orderDesc('\$createdAt')
              : Query.orderAsc('\$createdAt'),
        ]);
    return documentList.documents.map((e) => TodoDto.fromMap(e.data)).toList();
  }

  Future<TodoDto> create(
      {required String content, int numberUntilReady = 1}) async {
    User user = await AuthService().getUserId();
    final document = await _databases.createDocument(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.appwriteCollectionId,
      documentId: ID.unique(),
      data: {
        "content": content,
        "isComplete": false,
        "userId": user.$id,
        "numberOfExecution": 0,
        "numberUntilReady": numberUntilReady
      },
    );

    return TodoDto.fromMap(document.data);
  }

  Future<TodoDto> update({required TodoDto todo}) async {
    final document = await _databases.updateDocument(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.appwriteCollectionId,
      documentId: todo.id,
      data: todo.toMap(),
    );

    return TodoDto.fromMap(document.data);
  }

  Future<void> delete({required String id}) async {
    return _databases.deleteDocument(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.appwriteCollectionId,
      documentId: id,
    );
  }
}
