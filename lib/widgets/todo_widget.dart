import 'package:appwrite_test/services/happiness.dart';
import 'package:appwrite_test/services/todos.dart';
import 'package:flutter/material.dart';
import '../model/todo_dto.dart';
import 'package:appwrite_test/constants.dart' as constants;

class TodoWidget extends StatefulWidget {
  TodoDto todo;

  TodoWidget({super.key, required this.todo});

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  TodoDto? last;
  TodosService todosservice = TodosService();
  changeCheckbox(value) {
    setState(() {
      widget.todo.isComplete = value!;
    });
  }

  updateTodoEntry() {
    todosservice.update(todo: widget.todo);
  }

  deleteTodoEntry() {
    todosservice.delete(id: widget.todo.id);
  }

  moveToHappynessDiary() {
    var text = widget.todo.content;
    HappynessService happynessService = HappynessService();
    happynessService.create(text: text);
    todosservice.delete(id: widget.todo.id);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, contraints) {
      return Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 0,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                onDoubleTap: () => {print("double tap")},
                onHorizontalDragEnd: (details) {
                  _displayTodoDeleteDialog(context, widget.todo.content);
                },
                child: InkWell(
                  onTap: () {
                    changeCheckbox(!widget.todo.isComplete);
                    updateTodoEntry();
                  },
                  onLongPress: () {
                    _displayTextInputDialog(context, widget.todo.content);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          widget.todo.content,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Checkbox(
                          value: widget.todo.isComplete,
                          onChanged: (bool? value) {
                            changeCheckbox(value);
                            updateTodoEntry();
                          })
                    ],
                  ),
                ),
              ),
            ],
          ));
    });
  }

  Future<void> _displayTextInputDialog(
      BuildContext context, String text) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(constants.textUpdateTodo),
            content: TextFormField(
              initialValue: text,
              onChanged: (value) {
                widget.todo.content = value;
              },
              autofocus: true,
              decoration: InputDecoration(hintText: text),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text(constants.textCancel),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text(constants.textOkay),
                onPressed: () {
                  updateTodoEntry();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<void> _displayTodoDeleteDialog(
      BuildContext context, String text) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(constants.textDeleteTodo),
            content: TextFormField(
              initialValue: text,
              onChanged: (value) {
                widget.todo.content = value;
              },
              decoration: InputDecoration(hintText: text),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('Löschen'),
                onPressed: () {
                  deleteTodoEntry();
                  Navigator.pop(context);
                },
              ),
              MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('Abbruch'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('Ins Glückstagebuch'),
                onPressed: () {
                  moveToHappynessDiary();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
