import 'country_list.dart';
import 'country_object.dart';

List<Country> generatePuzzle() {

  // picks random continent
  List<String> allContinents = ['Asia', 'Europe', 'Africa', 'South America', 'North America', 'Oceania'];
  allContinents.shuffle();

  String chosenContinent;
  List<Country> puzzleGroup = [];

  for (int i = 0; i < 4; i++) {
    chosenContinent = allContinents[i];

    // finds all the possible countries in the chosen continent
    List<Country> continentCountries = [];
    for (var country in allCountries) {
      if (country.continent == chosenContinent) {
        continentCountries.add(country);
      }
    }

    // picks 4 countries from new list
    continentCountries.shuffle();
    puzzleGroup.addAll(continentCountries.take(4).toList());
  }

  puzzleGroup.shuffle();

  return puzzleGroup;
}