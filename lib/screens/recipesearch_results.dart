import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mymeals/model/recipe.dart';
import 'package:mymeals/screens/recipe_details_screen.dart';
import 'package:mymeals/widget/bottom_navbar.dart';
import 'package:mymeals/widget/main_drawer.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

class RecipeSearchResultScreen extends StatefulWidget {
  const RecipeSearchResultScreen({super.key, required this.searchResults});
  final Map<String, Object> searchResults;

  @override
  _RecipeSearchResultScreenState createState() =>
      _RecipeSearchResultScreenState();

  static _RecipeSearchResultScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<_RecipeSearchResultScreenState>()!;
}

class _RecipeSearchResultScreenState extends State<RecipeSearchResultScreen> {
  List<String> titles = [];
  List<Widget> images = [];

  @override
  void initState() {
    super.initState();
    initRecipeCards();
  }

  void initRecipeCards() {
    dynamic data = widget.searchResults["recipeByIngr"];
    if (data != null) {
      for (var meal in data) {
        titles.add(meal["label"]);
        images.add(Stack(fit: StackFit.expand, children: [
          ClipRect(
            child: Image.network(
              meal["image"],
              fit: BoxFit.cover,
            ),
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
        ]));
      }
    }
  }

  void seeRecipeDetails(int index) {
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
      drawer: MainDrawer(),
      bottomNavigationBar: BottomNavBar(),
      body: VerticalCardPager(
        initialPage: 1,
        textStyle:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        titles: titles,
        images: images,
        align: ALIGN.CENTER,
        onSelectedItem: (index) {
          seeRecipeDetails(index);
        },
      ),
    );
  }
}
