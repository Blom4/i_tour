import 'package:flutter/material.dart';

class OriginFieldWidget extends StatelessWidget {
  const OriginFieldWidget({
    super.key,
    required this.controller,
  });
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: TextFormField(
        controller: controller,
        decoration: const InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            border: InputBorder.none,
            hintText: 'Origin'),
      ),
    );
  }
}
