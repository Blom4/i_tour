import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:i_tour/constants/constants.dart';
import 'package:i_tour/widgets/search_people_tracking.dart';
import 'package:lottie/lottie.dart' as Lottie;

import 'dart:ui' as ui;

import '../../../models/auto_complete_result.dart';
import '../../../providers/search_places.dart';
import '../../../services/map_services.dart';
import '../../../widgets/near_me_places_widget.dart';
import '../../../widgets/no_results_Widget.dart';
import '../../../widgets/search_places_widget.dart';

class Maps extends ConsumerStatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends ConsumerState<Maps> {
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _controller2;
//Debounce to throttle async calls during search
  Timer? _debounce;
  Timer? _debounce1;
//Toggling UI as we need;
  bool searchToggle = false;
  bool searchPeopleToggle = false;
  bool radiusSlider = false;
  bool cardTapped = false;
  bool pressedNear = false;
  bool getDirections = false;
  bool isMonitorMapCreated = false;
//Markers set
  Set<Marker> _markers = <Marker>{};
  Set<Marker> _markersDupe = <Marker>{};

  Set<Polyline> _polylines = <Polyline>{};
  int markerIdCounter = 1;
  int polylineIdCounter = 1;

  var radiusValue = 3000.0;

  var tappedPoint;

  List allFavoritePlaces = [];

  String tokenKey = '';

  //Page controller for the nice pageview
  late PageController _pageController;
  int prevPage = 0;
  var tappedPlaceDetail;
  String placeImg = '';
  var photoGalleryIndex = 0;
  bool showBlankCard = false;
  bool isReviews = true;
  bool isPhotos = false;
  bool isSatalliteView = false;
  QueryDocumentSnapshot<Map<String, dynamic>>? selectedPerson;
  final key = '<yourkeyhere>';

