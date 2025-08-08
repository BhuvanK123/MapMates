import 'package:flutter/material.dart';
import 'continent_checker.dart';
import 'country_object.dart';
import 'puzzle_generator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Country> puzzle = [];
  List<Country> selectedCountries = [];
  Set<Country> correctCountries = {};

  @override
  void initState() {
    super.initState();
    puzzle = generatePuzzle();
  }

  void refreshPuzzle() {
    setState(() {
      puzzle = generatePuzzle();
      selectedCountries.clear();
      correctCountries.clear();

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('New puzzle loaded!'))
      );

    });
  }

  void handleCountryTap(countryButton) {
    if (selectedCountries.contains(countryButton)) {
      selectedCountries.remove(countryButton);
    } else {
      if (selectedCountries.length < 4) {
        selectedCountries.add(countryButton);
      }
    }

    if (selectedCountries.length == 4) {

      checkContinentGroup(
        context: context,
        selectedCountries: selectedCountries,
        onSuccess: (matchedGroup) {
          setState(() {
            correctCountries.addAll(matchedGroup);
            selectedCountries.clear();
          });
        },
        onFailure: () {
          setState(() {
            selectedCountries.clear();
          });
        },
      );

    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("MapMates"),
        backgroundColor: Colors.greenAccent,
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          const minWidth = 300.0;
          const minHeight = 500.0;

          if (constraints.maxWidth < minWidth ||
              constraints.maxHeight < minHeight) {
            return Center(
              child: Text(
                '⚠️ Screen size is too small.\nPlease adjust it to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          }
          return Center(
            child: Column(
              children: [
                SizedBox(
                  width: 400,
                  height: 400,
                  child: GridView.builder(
                    itemCount: puzzle.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            correctCountries.contains(puzzle[index])
                                ? Colors.green[300]
                                : selectedCountries.contains(puzzle[index])
                                ? Colors.grey[400]
                                : Colors.grey[200],
                          ),
                          padding: WidgetStateProperty.all(EdgeInsets.zero),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero, // No rounding
                            ),
                          ),
                        ),
                        onPressed: correctCountries.contains(puzzle[index])
                            ? null // Disable button if correct
                            : () => handleCountryTap(puzzle[index]),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              puzzle[index].name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: ElevatedButton(
                    onPressed: refreshPuzzle,
                    child: Text('New Puzzle'),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
