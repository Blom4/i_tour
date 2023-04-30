import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:i_tour/screens/Home/WeatherForcast/Components/ChoosePerson.dart';
import 'package:i_tour/screens/Home/WeatherForcast/Components/Search.dart';
import 'package:i_tour/screens/Home/WeatherForcast/Constants.dart';
import 'package:search_page/search_page.dart';
import 'package:weather/weather.dart';

class WeatherForecast extends StatefulWidget {
  const WeatherForecast({Key? key}) : super(key: key);

  @override
  State<WeatherForecast> createState() => _WeatherForecastState();
}

class _WeatherForecastState extends State<WeatherForecast> {
  late WeatherFactory ws;
  final searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    ws = WeatherFactory(weatherKey);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).copyWith().size.width;
    final height = MediaQuery.of(context).copyWith().size.height;
    return Stack(
      children: [
        Wrap(
          children: [
            Container(
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
                    // color: Colors.white,
                    width: width * 0.73,
                    "assets/weather/sunclouds.svg",
                    placeholderBuilder: (context) =>
                        const CircularProgressIndicator(),
                  ),
                  const Text(
                    "15°",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 92,
                        fontWeight: FontWeight.w900),
                  ),
                  Column(
                    children: const [
                      Text(
                        "Few Clouds",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Sunday, 09 Mar",
                        style: TextStyle(
                            color: Color.fromARGB(255, 236, 233, 233),
                            fontSize: 27,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // SizedBox(height: height*0.5,),
            Padding(
              padding: EdgeInsets.only(top: 10, left: width * 0.05),
              child: Container(
                  width: width * 0.9,
                  height: height * 0.2,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        // padding: EdgeInsets.only(left: width*0.02),
                        width: width * 0.3,
                        height: height * 0.1,
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
                            const Text(
                              "15°",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22),
                            ),
                            SvgPicture.asset(
                              // color: Colors.white,
                              width: width * 0.23,
                              "assets/weather/sunclouds.svg",
                              placeholderBuilder: (context) =>
                                  const CircularProgressIndicator(),
                            ),
                            const Text(
                              "Monday",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width * 0.035,
                      ),
                      Container(
                        // padding: EdgeInsets.only(left: width*0.02),
                        width: width * 0.3,
                        height: height * 0.1,
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
                            const Text(
                              "22°",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22),
                            ),
                            SvgPicture.asset(
                              // color: Colors.white,
                              width: width * 0.23,
                              "assets/weather/sunset.svg",
                              placeholderBuilder: (context) =>
                                  const CircularProgressIndicator(),
                            ),
                            const Text(
                              "Tuesday",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width * 0.035,
                      ),
                      Container(
                        // padding: EdgeInsets.only(left: width*0.02),
                        width: width * 0.3,
                        height: height * 0.1,
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
                            const Text(
                              "30°",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22),
                            ),
                            SvgPicture.asset(
                              // color: Colors.white,
                              width: width * 0.23,
                              "assets/weather/sunset.svg",
                              placeholderBuilder: (context) =>
                                  const CircularProgressIndicator(),
                            ),
                            const Text(
                              "Wednesday",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width * 0.035,
                      ),
                      Container(
                        // padding: EdgeInsets.only(left: width*0.02),
                        width: width * 0.3,
                        height: height * 0.1,
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
                            const Text(
                              "15°",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22),
                            ),
                            SvgPicture.asset(
                              // color: Colors.white,
                              width: width * 0.23,
                              "assets/weather/cloudy.svg",
                              placeholderBuilder: (context) =>
                                  const CircularProgressIndicator(),
                            ),
                            const Text(
                              "Thursday",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width * 0.035,
                      ),
                    ],
                  )),
            )
          ],
        ),
        Positioned(
            left: width * 0.03, top: height * 0.055, child: SearchField()),
        Positioned(
            top: height * 0.05,
            right: width * 0.01,
            child: const ChoosePerson())
      ],
    );
  }
}
