import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/auto_complete_result.dart';

final placeResultsProvider = ChangeNotifierProvider<PlaceResults>((ref) {
  return PlaceResults();
});
final peopleResultsProvider = ChangeNotifierProvider<PeopleResults>((ref) {
  return PeopleResults();
});

final searchToggleProvider = ChangeNotifierProvider<SearchToggle>((ref) {
  return SearchToggle();
});
final searchPeopleToggleProvider =
    ChangeNotifierProvider<SearchPeopleToggle>((ref) {
  return SearchPeopleToggle();
});

class PlaceResults extends ChangeNotifier {
  List<AutoCompleteResult> allReturnedResults = [];

  void setResults(allPlaces) {
    allReturnedResults = allPlaces;
    notifyListeners();
  }
}

class PeopleResults extends ChangeNotifier {
  List allReturnedResults = [];

  void setResults(allPlaces) {
    allReturnedResults = allPlaces;
    notifyListeners();
  }
}

class SearchToggle extends ChangeNotifier {
  bool searchToggle = false;

  void toggleSearch() {
    searchToggle = !searchToggle;
    notifyListeners();
  }
}

class SearchPeopleToggle extends ChangeNotifier {
  bool searchToggle = false;

  void toggleSearch() {
    searchToggle = !searchToggle;
    notifyListeners();
  }
}
