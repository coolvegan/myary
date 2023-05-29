import 'package:appwrite/appwrite.dart';
import 'package:appwrite_test/model/happiness_dto.dart';
import 'package:appwrite_test/widgets/happyness_diary_entry_widget.dart';
import 'package:flutter/material.dart';
import 'package:appwrite_test/constants.dart' as constants;
import 'backend.dart';
import 'services/happiness.dart';
import 'theme.dart';
import 'widgets/appbar_widget.dart';

class ShowHappynessDiary extends StatefulWidget {
  const ShowHappynessDiary({super.key});

  @override
  State<ShowHappynessDiary> createState() => _ShowHappynessDiaryState();
}

class _ShowHappynessDiaryState extends State<ShowHappynessDiary> {
  HappynessService happynessService = HappynessService();
  List<HappinessDto> happyness = [];
  RealtimeSubscription? subscription;
  Backend backend = Backend();
  void fetchHappynessEntries() async {
    var h = await happynessService.fetch();
    setState(() {
      happyness = h;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchHappynessEntries();
    subscription = backend.subscribeHappynessDiaries(backend.client);
    subscription!.stream.listen((data) {
      fetchHappynessEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: getTheme(),
        home: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              constants.textAppHappyDiary,
              style: TextStyle(letterSpacing: 14),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 88),
            children: [
              SwitchListTile(
                title: Text(""),
                value: true,
                onChanged: (bool value) {},
              ),
              SizedBox(
                  height: 800,
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: happyness.length,
                      itemBuilder: (BuildContext context, int index) {
                        return HappynessDiaryEntryWidget(
                            happynessEntry: happyness[index]);
                      })),
            ],
          ),
          bottomNavigationBar: BottomAppBarWidget(),
          floatingActionButton: FloatingActionButton.extended(
              label: const Text(constants.textNewHappyDiaryEntry),
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
}

Future<String?> _showTextInputDialog(BuildContext context) async {
  HappynessService happynessService = HappynessService();
  var happyDiaryText = "";
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(constants.textCreateHappyDiary),
          content: TextFormField(
            autofocus: true,
            initialValue: "",
            onChanged: (value) {
              happyDiaryText = value;
            },
            decoration:
                const InputDecoration(hintText: constants.textHappyDlgHint),
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
                happynessService.create(text: happyDiaryText);
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}
