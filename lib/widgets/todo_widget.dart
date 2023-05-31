// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:appwrite_test/constants.dart' as constants;
import 'package:appwrite_test/services/happiness.dart';
import 'package:appwrite_test/services/todos.dart';
import '../model/todo_dto.dart';

class TodoWidget extends StatefulWidget {
  TodoDto todo;

  TodoWidget({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  String selectedValue = "1";
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
    var prefix = "";
    var text = widget.todo.content;
    if (widget.todo.numberOfExecution != null &&
        widget.todo.numberUntilReady != null) {
      prefix = widget.todo.numberOfExecution!.toString() +
          " / " +
          widget.todo.numberUntilReady!.toString() +
          " ";
    }
    HappynessService happynessService = HappynessService();
    happynessService.create(text: prefix != "" ? prefix + " " : "" + text);
    todosservice.delete(id: widget.todo.id);
  }

  void todoDoneHelper(TodoDto todoDto) {
    if (todoDto.numberOfExecution != null && todoDto.numberUntilReady != null) {
      if (todoDto.isComplete &&
          todoDto.numberOfExecution! == todoDto.numberUntilReady!) {
        todoDto.numberOfExecution = todoDto.numberOfExecution! - 1;
        todoDto.isComplete = false;
      } else if (todoDto.numberOfExecution! < todoDto.numberUntilReady!) {
        todoDto.numberOfExecution = todoDto.numberOfExecution! + 1;
        if (todoDto.numberOfExecution! == todoDto.numberUntilReady!) {
          todoDto.isComplete = true;
        }
      } else {
        //Für den Sonderfall das beide Todos gleich sind und isComplete immernoch false ist.
        if (todoDto.numberOfExecution! == todoDto.numberUntilReady!) {
          todoDto.isComplete = true;
        }
      }
    }

    updateTodoEntry();
  }

  String widgetFormatHelper(TodoDto todoDto) {
    if (todoDto.numberOfExecution != null &&
        todoDto.numberUntilReady != null &&
        todoDto.numberUntilReady! > 1) {
      int repetitionLeft =
          todoDto.numberUntilReady! - todoDto.numberOfExecution!;

      String result = todoDto.numberOfExecution!.toString() +
          " / " +
          todoDto.numberUntilReady!.toString() +
          " " +
          todoDto.content;
      return result;
    }
    return todoDto.content;
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
                onDoubleTap: () => {
                  if (widget.todo.numberOfExecution != null &&
                      widget.todo.numberUntilReady != null)
                    {
                      if (widget.todo.numberUntilReady! > 1 &&
                          widget.todo.numberOfExecution! >= 1)
                        {
                          widget.todo.numberOfExecution =
                              widget.todo.numberOfExecution! - 1
                        }
                    }
                },
                onHorizontalDragEnd: (details) {
                  _displayTodoDeleteDialog(context, widget.todo.content);
                },
                child: InkWell(
                  onTap: () {
                    changeCheckbox(widget.todo.isComplete);
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
                          widgetFormatHelper(widget.todo),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Checkbox(
                          value: widget.todo.isComplete,
                          onChanged: (bool? value) {
                            todoDoneHelper(widget.todo);
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
            content: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: text,
                  onChanged: (value) {
                    widget.todo.content = value;
                  },
                  autofocus: true,
                  decoration: InputDecoration(hintText: text),
                ),
                TextFormField(
                  decoration: InputDecoration(
                      suffix: GestureDetector(
                    child: const Text(constants.textTodoUntilFinished),
                  )),
                  initialValue: widget.todo.numberUntilReady.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                ),
              ],
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
                  int? count = int.tryParse(selectedValue);
                  if (widget.todo.numberUntilReady != null) {
                    if (widget.todo.numberUntilReady! < count!) {
                      widget.todo.isComplete = false;
                    }
                  }
                  if (widget.todo.numberOfExecution != null) {
                    if (widget.todo.numberOfExecution! >
                        widget.todo.numberUntilReady!) {
                      widget.todo.numberOfExecution = count! - 1;
                    }
                  }
                  widget.todo.numberUntilReady = count!;
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
