import 'dart:convert';

import 'package:i_tour/models/auto_complete_result.dart';
import 'package:http/http.dart' as http;

Future<List<AutoCompleteResult>> searchPlaces(String searchInput) async {
  final String apiKey = 'YOUR_API_KEY';
  final String autocompleteUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchInput&key=$apiKey';

  var autocompleteResponse = await http.get(Uri.parse(autocompleteUrl));
  var autocompleteJson = jsonDecode(autocompleteResponse.body);

  var predictions = autocompleteJson['predictions'] as List<dynamic>;

  var placeDetailsUrl =
      'https://maps.googleapis.com/maps/api/place/details/json?key=$apiKey';

  List<AutoCompleteResult> results = [];

  for (var prediction in predictions) {
    String placeId = prediction['place_id'];
    String description = prediction['description'];

    var placeDetailsResponse =
        await http.get(Uri.parse('$placeDetailsUrl&place_id=$placeId'));
    var placeDetailsJson = jsonDecode(placeDetailsResponse.body);

    if (placeDetailsJson['status'] == 'OK') {
      results.add(AutoCompleteResult(
        description: description,
        placeId: placeId,
        // Include additional place details as needed
      ));
    }
  }

  return results;
}
