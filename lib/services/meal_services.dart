import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import "dart:math";

class MealServices {
  dynamic barcodeScan() async {
    Map<String, Object> returnData = {
      "kcal": "",
      "brand": "",
      "product": "",
      "image": "",
      "errorBit": 1,
    };
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", false, ScanMode.DEFAULT);
    final response = await http.get(Uri.parse(
        "https://world.openfoodfacts.org/api/v0/product/$barcodeScanRes.json"));
    final data = json.decode(response.body);
    if (data["status"] != 1) {
      returnData["errorBit"] = 0;
    } else {
      returnData["kcal"] =
          data["product"]["nutriments"]["energy-kcal_100g"].toString();
      returnData["brand"] = data["product"]["brands"].toString();
      returnData["product"] = data["product"]["product_name"].toString();
      returnData["image"] = data["product"]["image_url"];
    }

    return returnData;
  }

  dynamic mealsByIngredients(String ingredients, String mealTime,
      {String calories = ""}) async {
    Map<String, Object> returnData = {"errorBit": 1, "recipeByIngr": []};
    var recipeByIngr = [];
    var data = {};
    if (calories == "") {
      final response = await http.get(Uri.parse(
          "https://api.edamam.com/api/recipes/v2?type=public&q=$ingredients&mealType=$mealTime&app_id=8a90a41c&app_key=cb7c02f76fb6df5035c927e3f2b3cbaa"));
      data = json.decode(response.body);
    } else {
      final response = await http.get(Uri.parse(
          "https://api.edamam.com/api/recipes/v2?type=public&q=$ingredients&mealType=$mealTime&calories=$calories&app_id=8a90a41c&app_key=cb7c02f76fb6df5035c927e3f2b3cbaa"));
      data = json.decode(response.body);
    }
    if (data["to"] < 1) {
      returnData["errorBit"] = 0;
    } else {
      List<int> rand =
          randomizer(data["to"], min(3, int.parse(data["to"].toString())));
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

  dynamic randomRecipeCheatDay() async {
    Map<String, Object> returnData = {"errorBit": 1, "cheatDay": {}};
    try {
      final response = await http
          .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));
      final data = json.decode(response.body);
      returnData["cheatDay"] = data["meals"][0];
    } catch (e) {
      returnData["errorBit"] = 0;
    }
    return returnData;
  }

  dynamic recipeAnalysis(String ingredients) async {
    Map<String, Object> returnData = {"errorBit": 1, "analysisResult": {}};
    List<String> ingrBody = ingredients.split("\n");
    var payload = json.encode({"ingr": ingrBody});

    final response = await http.post(
        Uri.parse(
            "https://api.edamam.com/api/nutrition-details?app_id=96a68843&app_key=ec285d3bedaa2b44b827740d126f3dd8"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body: payload);
    final data = json.decode(response.body);
    try {
      returnData["analysisResult"] = data["totalNutrients"];
    } catch (e) {
      returnData["errorBit"] = 0;
    }
    return returnData;
  }
}
