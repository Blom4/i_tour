import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:i_tour/logic/firebase_auth.dart';
import 'package:i_tour/screens/Login/login_screen.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

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
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  bool isLoading = false;
  var error = '';
  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(error.toString()),
      action: SnackBarAction(
        label: 'ok',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
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
            isLoading
                ? Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).copyWith().size.height * 0.01,
                      // left: MediaQuery.of(context).copyWith().size.width * 0.5
                    ),
                    child: const SpinKitFoldingCube(
                      color: Color.fromARGB(255, 35, 104, 136),
                      size: 150,
                      // duration: Duration(milliseconds: 1000),
                    ))
                : Container(
                    padding:
                        EdgeInsets.only(left: width * 0.1, top: height * 0.03),
                    width: width * 0.85,
                    child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'field cannot be empty';
                                }
                                return null;
                              },
                              controller: nameController,
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelStyle: TextStyle(
                                      color: Color.fromARGB(255, 38, 86, 114)),
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
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.compose([
                                Validators.required('Email is required'),
                                Validators.email('wrong email format'),
                              ]),
                              controller: emailController,
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelStyle: TextStyle(
                                      color: Color.fromARGB(255, 38, 86, 114)),
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
                              validator: Validators.compose([
                                Validators.required('Password is required'),
                                Validators.patternString(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                                    'Password not strong')
                              ]),
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
                              validator: Validators.compose([
                                Validators.required('Password is required'),
                                Validators.patternString(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                                    'Password not strong')
                              ]),
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
                                        backgroundColor: const Color.fromARGB(
                                            255, 45, 183, 207)),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        if (passwordController.text.trim() ==
                                            repasswordController.text.trim()) {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          try {
                                            var res = await Auth()
                                                .createUserWithEmailAndPassword(
                                                    email: emailController.text
                                                        .toLowerCase()
                                                        .trim(),
                                                    password: passwordController
                                                        .text
                                                        .trim(),
                                                    full_name: nameController
                                                        .text
                                                        .trim());
                                            if (res.statusCode == 201) {
                                              setState(() {
                                                isLoading = false;
                                                error = "";
                                              });
                                              // ignore: use_build_context_synchronously
                                              Navigator.pushReplacement(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                  return const LoginScreen();
                                                },
                                              ));
                                            }
                                          } catch (e) {
                                            setState(() {
                                              isLoading = false;
                                              error = e.toString();
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            isLoading = false;
                                            error = "Password do not match";
                                          });
                                        }
                                      }
                                      setState(() {
                                        isLoading = false;
                                      });
                                      if (error.isNotEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }

                                      // setState(() {
                                      //   error = '';
                                      // });
                                    },
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
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(
                                        builder: (context) {
                                          return const LoginScreen();
                                        },
                                      ));
                                    },
                                    child: const Text(
                                        "Alread have Account? Login")))
                          ],
                        )),
                  ),
          ],
        ),
      ),
    );
  }
}
