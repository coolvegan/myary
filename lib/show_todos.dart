// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';

import 'package:appwrite_test/services/todos.dart';
import 'package:appwrite_test/theme.dart';
import 'package:appwrite_test/widgets/todo_widget.dart';
import 'package:appwrite_test/constants.dart' as constants;
import 'package:flutter/rendering.dart';
import 'backend.dart';
import 'model/todo_dto.dart';
import 'widgets/appbar_widget.dart';

class ShowTodos extends StatefulWidget {
  const ShowTodos({
    Key? key,
  }) : super(key: key);

  @override
  State<ShowTodos> createState() => _ShowTodosState();
}

class _ShowTodosState extends State<ShowTodos> {
  bool showOpenTodos = true;
  List<TodoDto> todolist = [];
  Backend backend = Backend();
  TodosService todosService = TodosService();
  RealtimeSubscription? subscription;
  @override
  void initState() {
    super.initState();
    fetchTodo();
    subscription = backend.subscribeTodos(backend.client);
    subscription!.stream.listen((data) {
      fetchTodo();
    });
  }

  fetchTodo() async {
    List<TodoDto> result;
    if (showOpenTodos) {
      result = await todosService.fetchOpenTodos();
    } else {
      result = await todosService.fetchCompletedTodos();
    }
    setState(() {
      todolist = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: getTheme(),
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              constants.textAppTitle,
              style: TextStyle(letterSpacing: 14),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 88),
            children: [
              SwitchListTile(
                title: showOpenTodos == true
                    ? const Text(
                        constants.textOpenTodos,
                        style: TextStyle(letterSpacing: 12),
                      )
                    : const Text(
                        constants.textCompletedTodos,
                        style: TextStyle(letterSpacing: 12),
                      ),
                value: showOpenTodos,
                onChanged: (bool value) {
                  showOpenTodos = value;
                  fetchTodo();
                },
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: todolist.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TodoWidget(todo: todolist[index]);
                      })),
            ],
          ),
          bottomNavigationBar: BottomAppBarWidget(),
          floatingActionButton: FloatingActionButton.extended(
              label: const Text(constants.textNewTodo),
              icon: const Icon(Icons.add),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              onPressed: () {
                _showTextInputDialog(context);
              }),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ));
  }

  Future<String?> _showTextInputDialog(BuildContext context) async {
    var todoText = "";
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(constants.textCreateTodo),
            content: TextFormField(
              autofocus: true,
              initialValue: "",
              onChanged: (value) {
                todoText = value;
              },
              decoration:
                  const InputDecoration(hintText: constants.textTodoDlgHint),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text(constants.textCancel),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text(constants.textOkay),
                onPressed: () {
                  todosService.create(content: todoText);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
