import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:i_tour/constants/constants.dart';
import 'package:i_tour/logic/firebase_auth.dart';
import 'package:i_tour/screens/Home/WeatherForcast/Constants.dart';
import 'package:weather/weather.dart';

class GetWeather {
  //weather logic from openweather
  GeoPoint? pointLocation;
  late WeatherFactory ws;
  // String topWrIcon = "";
  Map topWrInfo = {};
  var selectPerson;
  var currentWeather;
  void initWeather() {
    ws = WeatherFactory(weatherKey);
  }

  Future fetchMonitoringPeople() async {
    List<Map> found = [];
    var results = await firebaseInstance.collection("User").get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> document in results.docs) {
      if (document.data()['email'].toString().toLowerCase() !=
          Auth().currentUser!.email.toString().toLowerCase()) {
        for (DocumentReference<Map<String, dynamic>> item
            in document.data()['monitor'] ?? []) {
          var value = await item.get();
          var user = value.data() ?? {};
          if (user['email'].toString().toLowerCase() ==
              Auth().currentUser!.email.toString().toLowerCase()) {
            found.add(document.data());
          }
        }
      }
    }
    return found;
  }

  Future getPointLocation({required String email}) async {
    var results = await firebaseInstance
        .collection('User')
        .where("email", isEqualTo: email)
        .get();

    pointLocation = results.docs.first.data()['liveLocation'] ?? Null;
    return pointLocation;
  }

  Future<Weather> getCurrentWeatherByGeo() async {
    GeoPoint pos = await getPointLocation(email: selectPerson['email'] ?? "");

    currentWeather =
        await ws.currentWeatherByLocation(pos.latitude, pos.longitude);

    if (currentWeather != null) {
      if (currentWeather.weatherConditionCode == 800) {
        //clear sky weather code 800
        topWrInfo = {
          "icon": "assets/weather/sunset.svg",
          "date": DateTime.parse(currentWeather.date.toString()),
          "temp": currentWeather.temperature,
          "description": currentWeather.weatherDescription
        };
      }

      if (currentWeather.weatherConditionCode == 801) {
        //few clouds weather code 801
        topWrInfo = {
          "icon": "assets/weather/sunclouds.svg",
          "date": DateTime.parse(currentWeather.date.toString()),
          "temp": currentWeather.temperature,
          "description": currentWeather.weatherDescription
        };
      }
      if (currentWeather.weatherConditionCode >= 802 &&
          currentWeather.weatherConditionCode <= 804) {
        //scatterd clouds weather code 802
        topWrInfo = {
          "icon": "assets/weather/cloudy.svg",
          "date": DateTime.parse(currentWeather.date.toString()),
          "temp": currentWeather.temperature,
          "description": currentWeather.weatherDescription
        };
      }
      if (currentWeather.weatherConditionCode >= 500 &&
          currentWeather.weatherConditionCode <= 531) {
        //rain weather code 601 and icon color to white
        topWrInfo = {
          "icon": "assets/weather/rain.svg",
          "date": DateTime.parse(currentWeather.date.toString()),
          "temp": currentWeather.temperature,
          "description": currentWeather.weatherDescription
        };
      }
      if (currentWeather.weatherConditionCode >= 200 &&
          currentWeather.weatherConditionCode <= 202) {
        // thunderstorm weather code 200
        topWrInfo = {
          "icon": "assets/weather/thunder_rain.svg",
          "date": DateTime.parse(currentWeather.date.toString()),
          "temp": currentWeather.temperature,
          "description": currentWeather.weatherDescription
        };
      }
      if (currentWeather.weatherConditionCode >= 601 &&
          currentWeather.weatherConditionCode <= 622) {
        //snow weather code 601 and icon color to white
        topWrInfo = {
          "icon": "assets/weather/snow.svg",
          "date": DateTime.parse(currentWeather.date.toString()),
          "temp": currentWeather.temperature,
          "description": currentWeather.weatherDescription
        };
      }
      if (currentWeather.weatherConditionCode >= 210 &&
          currentWeather.weatherConditionCode <= 232) {
        //thunder only no storm weather code 211 and color to white
        topWrInfo = {
          "icon": "assets/weather/thunder.svg",
          "date": DateTime.parse(currentWeather.date.toString()),
          "temp": currentWeather.temperature,
          "description": currentWeather.weatherDescription
        };
      }
    }
    return currentWeather;
  }

  Future getFiveDaysForecast() async {
    GeoPoint pos = await getPointLocation(email: selectPerson['email'] ?? "");
    List<Weather> res =
        await ws.fiveDayForecastByLocation(pos.latitude, pos.longitude);
    // print(currentWeather);
    List data = [];

    for (Weather item in res) {
      if (item.weatherConditionCode == 800) {
        //clear sky weather code 800
        data.add({
          "icon": "assets/weather/sunset.svg",
          "date": DateTime.parse(item.date.toString()),
          "temp": item.temperature,
          "description": item.weatherDescription
        });
      }

      if (item.weatherConditionCode == 801) {
        //few clouds weather code 801
        data.add({
          "icon": "assets/weather/sunclouds.svg",
          "date": DateTime.parse(item.date.toString()),
          "temp": item.temperature,
          "description": item.weatherDescription
        });
      }
      if ((item.weatherConditionCode ?? 0) >= 802 &&
          (item.weatherConditionCode ?? 0) <= 804) {
        //scatterd clouds weather code 802
        data.add({
          "icon": "assets/weather/cloudy.svg",
          "date": DateTime.parse(item.date.toString()),
          "temp": item.temperature,
          "description": item.weatherDescription
        });
      }
      if ((item.weatherConditionCode ?? 0) >= 500 &&
          (item.weatherConditionCode ?? 0) <= 531) {
        //rain weather code 601 and icon color to white
        data.add({
          "icon": "assets/weather/rain.svg",
          "date": DateTime.parse(item.date.toString()),
          "temp": item.temperature,
          "description": item.weatherDescription
        });
      }
      if ((item.weatherConditionCode ?? 0) >= 200 &&
          (item.weatherConditionCode ?? 0) <= 202) {
        // thunderstorm weather code 200
        data.add({
          "icon": "assets/weather/thunder_rain.svg",
          "date": DateTime.parse(item.date.toString()),
          "temp": item.temperature,
          "description": item.weatherDescription
        });
      }
      if ((item.weatherConditionCode ?? 0) >= 601 &&
          (item.weatherConditionCode ?? 0) <= 622) {
        //snow weather code 601 and icon color to white
        data.add({
          "icon": "assets/weather/snow.svg",
          "date": DateTime.parse(item.date.toString()),
          "temp": item.temperature,
          "description": item.weatherDescription
        });
      }
      if ((item.weatherConditionCode ?? 0) >= 210 &&
          (item.weatherConditionCode ?? 0) <= 232) {
        //thunder only no storm weather code 211 and color to white
        data.add({
          "icon": "assets/weather/thunder.svg",
          "date": DateTime.parse(item.date.toString()),
          "temp": item.temperature,
          "description": item.weatherDescription
        });
      }
    }

    return data;
  }
}
