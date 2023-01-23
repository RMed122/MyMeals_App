import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:horizontal_card_pager/card_item.dart';
import 'package:horizontal_card_pager/horizontal_card_pager.dart';
import 'package:mymeals/model/recipe.dart';
import 'package:mymeals/screens/recipe_details_screen.dart';
import 'package:mymeals/widget/bottom_navbar.dart';
import 'package:mymeals/widget/main_drawer.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

class RecipeSearchResultScreen extends StatefulWidget {
  const RecipeSearchResultScreen(
      {super.key, required this.searchResults, this.testMode = false});
  final Map<String, Object> searchResults;
  final bool testMode;

  @override
  RecipeSearchResultScreenState createState() =>
      RecipeSearchResultScreenState();

  static RecipeSearchResultScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<RecipeSearchResultScreenState>()!;
}

class RecipeSearchResultScreenState extends State<RecipeSearchResultScreen> {
  List<String> titles = [];
  List<Widget> images = [];
  List<CardItem> imagesCards = [];
  String landcapeSliderTitle = "";

  @override
  void initState() {
    super.initState();
    initRecipeCards();
  }

  dynamic testImagehandler(dynamic meal) {
    if (!widget.testMode) {
      return Image.network(
        meal["image"],
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset("assets/images/casual.jpg");
    }
  }

  void initRecipeCards() {
    dynamic data = widget.searchResults["recipeByIngr"];
    if (data != null) {
      for (var meal in data) {
        Widget imageToAdd = Stack(fit: StackFit.expand, children: [
          ClipRect(child: testImagehandler(meal)
              // Image.network(
              //   meal["image"],
              //   fit: BoxFit.cover,
              // ),
              ),
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.35, sigmaY: 0.35),
              child: Container(
                color: Colors.grey.withOpacity(0.35),
                alignment: Alignment.center,
              ),
            ),
          ),
        ]);
        titles.add(meal["label"]);
        images.add(imageToAdd);
        imagesCards.add(ImageCarditem(image: imageToAdd));
      }
      landcapeSliderTitle = titles[2];
      setState(() {});
    }
  }

  dynamic seeRecipeDetails(int index) {
    dynamic data = {};
    data = widget.searchResults["recipeByIngr"];
    data = data[index];
    dynamic data_nutr = data['totalNutrients'];
    List<Map<String, Object>> ingridients = [];
    List<Map<String, Object>> nutriments = [];
    List nutriments_inc = ["ENERC_KCAL", "FAT", 'CHOCDF', 'PROCNT'];

    for (var ingr in data["ingredients"]) {
      ingridients.add({'name': ingr['food'], 'size': ingr['text']});
    }

    nutriments
        .add({'name': "Portions", 'size': data['yield'].round().toString()});
    nutriments.add({
      'name': "Calories per portion",
      'size': (data_nutr["ENERC_KCAL"]['quantity'] / 4).round().toString() +
          data_nutr["ENERC_KCAL"]['unit'],
    });

    for (var nutr in nutriments_inc) {
      nutriments.add({
        'name': data_nutr[nutr]["label"],
        'size': data_nutr[nutr]['quantity'].round().toString() +
            data_nutr[nutr]['unit']
      });
    }

    Recipe recipeToShow = Recipe(
      title: data['label'],
      photo: data['image'],
      calories: data_nutr["ENERC_KCAL"]['quantity'].round().toString() +
          data_nutr["ENERC_KCAL"]['unit'],
      time: data['totalTime'].toString(),
      description: data['url'],
      mealTime: data['mealType'][0].toString(),
      ingridients: Ingridient.toList(ingridients),
      nutriments: Ingridient.toList(nutriments),
    );

    if (widget.testMode) {
      return recipeToShow;
    }

    //ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RecipeDetailScreen(data: recipeToShow)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      drawer: MainDrawer(
        testMode: widget.testMode,
      ),
      bottomNavigationBar: BottomNavBar(
        testMode: widget.testMode,
      ),
      body: Stack(
        children: [
          Visibility(
            visible: MediaQuery.of(context).orientation == Orientation.portrait,
            child: VerticalCardPager(
              initialPage: 1,
              textStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              titles: titles,
              images: images,
              align: ALIGN.CENTER,
              onSelectedItem: (index) {
                seeRecipeDetails(index);
              },
            ),
          ),
          Visibility(
            visible:
                MediaQuery.of(context).orientation == Orientation.landscape,
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                          seeRecipeDetails(page);
                          landcapeSliderTitle = titles[page];
                          setState(() {});
                        },
                        onPageChanged: (page) {
                          landcapeSliderTitle = titles[page.round()];
                          setState(() {});
                        },
                        initialPage: 2,
                        items: imagesCards),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
