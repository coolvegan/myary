import 'package:appwrite_test/model/happiness_dto.dart';
import 'package:appwrite_test/services/happiness.dart';
import 'package:appwrite_test/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HappynessDiaryEntryWidget extends StatefulWidget {
  HappinessDto happynessEntry;

  HappynessDiaryEntryWidget({super.key, required this.happynessEntry});

  @override
  State<HappynessDiaryEntryWidget> createState() =>
      _HappynessDiaryEntryWidgetState();
}

class _HappynessDiaryEntryWidgetState extends State<HappynessDiaryEntryWidget> {
  HappinessDto? last;
  HappynessService happynessservice = HappynessService();

  updateHappynessEntry() {
    happynessservice.update(happiness: widget.happynessEntry);
  }

  deleteTodoEntry() {
    happynessservice.delete(id: widget.happynessEntry.id);
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
                onHorizontalDragEnd: (details) {
                  _displayTodoDeleteDialog(context, widget.happynessEntry.text);
                },
                child: InkWell(
                  onTap: () {
                    updateHappynessEntry();
                  },
                  onLongPress: () {
                    _displayTextInputDialog(
                        context, widget.happynessEntry.text);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        constants.textDateHappyness +
                            DateFormat.yMMMd('de_DE')
                                .format(widget.happynessEntry.updatedAt!) +
                            " um " +
                            DateFormat.jms('de_DE')
                                .format(widget.happynessEntry.updatedAt!),
                        style: TextStyle(fontSize: 9),
                      ),
                      Flexible(
                        child: Text(
                          widget.happynessEntry.text,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
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
            title: const Text("Happyness Entry ändern"),
            content: TextFormField(
              initialValue: text,
              onChanged: (value) {
                widget.happynessEntry.text = value;
              },
              decoration: InputDecoration(hintText: text),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text(constants.textUpdateHappynessDiary),
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
                  updateHappynessEntry();
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
            title: const Text("Happyness Entry löschen?"),
            content: TextFormField(
              initialValue: text,
              onChanged: (value) {
                widget.happynessEntry.text = value;
              },
              decoration: InputDecoration(hintText: text),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('Nein'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('Ja'),
                onPressed: () {
                  deleteTodoEntry();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
