import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/search_places.dart';

class NoResultsWidget extends ConsumerWidget {
  const NoResultsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchFlag = ref.watch(searchToggleProvider);
    double screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
        top: 100.0,
        left: 15.0,
        child: Container(
          height: 200.0,
          width: screenWidth - 30.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white.withOpacity(0.7),
          ),
          child: Center(
            child: Column(children: [
              const Text('No results to show',
                  style: TextStyle(
                      fontFamily: 'WorkSans', fontWeight: FontWeight.w400)),
              const SizedBox(height: 5.0),
              SizedBox(
                width: 125.0,
                child: ElevatedButton(
                  onPressed: () {
                    searchFlag.toggleSearch();
                  },
                  child: const Center(
                    child: Text(
                      'Close this',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'WorkSans',
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              )
            ]),
          ),
        ));
  }
}
