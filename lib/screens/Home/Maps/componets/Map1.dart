import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map1 extends StatefulWidget {
  Map1(
      {required this.isSatalliteView,
      required this.markers,
      required this.polylines,
      required this.circles,
      required this.kGooglePlex,
      required this.findMyLocation,
      required this.controller});
  final Future<void> findMyLocation;
  final bool isSatalliteView;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final Set<Circle> circles;
  final CameraPosition kGooglePlex;
  final Completer<GoogleMapController> controller;
  @override
  State<Map1> createState() => _Map1State();
}

class _Map1State extends State<Map1> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
