import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:i_tour/screens/login/background.dart';
import 'package:i_tour/screens/login/loginUi.dart';
import 'package:i_tour/store/store.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final store = Get.find<Store>();
  final _loader = const SpinKitFoldingCube(
    color: Color.fromARGB(255, 23, 100, 119),
    size: 80,
    // duration: Duration(milliseconds: 1000),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
        const Background(),
        const Login(),
        
        GetBuilder(
            init: store,
            builder: ((controller) {
              return store.loginLoader
                  ? Container(
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(206, 255, 255, 255)),
                      width: MediaQuery.of(context).copyWith().size.width,
                      height: MediaQuery.of(context).copyWith().size.height,
                      child: _loader)
                  : Container();
            })),
      ]),
    );
  }
}
