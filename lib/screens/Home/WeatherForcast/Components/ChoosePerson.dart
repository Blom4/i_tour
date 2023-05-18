import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_tour/constants/constants.dart';
import 'package:i_tour/logic/firebase_auth.dart';
import 'package:i_tour/screens/Home/WeatherForcast/Constants.dart';
import 'package:i_tour/screens/Home/WeatherForcast/logic/GetWeather_logic.dart';
import 'package:i_tour/store/store.dart';

class ChoosePerson extends StatefulWidget {
  const ChoosePerson({Key? key}) : super(key: key);

  @override
  State<ChoosePerson> createState() => _ChoosePersonState();
}

class _ChoosePersonState extends State<ChoosePerson> {
  Map? selectedValue;
  final Store store = Get.find<Store>();
  @override
  void initState() {
    super.initState();
    firebaseInstance
        .collection('User')
        .where("email", isEqualTo: Auth().currentUser!.email!.toLowerCase())
        .get()
        .then((value) {
      setState(() {
        monitorRecipients.add({
          "full_name": value.docs.first.data()['full_name'],
          "email": value.docs.first.data()['email']
        });
        store.getWeather.selectPerson = monitorRecipients.first;
        store.update();
      });
    });
    GetWeather().fetchMonitoringPeople().then((data) => setState(
          () {
            monitorRecipients.addAll(data);
          },
        ));
    // store.getWeather.selectPerson = monitorRecipients[0]['email'];
    // store.update();
    // print(monitorRecipients);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: store,
        builder: (_) {
          return DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              hint: Row(
                children: const [
                  Icon(
                    Icons.list,
                    size: 16,
                    color: Colors.yellow,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Text(
                      'Choose',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              items: monitorRecipients
                  .map((item) => DropdownMenuItem<Map>(
                        value: item,
                        child: Text(
                          item['full_name'] ?? "",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
              value: selectedValue,
              onChanged: (value) async {
                setState(() {
                  selectedValue = value;
                });
                store.getWeather.selectPerson = value;

                store.update();
              },
              buttonStyleData: ButtonStyleData(
                height: 50,
                width: 120,
                padding: const EdgeInsets.only(left: 14, right: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.black26,
                  ),
                  color: const Color.fromARGB(255, 19, 127, 141),
                ),
                elevation: 2,
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
                iconSize: 14,
                iconEnabledColor: Colors.yellow,
                iconDisabledColor: Colors.grey,
              ),
              dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  width: 200,
                  padding: null,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: const Color.fromARGB(255, 47, 183, 224),
                  ),
                  elevation: 8,
                  offset: const Offset(-20, 0),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: MaterialStateProperty.all(6),
                    thumbVisibility: MaterialStateProperty.all(true),
                  )),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
                padding: EdgeInsets.only(left: 14, right: 14),
              ),
            ),
          );
        });
  }
}
