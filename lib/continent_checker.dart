import 'package:flutter/material.dart';
import 'country_object.dart';

void checkContinentGroup({
  required BuildContext context,
  required List<Country> selectedCountries,
  required Function(List<Country>) onSuccess,
  required Function() onFailure,
}) {
  if (selectedCountries.length != 4) {
    return;
  }

  String targetContinent = selectedCountries[0].continent;

  bool allMatch = true;

  for (Country country in selectedCountries) {
    if (country.continent != targetContinent) {
      allMatch = false;
      break;
    }
  }

  if (allMatch) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Good job! The category was countries in $targetContinent."))
    );
    onSuccess(selectedCountries);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Try again!")),
    );
    onFailure();
  }
}
