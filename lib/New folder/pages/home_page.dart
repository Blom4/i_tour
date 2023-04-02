import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

import '../../constants/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

//const kGoogleApiKey = googlea;
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _HomePageState extends State<HomePage> {
  late GoogleMapController _controller;
  late CameraPosition _initialCameraPosition;
  final Mode _mode = Mode.overlay;
  Set<Marker> markers = {};
  Set<Marker> markersList = {};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: homeScaffoldKey,
        body: FutureBuilder(
          future: _determinePosition(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              _initialCameraPosition = CameraPosition(
                bearing: 192.8334901395799,
                target: LatLng(snapshot.data.latitude, snapshot.data.longitude),
                tilt: 59.440717697143555,
                zoom: 14,
              );
              return Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.hybrid,
                    initialCameraPosition: _initialCameraPosition,
                    markers: markersList,
                    zoomControlsEnabled: false,
                    onMapCreated: (GoogleMapController controller) {
                      // _controller.complete(controller);
                      _controller = controller;
                    },
                  ),
                  ElevatedButton(
                    onPressed: _handlePressButton,
                    child: const Text("Search Places"),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _findMyLoction,
        //   tooltip: "Find My Location",
        //   child: const Icon(Icons.location_on),
        // ),
      ),
    );
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white))),
        components: [
          //   Component(Component.country, "pk"),
          //   Component(Component.country, "usa")
        ]);

    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: Text(
        response.errorMessage!,
      ),
    ));

    // homeScaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markersList.clear();
    markersList.add(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name)));

    setState(() {});

    _controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }

  Future<void> _findMyLoction() async {
    Position pos = await _determinePosition();
    CameraPosition currPos = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(pos.latitude, pos.longitude),
      tilt: 59.440717697143555,
      zoom: 14,
    );
    _controller.animateCamera(CameraUpdate.newCameraPosition(currPos));
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId(
          "Current Position",
        ),
        position: LatLng(pos.latitude, pos.longitude),
      ),
    );

    setState(() {});
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  // Future<void> getAddressFromLatLong(Position position) async {
  //   List<Placemark> placemarks =
  //       await placemarkFromCoordinates(position.latitude, position.longitude);
  //   debugPrint(placemarks.toString());
  //   Placemark place = placemarks[0];
  //   var address =
  //       '${place.street},${place.subLocality}, ${place.thoroughfare},${place.locality}, ${place.postalCode}, ${place.country}';

  //   setState(() {
  //     data = address;
  //   });
  // }

  // void getPossition() async {
  //   var status = await Permission.location.request();
  //   if (status == PermissionStatus.granted) {
  //     Position datas = await _determinePosition();

  //     getAddressFromLatLong(datas);
  //   }
  // }

  // Future<void> _goToTheLake() async {
  //   var status = await Permission.location.request();
  //   if (status == PermissionStatus.granted) {
  //     Position mypos = await _determinePosition();

  //     getAddressFromLatLong(mypos);

  //     CameraPosition kLake = CameraPosition(
  //         bearing: 192.8334901395799,
  //         target: LatLng(mypos.latitude, mypos.longitude),
  //         tilt: 59.440717697143555,
  //         zoom: 19.151926040649414);
  //     final GoogleMapController controller = await _controller.future;
  //     controller.animateCamera(CameraUpdate.newCameraPosition(kLake));
  //   }
  // }
}
