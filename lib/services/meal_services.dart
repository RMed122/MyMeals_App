import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import "dart:math";

class MealServices {
  // //DEV
  // final String _devRecipesAppID = "8a90a41c";
  // final String _devRecipesKey = "cb7c02f76fb6df5035c927e3f2b3cbaa";

  // final String _devNutriAppID = "96a68843";
  // final String _devNutriKey = "ec285d3bedaa2b44b827740d126f3dd8";

  //Demo
  final String _devRecipesAppID = "d4ab6f06";
  final String _devRecipesKey = "ca16ef74cd404265cad30e26a192b5aa";

  final String _devNutriAppID = "03e8c8b8";
  final String _devNutriKey = "a8483822bd410870f53ef35648d49dee";

  dynamic barcodeScan({manualMode = false, manualBarcode = ""}) async {
    Map<String, Object> returnData = {
      "calories": 0,
      "fat": 0,
      "carbs": 0,
      "protein": 0,
      "brand": "",
      "product": "",
      "image": "",
      "errorBit": 1,
    };
    String barcodeScanRes;
    if (manualMode) {
      barcodeScanRes = manualBarcode;
    } else {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", false, ScanMode.DEFAULT);
    }

    final response = await http.get(Uri.parse(
        "https://world.openfoodfacts.org/api/v0/product/$barcodeScanRes.json"));
    final data = json.decode(utf8.decode(response.bodyBytes));
    if (data["status"] != 1) {
      returnData["errorBit"] = 0;
    } else {
      returnData["brand"] = data["product"]["product_name"].toString();
      returnData["product"] = data["product"]["product_name"].toString();
      returnData["image"] = data["product"]["image_url"];
      returnData["calories"] =
          data["product"]["nutriments"]["energy-kcal_100g"].round();
      returnData["protein"] =
          data["product"]["nutriments"]["proteins_100g"].round();
      returnData["fat"] = data["product"]["nutriments"]["fat_100g"].round();
      returnData["carbs"] =
          data["product"]["nutriments"]["carbohydrates_100g"].round();
    }

    return returnData;
  }

  dynamic mealsByIngredients(String ingredients, String mealTime,
      {String calories = ""}) async {
    Map<String, Object> returnData = {"errorBit": 1, "recipeByIngr": []};
    var recipeByIngr = [];
    var data = {};
    String rangeCalories = "0-$calories";
    if (calories == "") {
      final response = await http.get(Uri.parse(
          "https://api.edamam.com/api/recipes/v2?type=public&q=$ingredients&mealType=$mealTime&random=true&app_id=$_devRecipesAppID&app_key=$_devRecipesKey"));
      data = json.decode(utf8.decode(response.bodyBytes));
    } else {
      final response = await http.get(Uri.parse(
          "https://api.edamam.com/api/recipes/v2?type=public&q=$ingredients&mealType=$mealTime&random=true&calories=$rangeCalories&app_id=$_devRecipesAppID&app_key=$_devRecipesKey"));
      data = json.decode(utf8.decode(response.bodyBytes));
    }
    if (data["to"] < 1) {
      returnData["errorBit"] = 0;
    } else {
      List<int> rand =
          randomizer(data["to"], min(7, int.parse(data["to"].toString())));
      for (int i in rand) {
        recipeByIngr.add(data["hits"][i]["recipe"]);
      }
      returnData["recipeByIngr"] = recipeByIngr;
    }
    return returnData;
  }

  List<int> randomizer(int maxi, int n) {
    List<int> randInts = [];
    for (int i = 0; i < n; i++) {
      int toAdd = Random().nextInt(maxi - 1);
      while (randInts.contains(toAdd)) {
        toAdd = Random().nextInt(maxi - 1);
      }
      randInts.add(toAdd);
    }
    return randInts;
  }

  dynamic randomRecipeCheatDay(String mealTime) async {
    Map<String, Object> returnData = {"errorBit": 1, "recipeByIngr": []};
    var recipeByIngr = [];
    var data = {};
    String calories = "400-1700";

    final response = await http.get(Uri.parse(
        "https://api.edamam.com/api/recipes/v2?type=public&mealType=$mealTime&calories=$calories&random=true&app_id=$_devRecipesAppID&app_key=$_devRecipesKey"));
    //  data = json.decode(utf8.decode(response.bodyBytes));
    data = json.decode(utf8.decode(response.bodyBytes));

    if (data["to"] < 1) {
      returnData["errorBit"] = 0;
    } else {
      List<int> rand =
          randomizer(data["to"], min(7, int.parse(data["to"].toString())));
      for (int i in rand) {
        recipeByIngr.add(data["hits"][i]["recipe"]);
      }
      returnData["recipeByIngr"] = recipeByIngr;
    }
    return returnData;
  }

  dynamic randomRecipeCuisineType(String cuisineType, String mealTime) async {
    Map<String, Object> returnData = {"errorBit": 1, "recipeByIngr": []};
    var recipeByIngr = [];
    var data = {};
    String calories = "0-2500";

    final response = await http.get(Uri.parse(
        "https://api.edamam.com/api/recipes/v2?type=public&cuisineType=$cuisineType&mealType=$mealTime&calories=$calories&random=true&app_id=$_devRecipesAppID&app_key=$_devRecipesKey"));
    data = json.decode(utf8.decode(response.bodyBytes));

    if (data["to"] < 1) {
      returnData["errorBit"] = 0;
    } else {
      List<int> rand =
          randomizer(data["to"], min(7, int.parse(data["to"].toString())));
      for (int i in rand) {
        recipeByIngr.add(data["hits"][i]["recipe"]);
      }
      returnData["recipeByIngr"] = recipeByIngr;
    }
    return returnData;
  }

  dynamic recipeAnalysis(String ingredients) async {
    Map<String, Object> returnData = {"errorBit": 1, "analysisResult": {}};
    List<String> ingrBody = ingredients.split("\n");
    var payload = json.encode({"ingr": ingrBody});

    final response = await http.post(
        Uri.parse(
            "https://api.edamam.com/api/nutrition-details?app_id=$_devNutriAppID&app_key=$_devNutriKey"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body: payload);
    final data = json.decode(utf8.decode(response.bodyBytes));
    try {
      returnData["analysisResult"] = data["totalNutrients"];
    } catch (e) {
      returnData["errorBit"] = 0;
    }
    return returnData;
  }
}
