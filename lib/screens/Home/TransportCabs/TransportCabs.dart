import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransportCabs extends StatefulWidget {
  const TransportCabs({super.key});

  @override
  State<TransportCabs> createState() => _TransportCabsState();
}

class _TransportCabsState extends State<TransportCabs> {
  final Stream<QuerySnapshot> _carsStream =
      FirebaseFirestore.instance.collection("Tranport").snapshots();
  // final List<String> _todoList = <String>[
  //   "Mamorena cabs",
  //   "Uba cabs official",
  //   "Transport activity",
  //   "Motlokovan",
  // ];
  // text field
  final TextEditingController _textFieldController = TextEditingController();
  // void _addTodoItem(String title) {
  //   //  a set state will notify the app that the state has changed
  //   setState(() {
  //     _todoList.add(title);
  //   });
  //   _textFieldController.clear();
  // }

  Widget _buildCarsItems(String name, String contacts, BuildContext context) {
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              width: MediaQuery.of(context).copyWith().size.width * 0.5,
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              )),
          SizedBox(
              width: MediaQuery.of(context).copyWith().size.width * 0.4,
              child: Text(
                contacts,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }

  List<Widget> _getItems(BuildContext context, var data) {
    final List<Widget> todoWidgets = <Widget>[];
    for (var item in data) {
      todoWidgets.add(_buildCarsItems(item['name'], item['contacts'], context));
    }
    return todoWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).copyWith().size.width,
          height: MediaQuery.of(context).copyWith().size.height * 0.4,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(255, 49, 109, 109),
                    Color.fromARGB(255, 53, 142, 187),
                    Color.fromARGB(255, 87, 158, 180)
                  ]),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                "assets/travel.svg",
                width: MediaQuery.of(context).copyWith().size.width * 0.5,
              ),
              SizedBox(
                  width: MediaQuery.of(context).copyWith().size.width * 0.4,
                  child: Text(
                    "Here are List of Cabs you can use".toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 15),
                  ))
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).copyWith().size.height * 0.3,
              bottom: MediaQuery.of(context).copyWith().size.height * 0.1),
          child: StreamBuilder<QuerySnapshot>(
            stream: _carsStream,
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
              return ListView(
                  children: _getItems(context, snapshot.data!.docs));
            },
          ),
        ),
      ],
    );
  }
}
