import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_tour/screens/Home/HomePage/HomePage.dart';
import 'package:i_tour/screens/Login/background.dart';
import 'package:i_tour/screens/Registration/Registration.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  //TextEditingController emailController = TextEditingController();
  //TextEditingController passwordController = TextEditingController();
  //(int a, int b) fun(int a , int b) =>(a, b);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    //final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Logo and app name
                Text(
                  "I Tour".toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: "Worksans",
                      ),
                ),
                // const SizedBox(
                //   height: 5,
                // ),
                //Form
                Container(
                  width: width * 0.9,
                  padding: EdgeInsets.only(left: width * 0.1),
                  child: Form(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Email Address",
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(),
                            // ),
                            // focusedBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(),
                            // ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Password",
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(),
                            // ),
                            // focusedBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(),
                            // ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //login button
                        TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 80, 158, 189)),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const HomePage();
                              },
                            ));
                          },
                          //style: ElevatedButton.styleFrom(),
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        // SizedBox(height: height*0.01,),
                        TextButton(
                          // style: TextButton.styleFrom(
                          //     backgroundColor:
                          //         Color.fromARGB(255, 80, 158, 189)),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const Registration();
                              },
                            ));
                          },
                          //style: ElevatedButton.styleFrom(),
                          child: const Text(
                            "Not have an account? Register",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
