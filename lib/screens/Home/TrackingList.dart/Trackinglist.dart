import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TrackingList extends StatefulWidget {
  const TrackingList({super.key});

  @override
  State<TrackingList> createState() => _TrackingListState();
}

class _TrackingListState extends State<TrackingList> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Tracking List"),);
  }
}