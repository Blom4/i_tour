import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_tour/screens/login/emailInput.dart';
import 'package:i_tour/screens/login/passwordInnput.dart';
import 'package:i_tour/store/store.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginformKey = GlobalKey<FormState>();
    final loginusernameController = TextEditingController();
    final loginPasswordController = TextEditingController();
    final store = Get.find<Store>();
  String loginErrorMessage = '';
    return Column(
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.3),
        ),
        Column(
          children: <Widget>[
            ///holds email header and inputField
            Form(
              key: loginformKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(left: 40, bottom: 10),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(fontSize: 16, color: Color(0xFF999A9A)),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      Column(
                        children: const [
                          UsernameInput(
                            topRight: 30.0,
                            bottomRight: 0.0,
                          ),
                          PassswordInput(topRight: 30.0, bottomRight: 0.0),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right:
                                MediaQuery.of(context).copyWith().size.width *
                                    0.7),
                        child: GetBuilder(
                            init: store,
                            builder: ((_) {
                              return Text(
                                loginErrorMessage,
                                style: const TextStyle(color: Colors.red),
                              );
                            })),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(right: 50),
                          child: Row(
                            children: <Widget>[
                              const Expanded(
                                  child: Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Text(
                                  'Enter creditials to continue...',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: Color(0xFFA0A0A0), fontSize: 12),
                                ),
                              )),
                              GestureDetector(
                                onTap: () async {
                                  if (loginformKey.currentState!
                                      .validate()) {
                                    
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const ShapeDecoration(
                                    shape: CircleBorder(),
                                    gradient: LinearGradient(
                                        colors: signInGradients,
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight),
                                  ),
                                  child: const ImageIcon(
                                    AssetImage("assets/ic_forward.png"),
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.04),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                          onTap: () {
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: ((context) {
                            //   return UpdatePassword();
                            // })));
                          },
                          child: Text(
                              style: TextStyle(
                                color: Color(0xFF03A0FE),
                              ),
                              "Change Password")),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 50),
            ),
          ],
        )
      ],
    );
  }
}

Widget roundedRectButton(
    String title, List<Color> gradient, bool isEndIconVisible) {
  return Builder(builder: (BuildContext mContext) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Stack(
        alignment: Alignment(1.0, 0.0),
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(mContext).size.width / 1.7,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: Text(title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
          ),
          Visibility(
            visible: isEndIconVisible,
            child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: ImageIcon(
                  AssetImage("assets/ic_forward.png"),
                  size: 30,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  });
}

const List<Color> signInGradients = [
  Color(0xFF0EDED2),
  Color(0xFF03A0FE),
];

const List<Color> signUpGradients = [
  Color(0xFFFF9945),
  Color(0xFFFc6076),
];
