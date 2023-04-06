import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_tour/store/store.dart';

class PassswordInput extends StatefulWidget {
  final double topRight;
  final double bottomRight;

  const PassswordInput(
      {Key? key, required this.topRight, required this.bottomRight})
      : super(key: key);

  @override
  State<PassswordInput> createState() => _PassswordInputState();
}

class _PassswordInputState extends State<PassswordInput> {
  final loginPasswordController = TextEditingController();
  bool _isobscure = true;
  @override
  Widget build(BuildContext context) {
    final store = Get.find<Store>();
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
                const EdgeInsets.only(left: 40, right: 20, top: 5, bottom: 10),
            child: TextFormField(
              controller: loginPasswordController,
              obscureText: _isobscure,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isobscure
                          ? Icons.visibility
                          : Icons.visibility_off_outlined,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        _isobscure = !_isobscure;
                      });
                    },
                  ),
                  border: InputBorder.none,
                  hintText: "********",
                  hintStyle:
                      const TextStyle(color: Color(0xFFE1E1E1), fontSize: 14)),
              validator: (String? value) {
                return value == null || value.trim().isEmpty
                    ? 'Password Cannot be empty'
                    : null;
              },
            ),
          ),
        ),
      ),
    );
  }
}
