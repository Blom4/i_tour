import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:i_tour/screens/Home/Profile/components/Background.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection("user").snapshots();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).copyWith().size.width;
    final height = MediaQuery.of(context).copyWith().size.height;
    return Stack(
      fit: StackFit.expand,
      children: [
        const Background(),
        Container(
          width: width,
          height: height,
          child: ListView(
            children: [
              Padding(
                  padding: EdgeInsets.only(top: height * 0.25, left: width * 0),
                  child: Container(
                    width: width * 0.5,
                    height: height * 0.2,
                    child: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 230, 233, 233),
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
                decoration: const InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 93, 149, 201),
                    ),
                    border: UnderlineInputBorder(),
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 93, 149, 201),
                    ),
                    labelText: "Malefetsane Shelile"),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              TextFormField(
                enabled: false,
                decoration: const InputDecoration(
                    icon: Icon(
                      Icons.email,
                      color: Color.fromARGB(255, 93, 149, 201),
                    ),
                    border: UnderlineInputBorder(),
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 93, 149, 201),
                    ),
                    labelText: "email@gmail.com"),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              TextFormField(
                enabled: false,
                decoration: const InputDecoration(
                    icon: Icon(
                      Icons.pin_drop,
                      color: Color.fromARGB(255, 93, 149, 201),
                    ),
                    border: UnderlineInputBorder(),
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 93, 149, 201),
                    ),
                    labelText: "232393283892 , 343849349845445"),
              ),
              TextButton(
                onPressed: () => null,
                child: const Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.white),
                ),
                
                style: ButtonStyle(
                  
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 35, 190, 196))),
              )
            ],
          ),
        )
      ],
    );
  }
}
