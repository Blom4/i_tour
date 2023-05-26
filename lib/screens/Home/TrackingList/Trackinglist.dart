import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:i_tour/constants/constants.dart';
import 'package:i_tour/logic/firebase_auth.dart';
import 'package:i_tour/screens/Home/TrackingList/Logic/Tracking_logic.dart';

class TrackingList extends StatefulWidget {
  const TrackingList({super.key});

  @override
  State<TrackingList> createState() => _TrackingListState();
}

class _TrackingListState extends State<TrackingList> {
  final Stream<QuerySnapshot> _trackingStream =
      FirebaseFirestore.instance.collection("User").snapshots();
  final List _todoList = [];
  bool isLoading = false;
  final loader = const SpinKitFoldingCube(
    color: Color.fromARGB(255, 35, 104, 136),
    size: 150,
    // duration: Duration(milliseconds: 1000),
  );
  // text field
  final TextEditingController _textFieldController = TextEditingController();

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
                    snapshot.data!.data()['email'] ?? '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  )),
              Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).copyWith().size.width * 0.05),
                child: GestureDetector(
                  onTap: () async {
                    await TrackingLogic.removePerson(
                        user: snapshot.data!.data()['email'] ?? '');
                    // print("pressed");
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
          String error = "";
          bool isFound = false;

          return AlertDialog(
            title: const Text('People to share tour with'),
            content: SizedBox(
              height: MediaQuery.of(context).copyWith().size.height * 0.09,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return ListView(
                    children: [
                      TextField(
                        onChanged: (value) async {
                          // print(value);

                          if (Auth().currentUser!.email!.toLowerCase() !=
                              value.toLowerCase()) {
                            // search for current auth user
                            var results = await firebaseInstance
                                .collection("User")
                                .where("email",
                                    isEqualTo: value.toString().toLowerCase())
                                .get();
                            // print(results.docs.isEmpty);
                            if (results.docs.isEmpty) {
                              setState(() {
                                error = "user does not exist";
                              });
                            } else {
                              //search for current auth user then check monitor users if they exist
                              var res = await firebaseInstance
                                  .collection("User")
                                  .where("email",
                                      isEqualTo: Auth()
                                          .currentUser!
                                          .email!
                                          .toLowerCase())
                                  .get();
                              var data;

                              for (var element
                                  in res.docs.first.data()['monitor'] ?? []) {
                                data = await element.get();
                                if (results.docs.first.data()['email'] ==
                                    data.data()['email']) {
                                  isFound = true;
                                  break;
                                }
                              }

                              if (isFound) {
                                setState(() {
                                  isFound = true;
                                  error = "You have added user";
                                });
                              } else {
                                setState(() {
                                  isFound = false;
                                  error = "";
                                });
                              }
                            }
                          } else {
                            setState(() {
                              isFound = true;
                              error = "you cannot add your account";
                            });
                          }
                        },
                        controller: _textFieldController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            hintText: 'Enter email for user'),
                      ),
                      if (error.isNotEmpty)
                        Text(
                          error,
                          style: const TextStyle(color: Colors.red),
                        )
                    ],
                  );
                },
              ),
            ),
            actions: <Widget>[
              // add button
              TextButton(
                onPressed: isLoading
                    ? () {}
                    : () async {
                        // print(isFound);
                        setState(() {
                          isLoading = true;
                        });
                        await TrackingLogic.addTrackingUser(
                            user:
                                _textFieldController.text.trim().toLowerCase(),
                            isFound: isFound);
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.of(context).pop();
                      },
                child: isLoading ? const Text("waiting") : const Text('ADD'),
              ),
              // cancel button
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  List<Widget> _getItems(BuildContext context, var data) {
    final List<Widget> todoWidgets = <Widget>[];
    for (var element in data) {
      todoWidgets.add(_buildTrackPerson(element, context));
    }
    return todoWidgets;
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
                child: ListView(
                    children: _getItems(context, document['monitor'] ?? [])),
              );
            },
          ),
        ],
      ),
      // add items to the to-do list
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 48, 125, 145),
          onPressed: () => _displayDialog(context),
          tooltip: 'Add',
          child: const Icon(Icons.add)),
    );
  }
}
