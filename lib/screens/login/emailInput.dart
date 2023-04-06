import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsernameInput extends StatefulWidget {
  final double topRight;
  final double bottomRight;

  const UsernameInput(
      {Key? key, required this.topRight, required this.bottomRight})
      : super(key: key);

  // EmailInput(this.topRight, this.bottomRight, {Key? key}) : super(key: key);

  @override
  State<UsernameInput> createState() => _UsernameInputState();
}

class _UsernameInputState extends State<UsernameInput> {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 40, bottom: 30),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 40,
        child: Material(
          elevation: 10,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(widget.bottomRight),
                  topRight: Radius.circular(widget.topRight))),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 40, right: 20, top: 10, bottom: 10),
            child: TextFormField(
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Thabo",
                  hintStyle: TextStyle(color: Color(0xFFE1E1E1), fontSize: 14)),
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return "username is empty";
                } else {
                  return null;
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
