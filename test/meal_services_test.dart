import 'package:mymeals/services/meal_services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Meal Services', () {
    test("Barcode Scanning handles not found product", () async {
      dynamic responseData = await MealServices()
          .barcodeScan(testMode: true, testBarcode: "FALSE BARCODE");
      expect(responseData['errorBit'], 0);
    });

    test("Barcode Scanning returns product information", () async {
      dynamic responseData = await MealServices()
          .barcodeScan(testMode: true, testBarcode: "8002330009533");
      expect(responseData['kcal'], greaterThanOrEqualTo(0));
      expect(responseData['errorBit'], 1);
    });
    test('Random Recipe Function Request does not generate exception',
        () async {
      dynamic responseData = await MealServices().randomRecipeCheatDay("lunch");
      expect(responseData['errorBit'], 1);
    });

    test('Random Recipe Function returns an actual meal', () async {
      dynamic responseData = await MealServices().randomRecipeCheatDay("lunch");
      expect(responseData['cheatDay']['idMeal'], isNotNull);
      expect(responseData['errorBit'], 1);
    });

    test('Meals by Ingredients Function handles bad ingredients', () async {
      dynamic responseData = await MealServices()
          .mealsByIngredients("TextToGenerateError", "dinner");
      expect(responseData['errorBit'], 0);
    });

    test('Meals by Ingredients Function returns an actual meal', () async {
      dynamic responseData =
          await MealServices().mealsByIngredients("chicken", "dinner");
      expect(responseData['recipeByIngr'][0]['label'], isNotNull);
      expect(responseData['errorBit'], 1);
    });
    test("Randomizer Function returns correct lenghts and interval", () {
      List<int> returnValue = MealServices().randomizer(10, 3);
      expect(returnValue.length, 3);
      expect(returnValue[0], lessThan(10));
      expect(returnValue[1], lessThan(10));
      expect(returnValue[2], lessThan(10));
    });

    test("Recipe Analysis handles bad ingredients", () async {
      dynamic responseData =
          await MealServices().recipeAnalysis("TextToGenerateError");
      expect(responseData['errorBit'], 0);
    });

    test("Recipe Analysis returns nutrition facts", () async {
      dynamic responseData = await MealServices()
          .recipeAnalysis("100g dark chocolate\n100ml milk");
      expect(responseData['analysisResult']['ENERC_KCAL']['quantity'],
          greaterThanOrEqualTo(0));
      expect(responseData['errorBit'], 1);
    });
  });
}
