import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_tour/screens/Home/WeatherForcast/Components/ChoosePerson.dart';
import 'package:i_tour/screens/Home/WeatherForcast/Components/Search.dart';
import 'package:i_tour/screens/Home/WeatherForcast/Constants.dart';
import 'package:i_tour/screens/Home/WeatherForcast/logic/GetWeather_logic.dart';
import 'package:i_tour/store/store.dart';
import 'package:weather/weather.dart';

class WeatherForecast extends StatefulWidget {
  const WeatherForecast({Key? key}) : super(key: key);

  @override
  State<WeatherForecast> createState() => _WeatherForecastState();
}

class _WeatherForecastState extends State<WeatherForecast> {
  final searchController = TextEditingController();
  // late GetWeather wr;
  final Store store = Get.find<Store>();
  @override
  void initState() {
    super.initState();
    // store.getWeather = GetWeather();
    store.getWeather.initWeather();

    // store.getWeather.getCurrentWeatherByGeo();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).copyWith().size.width;
    final height = MediaQuery.of(context).copyWith().size.height;
    // print(Auth().currentUser!.email);
    return GetBuilder(
      init: store,
      builder: (_) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder(
                    initialData: store.getWeather.getCurrentWeatherByGeo(),
                    stream:
                        store.getWeather.getCurrentWeatherByGeo().asStream(),
                    builder: (context, snapshot) {
                      //  print(snapshot.data??"");

                      if (snapshot.hasData &&
                          store.getWeather.topWrInfo.isNotEmpty) {
                        return Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(60),
                                  bottomRight: Radius.circular(60)),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromARGB(255, 85, 180, 218),
                                    Color.fromARGB(255, 105, 235, 240)
                                  ])),
                          width: width,
                          height: height * 0.7,
                          child: Column(
                            children: [
                              SizedBox(
                                height: height * 0.1,
                              ),
                              SvgPicture.asset(
                                // ignore: deprecated_member_use
                                color: (store.getWeather.currentWeather
                                                    .weatherConditionCode >=
                                                210 &&
                                            store.getWeather.currentWeather
                                                    .weatherConditionCode <=
                                                232) ||
                                        (store.getWeather.currentWeather
                                                    .weatherConditionCode >=
                                                601 &&
                                            store.getWeather.currentWeather
                                                    .weatherConditionCode <=
                                                622) ||
                                        (store.getWeather.currentWeather
                                                    .weatherConditionCode >=
                                                500 &&
                                            store.getWeather.currentWeather
                                                    .weatherConditionCode <=
                                                531)
                                    ? Colors.white
                                    : null,
                                width: width * 0.7,
                                store.getWeather.topWrInfo.isEmpty
                                    ? ""
                                    : store.getWeather.topWrInfo['icon']
                                        .toString(),
                                placeholderBuilder: (context) =>
                                    const CircularProgressIndicator(),
                              ),
                              Text(
                                "${store.getWeather.topWrInfo['temp'].toString().split(" ")[0]}°",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 92,
                                    fontWeight: FontWeight.w900),
                              ),
                              Column(
                                children: [
                                  Text(
                                    store.getWeather.topWrInfo['description'] ??
                                        "weather",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 27,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    store.getWeather.topWrInfo.isEmpty
                                        ? ""
                                        : "${weekdays[store.getWeather.topWrInfo["date"].weekday]}, ${store.getWeather.topWrInfo['date'].day} ${months[store.getWeather.topWrInfo['date'].month - 1]}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 27,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                      return Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(60),
                                bottomRight: Radius.circular(60)),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromARGB(255, 85, 180, 218),
                                  Color.fromARGB(255, 105, 235, 240)
                                ])),
                        width: width,
                        height: height * 0.7,
                        child: Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context)
                                      .copyWith()
                                      .size
                                      .height *
                                  0.01,
                              // left: MediaQuery.of(context).copyWith().size.width * 0.5
                            ),
                            child: const SpinKitDualRing(
                              color: Color.fromARGB(255, 35, 104, 136),
                              size: 150,
                              // duration: Duration(milliseconds: 1000),
                            )),
                      );
                    },
                  ),
                  // SizedBox(height: height*0.5,),
                  StreamBuilder(
                      stream: store.getWeather.getFiveDaysForecast().asStream(),
                      builder: (context, snapshots) {
                        if (!snapshots.hasData) {
                          return const SizedBox();
                        }

                        return SizedBox(
                            width: width * 0.9,
                            height: height * 0.2,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshots.data.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: width * 0.4,
                                  height: height * 0.1,
                                  margin: EdgeInsets.only(
                                      right: MediaQuery.of(context)
                                              .copyWith()
                                              .size
                                              .width *
                                          0.05,
                                      top: MediaQuery.of(context)
                                              .copyWith()
                                              .size
                                              .height *
                                          0.005),
                                  decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topRight,
                                          colors: [
                                            Color.fromARGB(255, 46, 44, 44),
                                            Colors.grey
                                          ]),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: height * 0.02,
                                      ),
                                      Text(
                                        "${snapshots.data[index]['description']}",
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15),
                                      ),
                                      SvgPicture.asset(
                                        // color: Colors.white,
                                        width: width * 0.23,
                                        "${snapshots.data[index]['icon']}",
                                        placeholderBuilder: (context) =>
                                            const CircularProgressIndicator(),
                                      ),
                                      Text(
                                        weekdays[snapshots
                                                .data[index]['date'].weekday -
                                            1],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ));
                      })
                ],
              ),
            ),
            // Positioned(
            //     left: width * 0.03,
            //     top: height * 0.055,
            //     child: const SearchField()),
            Positioned(
                top: height * 0.05,
                right: width * 0.01,
                child: const ChoosePerson())
          ],
        );
      },
    );
  }
}
