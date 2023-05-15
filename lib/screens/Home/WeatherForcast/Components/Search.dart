import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:i_tour/services/WeatherService.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).copyWith().size.width;
    final height = MediaQuery.of(context).copyWith().size.height;
    return Container(
        width: width * 0.5,
        height: height * 0.06,
        margin: const EdgeInsets.all(0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border:
                Border.all(color: const Color.fromARGB(255, 201, 210, 214)),
            color: const Color.fromARGB(255, 212, 218, 218)),
        child: TypeAheadField(
          
          textFieldConfiguration: TextFieldConfiguration(
              autofocus: true,
              style: DefaultTextStyle.of(context)
                  .style
                  .copyWith(fontStyle: FontStyle.italic),
              decoration: const InputDecoration(border: InputBorder.none)),
          suggestionsCallback: (pattern) async {
            return await BackendService.getSuggestions(pattern);
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
        ));
  }
}
