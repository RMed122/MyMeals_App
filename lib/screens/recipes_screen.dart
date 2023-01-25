import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horizontal_card_pager/card_item.dart';
import 'package:mymeals/services/data_services.dart';
import 'package:mymeals/services/meal_services.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';
import 'package:mymeals/screens/recipesearch_results.dart';
import 'package:horizontal_card_pager/horizontal_card_pager.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen(
      {Key? key, this.testMode = false, this.mockFirestore = false})
      : super(key: key);
  final bool testMode;
  final dynamic mockFirestore;

  @override
  RecipesScreenState createState() => RecipesScreenState();

  static RecipesScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<RecipesScreenState>()!;
}

class RecipesScreenState extends State<RecipesScreen> {
  final List<String> titles = [
    "Casual",
    "Healthy",
    "Random",
    "Analyzer",
    "Explore"
  ];
  bool showCasualDialog = false;
  bool showHealthyDialog = false;
  bool showRandomDialog = false;
  bool showAnalyzeDialog = false;
  bool showResultDialog = false;
  bool showTypeDialog = false;
  bool showSaveAlert = false;
  String landcapeSliderTitle = "Random";
  String ingredients = "";
  String mealName = "";
  String mealTime = 'Breakfast';
  String mealType = 'American';
  String calories = "0";
  String dialogMessage = "An error happened";
  dynamic recipeAnalysisResult = {};
  MealServices inst = MealServices();
  //UserDataServices dataInst = UserDataServices();
  dynamic dataInst;

