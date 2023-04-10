import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TrackingList extends StatefulWidget {
  const TrackingList({super.key});

  @override
  State<TrackingList> createState() => _TrackingListState();
}

class _TrackingListState extends State<TrackingList> {
  final List<String> _todoList = <String>[];
  // text field
  final TextEditingController _textFieldController = TextEditingController();
  void _addTodoItem(String title) {
    //  a set state will notify the app that the state has changed
    setState(() {
      _todoList.add(title);
    });
    _textFieldController.clear();
  }

  Widget _buildTrackPerson(String title, BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: MediaQuery.of(context).copyWith().size.width * 0.9,
      height: MediaQuery.of(context).copyWith().size.height * 0.1,
      decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: Offset(2, 5),
                color: Color.fromARGB(255, 202, 197, 197),
                blurRadius: 0.1,
                spreadRadius: 0.4)
          ],
          color: Color.fromARGB(255, 255, 252, 255),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // SizedBox(width: MediaQuery.of(context).copyWith().size.width*0.01,),
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).copyWith().size.width * 0.05),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset(
                "assets/pinPeople.png",
                width: MediaQuery.of(context).copyWith().size.width * 1,
              ),
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).copyWith().size.width * 0.6,
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              )),
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).copyWith().size.width * 0.05),
            child: GestureDetector(
              onTap: () {
                print("pressed");
              },
              child: const Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future _displayDialog(BuildContext context) async {
    // alter the app state to show a dialog
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a task to your list'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: 'Enter task here'),
            ),
            actions: <Widget>[
              // add button
              TextButton(
                child: const Text('ADD'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _addTodoItem(_textFieldController.text);
                },
              ),
              // cancel button
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  List<Widget> _getItems(BuildContext context) {
    final List<Widget> _todoWidgets = <Widget>[];
    for (String title in _todoList) {
      _todoWidgets.add(_buildTrackPerson(title, context));
    }
    return _todoWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).copyWith().size.width,
            height: MediaQuery.of(context).copyWith().size.height * 0.4,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color.fromARGB(255, 101, 185, 185),
                      Color.fromARGB(255, 53, 142, 187),
                      Color.fromARGB(255, 61, 140, 177)
                    ]),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset(
                  "assets/loc.svg",
                  width: MediaQuery.of(context).copyWith().size.width * 0.3,
                ),
                SizedBox(
                    width: MediaQuery.of(context).copyWith().size.width * 0.4,
                    child: Text(
                      "Remember to add people you want to share your tour with.".toUpperCase(),
                      style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w900,fontSize: 15),
                    ))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).copyWith().size.height * 0.3,
                bottom: MediaQuery.of(context).copyWith().size.height * 0.1),
            child: ListView(children: _getItems(context)),
          ),
        ],
      ),
      // add items to the to-do list
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 48, 125, 145),
          onPressed: () => _displayDialog(context),
          tooltip: 'Add',
          child: const Icon(Icons.add)),
    );
  }
}
