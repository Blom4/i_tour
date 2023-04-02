import 'package:flutter/material.dart';

class NearMePlacesWidget extends StatelessWidget {
  const NearMePlacesWidget({
    super.key,
    required this.onSliderChanged,
    required this.onClosePressed,
    required this.onNearMePressed,
    required this.onMorePlacesPressed,
    required this.pressedNear,
    required this.radiusValue,
  });

  final void Function(double)? onSliderChanged;
  final VoidCallback onClosePressed;
  final VoidCallback onNearMePressed;
  final VoidCallback onMorePlacesPressed;
  final bool pressedNear;
  final double radiusValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
      child: Container(
        height: 50.0,
        color: Colors.black.withOpacity(0.2),
        child: Row(
          children: [
            Expanded(
              child: Slider(
                max: 7000.0,
                min: 1000.0,
                value: radiusValue,
                onChanged: onSliderChanged,
              ),
            ),
            if (pressedNear)
              IconButton(
                onPressed: onNearMePressed,
                icon: const Icon(
                  Icons.near_me,
                  color: Colors.blue,
                ),
              )
            else
              IconButton(
                onPressed: onMorePlacesPressed,
                icon: const Icon(
                  Icons.more_time,
                  color: Colors.blue,
                ),
              ),
            IconButton(
              onPressed: onClosePressed,
              icon: const Icon(
                Icons.close,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
