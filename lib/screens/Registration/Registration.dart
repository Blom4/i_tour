import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:i_tour/screens/Login/login_screen.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repasswordController = TextEditingController();
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).copyWith().size.width;
    final height = MediaQuery.of(context).copyWith().size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          // alignment: WrapAlignment.start,
          // crossAxisAlignment: WrapCrossAlignment.start,
          // runAlignment: WrapAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: height * 0.1, left: width * 0.14),
              child: Image.asset(
                "assets/sphere.png",
                width: width * 0.6,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: width * 0.1, top: height * 0.03),
              width: width * 0.85,
              child: Form(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 38, 86, 114)),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.brown,
                        ),
                        labelText: "Full Names"),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 38, 86, 114)),
                        prefixIcon: Icon(
                          Icons.email_rounded,
                          color: Colors.brown,
                        ),
                        labelText: "Email Address"),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: isObscure,
                    decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 38, 86, 114)),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.brown,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(isObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                        ),
                        labelText: "Password***"),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  TextFormField(
                    controller: repasswordController,
                    obscureText: isObscure,
                    decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 38, 86, 114)),
                        prefixIcon: const Icon(
                          Icons.lock_open,
                          color: Colors.brown,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(isObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                        ),
                        labelText: "Confirm Password***"),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: width * 0.52),
                      child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 45, 183, 207)),
                          onPressed: () {},
                          child: const Text(
                            "Create",
                            style: TextStyle(color: Colors.white),
                          ))),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Center(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const LoginScreen();
                              },
                            ));
                          },
                          child: Text("Alread have Account? Login")))
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
