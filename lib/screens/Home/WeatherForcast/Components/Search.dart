import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:i_tour/services/WeatherService.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final searchTxt = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).copyWith().size.width;
    final height = MediaQuery.of(context).copyWith().size.height;
    return Container(
        width: width * 0.5,
        height: height * 0.055,
        margin: const EdgeInsets.all(0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color.fromARGB(255, 201, 210, 214)),
            color: const Color.fromARGB(255, 212, 218, 218)),
        child: Center(
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
                controller: searchTxt,
                // autofocus: true,
                style: DefaultTextStyle.of(context)
                    .style
                    .copyWith(fontStyle: FontStyle.normal),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: const Icon(Icons.abc_outlined),
                    iconColor: Colors.green,
                    hintText: "search place",
                    suffixIconColor: Colors.blueGrey,
                    suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.remove_circle)))),
            suggestionsCallback: (pattern) async {
              // var place = await PlacesAutocomplete.show(
              //     context: context,
              //     apiKey: "AIzaSyDURifysCOAlU4a7E1Z8DMTCrebTCHO-PQ",
              //     mode: Mode.overlay,
              //     types: [],
              //     strictbounds: false,
              //     // components: [Component(Component.country, 'np')],
              //     //google_map_webservice package
              //     onError: (err) {
              //       // print(err);
              //     });
              var results = await BackendService.getSuggestions(pattern);
              // print(results);
              return results;
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                // leading: Icon(Icons.shopping_cart),
                title: Text(suggestion['name']!),
                // subtitle: Text('\$${suggestion['price']}'),
              );
            },
            onSuggestionSelected: (suggestion) {
              print(suggestion);
            },
          ),
        ));
  }
}
