import 'package:flutter/material.dart';

class DestinationFieldWidget extends StatelessWidget {
  const DestinationFieldWidget({
    super.key,
    required this.controller,
    required this.onClosePressed,
    required this.onSearchPressed,
  });
  final TextEditingController controller;
  final VoidCallback onClosePressed;
  final VoidCallback onSearchPressed;

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
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            border: InputBorder.none,
            hintText: 'Destination',
            suffixIcon: SizedBox(
                width: 96.0,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: onSearchPressed,
                        icon: const Icon(Icons.search)),
                    IconButton(
                        onPressed: onClosePressed,
                        icon: const Icon(Icons.close))
                  ],
                ))),
      ),
    );
  }
}
