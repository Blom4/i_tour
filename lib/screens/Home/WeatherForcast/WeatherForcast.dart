import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_tour/screens/Home/WeatherForcast/Components/ChoosePerson.dart';
import 'package:i_tour/screens/Home/WeatherForcast/Components/Search.dart';
import 'package:i_tour/screens/Home/WeatherForcast/Constants.dart';
import 'package:i_tour/screens/Home/WeatherForcast/logic/GetWeather_logic.dart';
import 'package:weather/weather.dart';

class WeatherForecast extends StatefulWidget {
  const WeatherForecast({Key? key}) : super(key: key);

  @override
  State<WeatherForecast> createState() => _WeatherForecastState();
}

class _WeatherForecastState extends State<WeatherForecast> {
  final searchController = TextEditingController();
  late GetWeather wr;

  @override
  void initState() {
    super.initState();
    wr = GetWeather();
    wr.initWeather();
    // wr.getCurrentWeatherByGeo();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).copyWith().size.width;
    final height = MediaQuery.of(context).copyWith().size.height;
    // print(Auth().currentUser!.email);
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                initialData: wr.getCurrentWeatherByGeo(setState),
                stream: wr.getCurrentWeatherByGeo(setState).asStream(),
                builder: (context, snapshot) {
                  //  print(snapshot.data??"");

                  if (snapshot.hasData && wr.topWrInfo.isNotEmpty) {
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
                            color: null,
                            width: width * 0.7,
                            wr.topWrInfo.isEmpty
                                ? ""
                                : wr.topWrInfo['icon'].toString(),
                            placeholderBuilder: (context) =>
                                const CircularProgressIndicator(),
                          ),
                          Text(
                            "${wr.topWrInfo['temp'].toString().split(" ")[0]}°",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 92,
                                fontWeight: FontWeight.w900),
                          ),
                          Column(
                            children: [
                              Text(
                                wr.topWrInfo['description'] ?? "weather",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 27,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                wr.topWrInfo.isEmpty
                                    ? ""
                                    : "${weekdays[wr.topWrInfo["date"].weekday]}, ${wr.topWrInfo['date'].day} ${months[wr.topWrInfo['date'].month - 1]}",
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
                          top: MediaQuery.of(context).copyWith().size.height *
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
              Padding(
                padding: EdgeInsets.only(top: 10, left: width * 0.05),
                child: SizedBox(
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
        ),
        Positioned(
            left: width * 0.03,
            top: height * 0.055,
            child: const SearchField()),
        Positioned(
            top: height * 0.05,
            right: width * 0.01,
            child: const ChoosePerson())
      ],
    );
  }
}
