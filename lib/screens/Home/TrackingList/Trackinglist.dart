import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:i_tour/logic/firebase_auth.dart';

class TrackingList extends StatefulWidget {
  const TrackingList({super.key});

  @override
  State<TrackingList> createState() => _TrackingListState();
}

class _TrackingListState extends State<TrackingList> {
  final Stream<QuerySnapshot> _trackingStream =
      FirebaseFirestore.instance.collection("User").snapshots();
  final List _todoList = [];
  // text field
  final TextEditingController _textFieldController = TextEditingController();
  // void _addTodoItem(var element) {
  //   //  a set state will notify the app that the state has changed
  //   setState(() {
  //     _todoList.add(element);
  //   });
  //   _textFieldController.clear();
  // }

  Widget _buildTrackPerson(var element, BuildContext context) {
    return StreamBuilder(
      stream: element.snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).copyWith().size.height * 0.3,
                // left: MediaQuery.of(context).copyWith().size.width * 0.5
              ),
              child: const SpinKitFoldingCube(
                color: Colors.blue,
                size: 80,
                // duration: Duration(milliseconds: 1000),
              ));
        }
        if (!snapshot.hasData || snapshot.data!.data().isEmpty) {
          return const SizedBox();
        }
        // print(snapshot.data!.data()['auth_id']??"");
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
                    snapshot.data!.data()['email']??'',
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
      },
    );
  }

  Future _displayDialog(BuildContext context) async {
    // alter the app state to show a dialog
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('People to share tour with'),
            content: TextField(
              controller: _textFieldController,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  const InputDecoration(hintText: 'Enter email for user'),
            ),
            actions: <Widget>[
              // add button
              TextButton(
                child: const Text('ADD'),
                onPressed: () {
                  Navigator.of(context).pop();
                  // _addTodoItem(_textFieldController.text);
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

  List<Widget> _getItems(BuildContext context, var data) {
    final List<Widget> _todoWidgets = <Widget>[];
    for (var element in data) {
      _todoWidgets.add(_buildTrackPerson(element, context));
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
                      "Remember to add people you want to share your tour with."
                          .toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 15),
                    ))
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _trackingStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).copyWith().size.height * 0.3,
                      // left: MediaQuery.of(context).copyWith().size.width * 0.5
                    ),
                    child: const SpinKitFoldingCube(
                      color: Colors.blue,
                      size: 80,
                      // duration: Duration(milliseconds: 1000),
                    ));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const SizedBox();
              }
              final document = snapshot.data!.docs.firstWhere(
                  (element) => element['auth_id'] == Auth().currentUser!.uid);
              // print(document['monitor'][0]);
              return Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).copyWith().size.height * 0.3,
                    bottom:
                        MediaQuery.of(context).copyWith().size.height * 0.1),
                child:
                    ListView(children: _getItems(context, document['monitor'])),
              );
            },
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