  var selectedPlaceDetails;

//Circle
  Set<Circle> _circles = <Circle>{};

//Text Editing Controllers
  TextEditingController searchController = TextEditingController();
  TextEditingController searchPeopleController = TextEditingController();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

//Initial map position on load
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 13,
  );

  void _setMarker(point) {
    var counter = markerIdCounter++;

    final Marker marker = Marker(
        markerId: MarkerId('marker_$counter'),
        position: point,
        onTap: () {},
        icon: BitmapDescriptor.defaultMarker);

    setState(() {
      _markers.add(marker);
    });
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$polylineIdCounter';

    polylineIdCounter++;

    _polylines.add(Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 2,
        color: Colors.blue,
        points: points.map((e) => LatLng(e.latitude, e.longitude)).toList()));
  }

  void _setCircle(LatLng point) async {
    // final GoogleMapController controller = await _controller.future;

    _controller2.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: point, zoom: 12)));
    setState(() {
      _circles.add(Circle(
          circleId: const CircleId('raj'),
          center: point,
          fillColor: Colors.blue.withOpacity(0.1),
          radius: radiusValue,
          strokeColor: Colors.blue,
          strokeWidth: 1));
      getDirections = false;
      searchToggle = false;
      radiusSlider = true;
      searchPeopleToggle = false;
    });
  }

  _setNearMarker(LatLng point, String label, List types, String status) async {
    var counter = markerIdCounter++;

    final Uint8List markerIcon;

    if (types.contains('restaurants')) {
      markerIcon =
          await getBytesFromAsset('assets/mapicons/restaurants.png', 75);
    } else if (types.contains('food')) {
      markerIcon = await getBytesFromAsset('assets/mapicons/food.png', 75);
    } else if (types.contains('school')) {
      markerIcon = await getBytesFromAsset('assets/mapicons/schools.png', 75);
    } else if (types.contains('bar')) {
      markerIcon = await getBytesFromAsset('assets/mapicons/bars.png', 75);
    } else if (types.contains('lodging')) {
      markerIcon = await getBytesFromAsset('assets/mapicons/hotels.png', 75);
    } else if (types.contains('store')) {
      markerIcon =
          await getBytesFromAsset('assets/mapicons/retail-stores.png', 75);
    } else if (types.contains('locality')) {
      markerIcon =
          await getBytesFromAsset('assets/mapicons/local-services.png', 75);
    } else {
      markerIcon = await getBytesFromAsset('assets/mapicons/places.png', 75);
    }

    final Marker marker = Marker(
        markerId: MarkerId('marker_$counter'),
        position: point,
        onTap: () {},
        icon: BitmapDescriptor.fromBytes(markerIcon));

    setState(() {
      _markers.add(marker);
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);

    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: 1, viewportFraction: 0.85)
      ..addListener(_onScroll);
    super.initState();
  }

  // @override
  // void dispose() {
  //   _controller = Completer();
  //   super.dispose();
  // }

  void _onScroll() {
    if (_pageController.page!.toInt() != prevPage) {
      prevPage = _pageController.page!.toInt();
      cardTapped = false;
      photoGalleryIndex = 1;
      showBlankCard = false;
      goToTappedPlace();
      fetchImage();
    }
  }

  //Fetch image to place inside the tile in the pageView
  void fetchImage() async {
    if (_pageController.page != null) {
      if (allFavoritePlaces[_pageController.page!.toInt()]['photos'] != null) {
        setState(() {
          placeImg = allFavoritePlaces[_pageController.page!.toInt()]['photos']
              [0]['photo_reference'];
        });
      } else {
        setState(() {
          placeImg = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    //Providers
    final allSearchResults = ref.watch(placeResultsProvider);
    final allSearchPeopleResults = ref.watch(peopleResultsProvider);
    final searchFlag = ref.watch(searchToggleProvider);
    final searchPeopleFlag = ref.watch(searchPeopleToggleProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: screenHeight,
                  width: screenWidth,
                  child: selectedPerson == null
                      ? GoogleMap(
                          mapType: isSatalliteView
                              ? MapType.satellite
                              : MapType.normal,
                          markers: _markers,
                          polylines: _polylines,
                          circles: _circles,
                          initialCameraPosition: _kGooglePlex,
                          onMapCreated: (GoogleMapController controller) async {
                            // if (!_controller.isCompleted) {
                            //   _controller.complete(controller);
                            // }
                            setState(() {
                              _controller2 = controller;
                            });
                            await _findMyLocation();
                          },
                          onTap: (point) {
                            tappedPoint = point;
                            _setCircle(point);
                          },
                        )
                      : StreamBuilder(
                          stream: selectedPerson?.reference.snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox();
                            }
                            if (!snapshot.data!.exists) {
                              return const SizedBox();
                            }
                            if (isMonitorMapCreated) {
                              gotoSelectedPerson(
                                  snapshot.data!
                                      .data()!['liveLocation']
                                      .latitude,
                                  snapshot.data!
                                      .data()!['liveLocation']
                                      .longitude);
                            }
                            return GoogleMap(
                              mapType: isSatalliteView
                                  ? MapType.satellite
                                  : MapType.normal,
                              markers: {
                                Marker(
                                    markerId: MarkerId(
                                        'marker_${Random().nextDouble()}'),
                                    position: LatLng(
                                        snapshot.data!
                                            .data()!['liveLocation']
                                            .latitude,
                                        snapshot.data!
                                            .data()!['liveLocation']
                                            .longitude),
                                    onTap: () {},
                                    icon: BitmapDescriptor.defaultMarker)
                              },
                              polylines: _polylines,
                              circles: _circles,
                              initialCameraPosition:
                                  snapshot.data!.data()!['liveLocation'] != null
                                      ? CameraPosition(
                                          target: LatLng(
                                              snapshot.data!
                                                  .data()!['liveLocation']
                                                  .latitude,
                                              snapshot.data!
                                                  .data()!['liveLocation']
                                                  .longitude),
                                          zoom: 14.4746,
                                        )
                                      : _kGooglePlex,
                              onMapCreated:
                                  (GoogleMapController controller) async {
                                // _controller.complete(controller);
                                setState(() {
                                  isMonitorMapCreated = true;
                                  _controller2 = controller;
                                });
                                // await _findMyLoction();
                              },
                              onTap: (point) {
                                setState(() {
                                  searchPeopleToggle = false;
                                  searchToggle = false;
                                  radiusSlider = false;
                                  pressedNear = false;
                                  cardTapped = false;
                                  getDirections = false;
                                  selectedPerson = null;
                                });
                              },
                            );
                          },
                        ),
                ),
                if (searchToggle)
                  SearchPlacesWidget(
                    controller: searchController,
                    onPressed: () {
                      setState(() {
                        searchToggle = false;

                        searchController.text = '';
                        _markers = {};
                        if (searchFlag.searchToggle) {
                          searchFlag.toggleSearch();
                        }
                      });
                    },
                    onChanged: (value) {
                      if (_debounce?.isActive ?? false) {
                        _debounce?.cancel();
                      }
                      _debounce = Timer(
                        const Duration(milliseconds: 700),
                        () async {
                          if (value.length > 2) {
                            if (!searchFlag.searchToggle) {
                              searchFlag.toggleSearch();
                              _markers = {};
                            }

                            List<AutoCompleteResult> searchResults =
                                await MapServices().searchPlaces(value.trim().toLowerCase());

                            allSearchResults.setResults(searchResults);

                          } else {
                            List<AutoCompleteResult> emptyList = [];
                            allSearchResults.setResults(emptyList);
                          }
                        },
                      );
                    },
                  ),
                if (searchPeopleToggle)
                  SearchPeopleTracking(
                    controller: searchPeopleController,
                    onPressed: () {
                      setState(() {
                        searchPeopleToggle = false;

                        searchPeopleController.text = '';
                        _markers = {};
                        if (searchPeopleFlag.searchToggle) {
                          searchPeopleFlag.toggleSearch();
                        }
                      });
                    },
                    onChanged: (value) {
                      if (_debounce1?.isActive ?? false) {
                        _debounce1?.cancel();
                      }
                      _debounce1 = Timer(
                        const Duration(milliseconds: 700),
                        () async {
                          if (value.length > 2) {
                            if (!searchPeopleFlag.searchToggle) {
                              searchPeopleFlag.toggleSearch();
                              _markers = {};
                            }

                            List<Map> searchResults = await MapServices()
                                .fetchMonitoringPeopleForMap();

                            // print(searchResults);
                            searchResults = searchResults.where((element) {
                              return element['document_data']['email']
                                  .toString()
                                  .contains(value.toString().toLowerCase());
                            }).toList();

                            allSearchPeopleResults.setResults(searchResults);
                          } else {
                            // List<AutoCompleteResult> emptyList = [];
                            // allSearchResults.setResults(emptyList);
                            allSearchPeopleResults.setResults([]);
                          }
                        },
                      );
                    },
                  ),
                if (searchFlag.searchToggle)
                  if (allSearchResults.allReturnedResults.isNotEmpty)
                    Positioned(
                        top: 100.0,
                        left: 15.0,
                        child: Container(
                          height: 200.0,
                          width: screenWidth - 30.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.7),
                          ),
                          child: ListView(
                            children: [
                              ...allSearchResults.allReturnedResults
                                  .map(
                                      (item) => buildListItem(item, searchFlag))
                                  .toList()
                            ],
                          ),
                        ))
                  else
                    const NoResultsWidget(),
                if (searchPeopleFlag.searchToggle)
                  if (allSearchPeopleResults.allReturnedResults.isNotEmpty)
                    Positioned(
                        top: 100.0,
                        left: 15.0,
                        child: Container(
                          height: 150.0,
                          width: screenWidth - 30.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.7),
                          ),
                          child: ListView(
                            children: [
                              ...allSearchPeopleResults.allReturnedResults
                                  .map((e) =>
                                      buildListPeopleItem(e, searchPeopleFlag))
                                  .toList()
                            ],
                          ),
                        ))
                  else
                    const NoResultsWidget(),
                // remove directions
                if (radiusSlider)
                  NearMePlacesWidget(
                    radiusValue: radiusValue,
                    pressedNear: pressedNear,
                    onNearMePressed: () {
                      if (_debounce?.isActive ?? false) {
                        _debounce?.cancel();
                      }
                      _debounce = Timer(const Duration(seconds: 2), () async {
                        var placesResult = await MapServices()
                            .getPlaceDetails(tappedPoint, radiusValue.toInt());

                        List<dynamic> placesWithin =
                            placesResult['results'] as List;

                        allFavoritePlaces = placesWithin;

                        tokenKey = placesResult['next_page_token'] ?? 'none';
                        _markers = {};
                        for (var element in placesWithin) {
                          _setNearMarker(
                            LatLng(element['geometry']['location']['lat'],
                                element['geometry']['location']['lng']),
                            element['name'],
                            element['types'],
                            element['business_status'] ?? 'not available',
                          );
                        }
                        _markersDupe = _markers;
                        pressedNear = true;
                      });
                    },
                    onMorePlacesPressed: () {
                      if (_debounce?.isActive ?? false) {
                        _debounce?.cancel();
                      }
                      _debounce = Timer(const Duration(seconds: 2), () async {
                        if (tokenKey != 'none') {
                          var placesResult =
                              await MapServices().getMorePlaceDetails(tokenKey);

                          List<dynamic> placesWithin =
                              placesResult['results'] as List;

                          allFavoritePlaces.addAll(placesWithin);

                          tokenKey = placesResult['next_page_token'] ?? 'none';

                          for (var element in placesWithin) {
                            _setNearMarker(
                              LatLng(element['geometry']['location']['lat'],
                                  element['geometry']['location']['lng']),
                              element['name'],
                              element['types'],
                              element['business_status'] ?? 'not available',
                            );
                          }
                        } else {
                          debugPrint('Thats all folks!!');
                        }
                      });
                    },
                    onSliderChanged: (newVal) {
                      radiusValue = newVal;
                      pressedNear = false;
                      _setCircle(tappedPoint);
                    },
                    onClosePressed: () {
                      setState(
                        () {
                          radiusSlider = false;
                          pressedNear = false;
                          cardTapped = false;
                          radiusValue = 3000.0;
                          _circles = {};
                          _markers = {};
                          allFavoritePlaces = [];
                        },
                      );
                    },
                  ),
                if (pressedNear)
                  Positioned(
                      bottom: 20.0,
                      child: SizedBox(
                        height: 200.0,
                        width: MediaQuery.of(context).size.width,
                        child: PageView.builder(
                            controller: _pageController,
                            itemCount: allFavoritePlaces.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _nearbyPlacesList(index);
                            }),
                      )),
                if (cardTapped)
                  Positioned(
                    top: 100.0,
                    left: 15.0,
                    child: _myFlipCard(),
                  )
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FabCircularMenu(
          alignment: Alignment.bottomLeft,
          fabColor: Colors.blue.shade50,
          fabOpenColor: Colors.red.shade100,
          ringDiameter: 250.0,
          ringWidth: 60.0,
          ringColor: Colors.blue.shade50,
          fabSize: 60.0,
          children: [
            IconButton(
                // icon button that opens a search for google places to view
                onPressed: () {
                  setState(() {
                    selectedPerson = null;
                    searchPeopleToggle = false;
                    searchToggle = true;
                    radiusSlider = false;
                    pressedNear = false;
                    cardTapped = false;
                    getDirections = false;
                  });
                },
                icon: const Icon(Icons.search)),
            IconButton(
                // icon button that opens search people that one is monitoring
                onPressed: () {
                  setState(() {
                    selectedPerson = null;
                    searchToggle = false;
                    radiusSlider = false;
                    searchPeopleToggle = true;
                    pressedNear = false;
                    cardTapped = false;
                    getDirections = false;
                  });
                },
                icon: const Icon(
                  Icons.people_outline_sharp,
                  color: Colors.blueAccent,
                )),
            IconButton(
                // icon botton that make cameraPosition to return to my current location
                onPressed: () async {
                  setState(() {
                    selectedPerson = null;
                    searchPeopleToggle = false;
                    searchToggle = false;
                    radiusSlider = false;
                    pressedNear = false;
                    cardTapped = false;
                    getDirections = false;
                  });
                  if (searchFlag.searchToggle) {
                    searchFlag.toggleSearch();
                  }
                  await _findMyLocation();
                },
                icon: const Icon(
                  Icons.pin_drop,
                  color: Colors.red,
                )),
            IconButton(
                // icon button for change map type eg satellite view
                onPressed: () {
                  setState(() {
                    isSatalliteView = !isSatalliteView;
                  });
                },
                icon: const Icon(
                  Icons.map,
                  color: Colors.blue,
                ))
          ]),
    );
  }

  FlipCard _myFlipCard() {
    return FlipCard(
      front: Container(
        height: 250.0,
        width: 175.0,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              height: 150.0,
              width: 175.0,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                  image: DecorationImage(
                      image: NetworkImage(placeImg != ''
                          ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$placeImg&key=$key'
                          : 'https://pic.onlinewebfonts.com/svg/img_546302.png'),
                      fit: BoxFit.cover)),
            ),
            Container(
              padding: const EdgeInsets.all(7.0),
              width: 175.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Address: ',
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                      width: 105.0,
                      child: Text(
                        tappedPlaceDetail['formatted_address'] ?? 'none given',
                        style: const TextStyle(
                            fontFamily: 'WorkSans',
                            fontSize: 11.0,
                            fontWeight: FontWeight.w400),
                      ))
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 0.0),
              width: 175.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact: ',
                    style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                      width: 105.0,
                      child: Text(
                        tappedPlaceDetail['formatted_phone_number'] ??
                            'none given',
                        style: const TextStyle(
                            fontFamily: 'WorkSans',
                            fontSize: 11.0,
                            fontWeight: FontWeight.w400),
                      ))
                ],
              ),
            ),
          ]),
        ),
      ),
      back: Container(
        height: 300.0,
        width: 225.0,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isReviews = true;
                        isPhotos = false;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeIn,
                      padding: const EdgeInsets.fromLTRB(7.0, 4.0, 7.0, 4.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11.0),
                          color:
                              isReviews ? Colors.green.shade300 : Colors.white),
                      child: Text(
                        'Reviews',
                        style: TextStyle(
                            color: isReviews ? Colors.white : Colors.black87,
                            fontFamily: 'WorkSans',
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isReviews = false;
                        isPhotos = true;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeIn,
                      padding: const EdgeInsets.fromLTRB(7.0, 4.0, 7.0, 4.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11.0),
                          color:
                              isPhotos ? Colors.green.shade300 : Colors.white),
                      child: Text(
                        'Photos',
                        style: TextStyle(
                            color: isPhotos ? Colors.white : Colors.black87,
                            fontFamily: 'WorkSans',
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 250.0,
              child: isReviews
                  ? ListView(
                      children: [
                        if (isReviews && tappedPlaceDetail['reviews'] != null)
                          ...tappedPlaceDetail['reviews']!.map((e) {
                            return _buildReviewItem(e);
                          })
                      ],
                    )
                  : _buildPhotoGallery(tappedPlaceDetail['photos'] ?? []),
            )
          ],
        ),
      ),
    );
  }

  _buildReviewItem(review) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          child: Row(
            children: [
              Container(
                height: 35.0,
                width: 35.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(review['profile_photo_url']),
                        fit: BoxFit.cover)),
              ),
              const SizedBox(width: 4.0),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                  width: 160.0,
                  child: Text(
                    review['author_name'],
                    style: const TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 3.0),
                RatingStars(
                  value: review['rating'] * 1.0,
                  starCount: 5,
                  starSize: 7,
                  valueLabelColor: const Color(0xff9b9b9b),
                  valueLabelTextStyle: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'WorkSans',
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 9.0),
                  valueLabelRadius: 7,
                  maxValue: 5,
                  starSpacing: 2,
                  maxValueVisibility: false,
                  valueLabelVisibility: true,
                  animationDuration: const Duration(milliseconds: 1000),
                  valueLabelPadding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                  valueLabelMargin: const EdgeInsets.only(right: 4),
                  starOffColor: const Color(0xffe7e8ea),
                  starColor: Colors.yellow,
                )
              ])
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            review['text'],
            style: const TextStyle(
                fontFamily: 'WorkSans',
                fontSize: 11.0,
                fontWeight: FontWeight.w400),
          ),
        ),
        Divider(color: Colors.grey.shade600, height: 1.0)
      ],
    );
  }

  _buildPhotoGallery(photoElement) {
    if (photoElement == null || photoElement.length == 0) {
      showBlankCard = true;
      return const Center(
        child: Text(
          'No Photos',
          style: TextStyle(
              fontFamily: 'WorkSans',
              fontSize: 12.0,
              fontWeight: FontWeight.w500),
        ),
      );
    } else {
      var placeImg = photoElement[photoGalleryIndex]['photo_reference'];
      var maxWidth = photoElement[photoGalleryIndex]['width'];
      var maxHeight = photoElement[photoGalleryIndex]['height'];
      var tempDisplayIndex = photoGalleryIndex + 1;

      return Column(
        children: [
          const SizedBox(height: 10.0),
          Container(
              height: 200.0,
              width: 200.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=$maxWidth&maxheight=$maxHeight&photo_reference=$placeImg&key=$key'),
                      fit: BoxFit.cover))),
          const SizedBox(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (photoGalleryIndex != 0) {
                    photoGalleryIndex = photoGalleryIndex - 1;
                  } else {
                    photoGalleryIndex = 0;
                  }
                });
              },
              child: Container(
                width: 40.0,
                height: 20.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.0),
                    color: photoGalleryIndex != 0
                        ? Colors.green.shade500
                        : Colors.grey.shade500),
                child: const Center(
                  child: Text(
                    'Prev',
                    style: TextStyle(
                        fontFamily: 'WorkSans',
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            Text(
              '$tempDisplayIndex/${photoElement.length}',
              style: const TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (photoGalleryIndex != photoElement.length - 1) {
                    photoGalleryIndex = photoGalleryIndex + 1;
                  } else {
                    photoGalleryIndex = photoElement.length - 1;
                  }
                });
              },
              child: Container(
                width: 40.0,
                height: 20.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.0),
                    color: photoGalleryIndex != photoElement.length - 1
                        ? Colors.green.shade500
                        : Colors.grey.shade500),
                child: const Center(
                  child: Text(
                    'Next',
                    style: TextStyle(
                        fontFamily: 'WorkSans',
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ])
        ],
      );
    }
  }

  Future<void> gotoPlace(double lat, double lng, double endLat, double endLng,
      Map<String, dynamic> boundsNe, Map<String, dynamic> boundsSw) async {
    // final GoogleMapController controller = await _controller.future;

    _controller2.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'], boundsNe['lng'])),
        25));

    _setMarker(LatLng(lat, lng));
    _setMarker(LatLng(endLat, endLng));
  }

  Future<void> moveCameraSlightly() async {
    // final GoogleMapController controller = await _controller.future;

    _controller2.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
            allFavoritePlaces[_pageController.page!.toInt()]['geometry']
                    ['location']['lat'] +
                0.0125,
            allFavoritePlaces[_pageController.page!.toInt()]['geometry']
                    ['location']['lng'] +
                0.005),
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
  }

  AnimatedBuilder _nearbyPlacesList(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget? widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = (_pageController.page! - index);
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
        onTap: () async {
          cardTapped = !cardTapped;
          if (cardTapped) {
            tappedPlaceDetail = await MapServices()
                .getPlace(allFavoritePlaces[index]['place_id']);
            setState(() {});
          }
          moveCameraSlightly();
        },
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 20.0,
                ),
                height: 125.0,
                width: 275.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black54,
                          offset: Offset(0.0, 4.0),
                          blurRadius: 10.0)
                    ]),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white),
                  child: Row(
                    children: [
                      _pageController.position.haveDimensions
                          ? _pageController.page!.toInt() == index
                              ? Container(
                                  height: 90.0,
                                  width: 90.0,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(10.0),
                                        topLeft: Radius.circular(10.0),
                                      ),
                                      image: DecorationImage(
                                          image: NetworkImage(placeImg != ''
                                              ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$placeImg&key=$key'
                                              : 'https://pic.onlinewebfonts.com/svg/img_546302.png'),
                                          fit: BoxFit.cover)),
                                )
                              : Container(
                                  height: 90.0,
                                  width: 20.0,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10.0),
                                        topLeft: Radius.circular(10.0),
                                      ),
                                      color: Colors.blue),
                                )
                          : Container(),
                      const SizedBox(width: 5.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 170.0,
                            child: Text(allFavoritePlaces[index]['name'],
                                style: const TextStyle(
                                    fontSize: 12.5,
                                    fontFamily: 'WorkSans',
                                    fontWeight: FontWeight.bold)),
                          ),
                          RatingStars(
                            value: allFavoritePlaces[index]['rating']
                                        .runtimeType ==
                                    int
                                ? allFavoritePlaces[index]['rating'] * 1.0
                                : allFavoritePlaces[index]['rating'] ?? 0.0,
                            starCount: 5,
                            starSize: 10,
                            valueLabelColor: const Color(0xff9b9b9b),
                            valueLabelTextStyle: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'WorkSans',
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            valueLabelRadius: 10,
                            maxValue: 5,
                            starSpacing: 2,
                            maxValueVisibility: false,
                            valueLabelVisibility: true,
                            animationDuration:
                                const Duration(milliseconds: 1000),
                            valueLabelPadding: const EdgeInsets.symmetric(
                                vertical: 1, horizontal: 8),
                            valueLabelMargin: const EdgeInsets.only(right: 8),
                            starOffColor: const Color(0xffe7e8ea),
                            starColor: Colors.yellow,
                          ),
                          SizedBox(
                            width: 170.0,
                            child: Text(
                              allFavoritePlaces[index]['business_status'] ??
                                  'none',
                              style: TextStyle(
                                  color: allFavoritePlaces[index]
                                              ['business_status'] ==
                                          'OPERATIONAL'
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> goToTappedPlace() async {
    // on tapping place on map camera points at that direction
    // final GoogleMapController controller = await _controller.future;

    _markers = {};

    var selectedPlace = allFavoritePlaces[_pageController.page!.toInt()];

    _setNearMarker(
        // near marker full circular type when tapping
        LatLng(selectedPlace['geometry']['location']['lat'],
            selectedPlace['geometry']['location']['lng']),
        selectedPlace['name'] ?? 'no name',
        selectedPlace['types'],
        selectedPlace['business_status'] ?? 'none');

    _controller2.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(selectedPlace['geometry']['location']['lat'],
            selectedPlace['geometry']['location']['lng']),
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
  }

  Future<void> gotoSearchedPlace(double lat, double lng) async {
    // search place ,type name and suggestion tap on it the camera points to that position
    // final GoogleMapController controller = await _controller.future;

    _controller2.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12)));

    _setMarker(LatLng(lat, lng));
  }

  Future<void> gotoSelectedPerson(double lat, double lng) async {
    // search place ,type name and suggestion tap on it the camera points to that position
    // final GoogleMapController controller = await _controller.future;

    _controller2.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12)));

    // _setMarker(LatLng(lat, lng));
  }

  Widget buildListItem(AutoCompleteResult placeItem, searchFlag) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTapDown: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTap: () async {
          var place = await MapServices().getPlace(placeItem.placeId);
          gotoSearchedPlace(place['geometry']['location']['lat'],
              place['geometry']['location']['lng']);
          searchFlag.toggleSearch();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, color: Colors.green, size: 25.0),
            const SizedBox(width: 4.0),
            SizedBox(
              height: 40.0,
              width: MediaQuery.of(context).size.width - 75.0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(placeItem.description ?? ''),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildListPeopleItem(Map peopleItem, searchPeopleFlag) {
    // print(peopleItem.runtimeType);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTapDown: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTap: () async {
          // var place = await MapServices().getPlace(placeItem.placeId);
          // gotoSearchedPlace(place['geometry']['location']['lat'],
          //     place['geometry']['location']['lng']);
          // searchFlag.toggleSearch();

          setState(() {
            selectedPerson = peopleItem['document'];
          });
          // print(peopleItem['document'].runtimeType);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, color: Colors.green, size: 25.0),
            const SizedBox(width: 4.0),
            SizedBox(
              height: 40.0,
              width: MediaQuery.of(context).size.width - 75.0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(peopleItem['document_data']['full_name'] ?? ''),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _findMyLocation() async {
    // final GoogleMapController controller = await _controller.future;
    Position pos = await determinePosition();
    CameraPosition currPos = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(pos.latitude, pos.longitude),
      tilt: 59.440717697143555,
      zoom: 12,
    );
    _controller2.animateCamera(CameraUpdate.newCameraPosition(currPos));

    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId(
            "Current Position",
          ),
          position: LatLng(pos.latitude, pos.longitude),
        ),
      );
    });
  }

  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //   return await Geolocator.getCurrentPosition();
  // }
}