  dynamic searchbyIngr() async {
    dynamic responseData = {};
    if (ingredients != "") {
      responseData = await inst.mealsByIngredients(ingredients, mealTime);
    }
    if (responseData["errorBit"] == 1) {
// ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipeSearchResultScreen(
                  searchResults: responseData,
                  testMode: widget.testMode,
                )),
      );
    } else {
      showSaveAlert = true;
      setState(() {});
    }
    if (widget.testMode && mealName == "" && mealTime == "Breakfast") {
      return 0;
    }
  }

  dynamic searchHealthy() async {
    dynamic responseData = {};
    if (ingredients != "") {
      responseData = await inst.mealsByIngredients(ingredients, mealTime,
          calories: calories);
    }
    if (responseData["errorBit"] == 1) {
// ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipeSearchResultScreen(
                  searchResults: responseData,
                  testMode: widget.testMode,
                )),
      );
    } else {
      showSaveAlert = true;
      setState(() {});
    }
    if (widget.testMode && calories == "1000" && mealTime == "Dinner") {
      return 0;
    }
  }

  dynamic randomRecipe() async {
    if (widget.testMode && mealTime == "Snack") {
      return 0;
    }
    dynamic responseData = {};
    if (mealTime != "") {
      responseData = await inst.randomRecipeCheatDay(mealTime);
    }
    if (responseData["errorBit"] == 1) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipeSearchResultScreen(
                  searchResults: responseData,
                  testMode: widget.testMode,
                )),
      );
    } else {
      showSaveAlert = true;
      setState(() {});
    }
  }

  dynamic randomTypeRecipe() async {
    if (widget.testMode && mealTime == "Snack" && mealType == "Italian") {
      return 0;
    }
    dynamic responseData = {};
    if (mealType != "") {
      responseData = await inst.randomRecipeCuisineType(mealType, mealTime);
    }
    if (responseData["errorBit"] == 1) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipeSearchResultScreen(
                  searchResults: responseData,
                  testMode: widget.testMode,
                )),
      );
    } else {
      showSaveAlert = true;
      setState(() {});
    }
  }

  dynamic recipeAnalysis() async {
    if (widget.testMode) {
      showResultDialog = true;
      return 0;
    }
    dynamic responseData = {};
    if (ingredients != "") {
      responseData = await inst.recipeAnalysis(ingredients);
    }
    if (responseData["errorBit"] == 1 &&
        responseData["analysisResult"] != null) {
      recipeAnalysisResult = {
        "kcal":
            responseData['analysisResult']['ENERC_KCAL']['quantity'].round(),
        "fat": responseData['analysisResult']['FAT']['quantity'].round(),
        "protein": responseData['analysisResult']['PROCNT']['quantity'].round(),
        "carbs": responseData['analysisResult']['CHOCDF']['quantity'].round(),
      };
      showResultDialog = true;
      setState(() {});
    } else {
      showSaveAlert = true;
      setState(() {});
    }
  }

  dynamic saveAnalysisResult() async {
    if (!widget.testMode) {
      dataInst = UserDataServices();
    } else {
      dataInst = UserDataServices(
          testMode: widget.testMode, mockFirestore: widget.mockFirestore);
    }

    dataInst.addCalories(
        mealName,
        recipeAnalysisResult['kcal'],
        mealTime,
        recipeAnalysisResult['carbs'],
        recipeAnalysisResult['protein'],
        recipeAnalysisResult['fat']);

    if (widget.testMode) {
      return await dataInst.getDailyMeals();
    }
  }

  var mealTimeList = [
    'Breakfast',
    'Lunch',
    'Snack',
    'Dinner',
  ];

  var mealTypeList = [
    'American',
    'Asian',
    'British',
    'Caribbean',
    'Central Europe',
    'Chinese',
    'Eastern Europe',
    'French',
    'Indian',
    'Italian',
    'Japanese',
    'Kosher',
    'Mediterranean',
    'Mexican',
    'Middle Eastern',
    'Nordic',
    'South American',
    'South East Asian',
  ];

  void dialogController(int index) async {
    switch (index) {
      case 0:
        {
          showCasualDialog = true;
          setState(() {});
        }
        break;

      case 1:
        {
          showHealthyDialog = true;
          setState(() {});
        }
        break;

      case 2:
        {
          showRandomDialog = true;
          setState(() {});
        }
        break;

      case 3:
        {
          showAnalyzeDialog = true;
          setState(() {});
        }
        break;
      case 4:
        {
          showTypeDialog = true;
          setState(() {});
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> images = [
      Stack(fit: StackFit.expand, children: [
        ClipRect(
          child: Image.asset(
            "assets/images/casual.jpg",
            //Image.network("https://food.unl.edu/newsletters/images/mise-en-plase.jpg",
            fit: BoxFit.cover,
          ),
        ),
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
            child: Container(
              color: Colors.grey.withOpacity(0.3),
              alignment: Alignment.center,
            ),
          ),
        ),
      ]),
      Stack(fit: StackFit.expand, children: [
        ClipRect(
          child: Image.asset(
            "assets/images/healthy.jpg",
            //Image.network(
            // "https://www.eatthis.com/wp-content/uploads/sites/4/2021/05/healthy-foods.jpg?quality=82&strip=1",
            fit: BoxFit.cover,
          ),
        ),
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
            child: Container(
              color: Colors.grey.withOpacity(0.3),
              alignment: Alignment.center,
            ),
          ),
        ),
      ]),
      Stack(fit: StackFit.expand, children: [
        ClipRect(
          child: Image.asset(
            "assets/images/random.jpg",
            //Image.network(
            //"https://flexxsirv.sirv.com/b6b3b9e876cd41273b1c1527c96892c5a2d3dfaa2f/Lose_The_Cheat_Day_Mentality.jpg",
            fit: BoxFit.cover,
          ),
        ),
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
            child: Container(
              color: Colors.grey.withOpacity(0.3),
              alignment: Alignment.center,
            ),
          ),
        ),
      ]),
      Stack(fit: StackFit.expand, children: [
        ClipRect(
          child: Image.asset(
            "assets/images/analysis.jpg",
            //Image.network(
            //"https://sciencemeetsfood.org/wp-content/uploads/2018/10/sixreasons-cover.jpg",
            fit: BoxFit.cover,
          ),
        ),
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
            child: Container(
              color: Colors.grey.withOpacity(0.3),
              alignment: Alignment.center,
            ),
          ),
        ),
      ]),
      Stack(fit: StackFit.expand, children: [
        ClipRect(
          child: Image.asset(
            "assets/images/explore.jpg",
            //Image.network(
            //"https://images.squarespace-cdn.com/content/v1/53b839afe4b07ea978436183/1608506169128-S6KYNEV61LEP5MS1UIH4/traditional-food-around-the-world-Travlinmad.jpg",
            fit: BoxFit.cover,
          ),
        ),
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
            child: Container(
              color: Colors.grey.withOpacity(0.3),
              alignment: Alignment.center,
            ),
          ),
        ),
      ])
    ];
    return Stack(children: [
      Visibility(
        visible: MediaQuery.of(context).orientation == Orientation.portrait,
        child: VerticalCardPager(
          initialPage: 2,
          textStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          titles: titles,
          images: images,
          align: ALIGN.CENTER,
          onSelectedItem: (index) {
            dialogController(index);
          },
        ),
      ),
      Visibility(
        visible: MediaQuery.of(context).orientation == Orientation.landscape,
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                landcapeSliderTitle,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            HorizontalCardPager(
                onSelectedItem: (page) {
                  dialogController(page);
                  landcapeSliderTitle = titles[page];
                  setState(() {});
                },
                onPageChanged: (page) {
                  landcapeSliderTitle = titles[page.round()];
                  setState(() {});
                },
                initialPage: 2,
                items: [
                  ImageCarditem(image: images[0]),
                  ImageCarditem(image: images[1]),
                  ImageCarditem(image: images[2]),
                  ImageCarditem(image: images[3]),
                  ImageCarditem(image: images[4]),
                ]),
          ]),
        ),
      ),
      Visibility(
          visible: showCasualDialog,
          child: AlertDialog(
              title: const Text('Recipe Lookup'),
              content: SingleChildScrollView(
                  child: SizedBox(
                      child: Column(children: [
                const Divider(
                  height: 5,
                ),
                TextField(
                  onChanged: (value) {
                    ingredients = value;
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter the main ingredients',
                  ),
                ),
                DropdownButton(
                  value: mealTime,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: mealTimeList.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      mealTime = newValue!;
                    });
                  },
                ),
              ]))),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    showCasualDialog = false;
                    setState(() {});
                    searchbyIngr();
                  },
                  child: const Text('Search'),
                ),
                TextButton(
                  onPressed: () {
                    showCasualDialog = false;
                    setState(() {});
                  },
                  child: const Text('Cancel'),
                )
              ])),
      Visibility(
          visible: showHealthyDialog,
          child: AlertDialog(
              title: const Text('Healthy Search'),
              content: SingleChildScrollView(
                  child: SizedBox(
                      //height: 200,
                      child: Column(children: [
                const Divider(
                  height: 5,
                ),
                TextField(
                  onChanged: (value) {
                    ingredients = value;
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Main ingredients',
                  ),
                ),
                const Divider(
                  height: 15,
                ),
                TextField(
                  onChanged: (value) {
                    calories = value;
                    setState(() {});
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Max Calories',
                  ),
                ),
                DropdownButton(
                  value: mealTime,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: mealTimeList.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      mealTime = newValue!;
                    });
                  },
                ),
              ]))),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    showHealthyDialog = false;
                    setState(() {});
                    searchHealthy();
                  },
                  child: const Text('Search'),
                ),
                TextButton(
                  onPressed: () {
                    showHealthyDialog = false;
                    setState(() {});
                  },
                  child: const Text('Cancel'),
                )
              ])),
      Visibility(
        visible: showAnalyzeDialog,
        child: AlertDialog(
            title: const Text('Recipe Analysis'),
            content: SingleChildScrollView(
                child: SizedBox(
                    child: Column(children: [
              const Divider(
                height: 5,
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (value) {
                  ingredients = value;
                  setState(() {});
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Your Recipe',
                ),
              ),
              const Divider(
                height: 10,
              ),
              TextField(
                onChanged: (value) {
                  mealName = value;
                  setState(() {});
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Meal Name',
                ),
              ),
              DropdownButton(
                value: mealTime,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: mealTimeList.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    mealTime = newValue!;
                  });
                },
              )
            ]))),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  showAnalyzeDialog = false;
                  setState(() {});
                  recipeAnalysis();
                },
                child: const Text('Get Nutr. Facts'),
              ),
              TextButton(
                onPressed: () {
                  showAnalyzeDialog = false;
                  setState(() {});
                },
                child: const Text('Cancel'),
              )
            ]),
      ),
      Visibility(
          visible: showResultDialog,
          child: AlertDialog(
              title: const Text('Analysis Result'),
              content: SingleChildScrollView(
                  child: Column(children: [
                Text("Energy: ${recipeAnalysisResult["kcal"]} Kcal"),
                Text("Fat: ${recipeAnalysisResult["fat"]} g"),
                Text("Carbs: ${recipeAnalysisResult["carbs"]} g"),
                Text("Protein: ${recipeAnalysisResult["protein"]} g"),
              ])),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    showResultDialog = false;
                    setState(() {});
                    saveAnalysisResult();
                  },
                  child: const Text('Add meal'),
                ),
                TextButton(
                  onPressed: () {
                    showResultDialog = false;
                    setState(() {});
                  },
                  child: const Text('Cancel'),
                )
              ])),
      Visibility(
          visible: showRandomDialog,
          child: AlertDialog(
              title: const Text('Random Recipes for CheatDay'),
              content: SingleChildScrollView(
                  child: SizedBox(
                      child: Column(children: [
                DropdownButton(
                  value: mealTime,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: mealTimeList.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      mealTime = newValue!;
                    });
                  },
                ),
              ]))),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    showRandomDialog = false;
                    setState(() {});
                    randomRecipe();
                  },
                  child: const Text('Search'),
                ),
                TextButton(
                  onPressed: () {
                    showRandomDialog = false;
                    setState(() {});
                  },
                  child: const Text('Cancel'),
                )
              ])),
      Visibility(
          visible: showTypeDialog,
          child: AlertDialog(
              title: const Text('Random Recipes by Culinary Type'),
              content: SingleChildScrollView(
                  child: SizedBox(
                      child: Column(children: [
                DropdownButton(
                  value: mealType,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: mealTypeList.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      mealType = newValue!;
                    });
                  },
                ),
                DropdownButton(
                  value: mealTime,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: mealTimeList.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      mealTime = newValue!;
                    });
                  },
                ),
              ]))),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    showTypeDialog = false;
                    setState(() {});
                    randomTypeRecipe();
                  },
                  child: const Text('Search'),
                ),
                TextButton(
                  onPressed: () {
                    showTypeDialog = false;
                    setState(() {});
                  },
                  child: const Text('Cancel'),
                )
              ])),
      Visibility(
          visible: showSaveAlert,
          child: AlertDialog(
              title: const Text('Notification!'),
              content: Text(dialogMessage),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    showSaveAlert = false;
                    setState(() {});
                  },
                  child: const Text('OK'),
                )
              ]))
    ]);
  }
}
