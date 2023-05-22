import 'package:flutter/material.dart';

class SearchPeopleTracking extends StatelessWidget {
  const SearchPeopleTracking({
    super.key,
    required this.onChanged,
    required this.onPressed,
    required this.controller,
  });

  final void Function(String)? onChanged;
  final VoidCallback onPressed;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 5.0),
      child: Column(children: [
        Container(
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          child: TextFormField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              border: InputBorder.none,
              hintText: 'Search People by Email',
              suffixIcon: IconButton(
                onPressed: onPressed,
                icon: const Icon(Icons.close),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
