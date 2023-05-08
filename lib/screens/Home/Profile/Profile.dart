import 'package:card_loading/card_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:i_tour/logic/firebase_auth.dart';
import 'package:i_tour/main.dart';
import 'package:i_tour/screens/Home/Profile/components/Background.dart';
import 'package:restart_app/restart_app.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection("User").snapshots();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).copyWith().size.width;
    final height = MediaQuery.of(context).copyWith().size.height;
    return Stack(
      fit: StackFit.expand,
      children: [
        const Background(),
        StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
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
            // print(snapshot.data!.docs.first['full_name']);
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const SizedBox();
            }
            final document = snapshot.data!.docs.firstWhere(
                (element) => element['auth_id'] == Auth().currentUser!.uid);
            //  print(document['full_name']);
            return Container(
              width: width,
              height: height,
              child: ListView(
                children: [
                  Padding(
                      padding:
                          EdgeInsets.only(top: height * 0.25, left: width * 0),
                      child: Container(
                        width: width * 0.5,
                        height: height * 0.2,
                        child: CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(255, 230, 233, 233),
                          child: Icon(
                            Icons.person_rounded,
                            size: width * 0.4,
                            color: const Color.fromARGB(255, 51, 153, 156),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                        icon: const Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 93, 149, 201),
                        ),
                        border: const UnderlineInputBorder(),
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 93, 149, 201),
                        ),
                        labelText: document['full_name']),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                        icon: const Icon(
                          Icons.email,
                          color: Color.fromARGB(255, 93, 149, 201),
                        ),
                        border: const UnderlineInputBorder(),
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 93, 149, 201),
                        ),
                        labelText: Auth().currentUser!.email ?? ""),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                        icon: const Icon(
                          Icons.pin_drop,
                          color: Color.fromARGB(255, 93, 149, 201),
                        ),
                        border: const UnderlineInputBorder(),
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 93, 149, 201),
                        ),
                        labelText: document['liveLocation'] != null
                            // ignore: prefer_interpolation_to_compose_strings
                            ? document['liveLocation'].latitude.toString() +
                                ", " +
                                document['liveLocation'].longitude.toString()
                            : ""),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left:
                            MediaQuery.of(context).copyWith().size.width * 0.25,
                        right: MediaQuery.of(context).copyWith().size.width *
                            0.25),
                    child: TextButton(
                      onPressed: () async {
                        await Auth().signOut();
                        Restart.restartApp();
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 35, 190, 196))),
                      child: const Text(
                        "Sign Out",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
