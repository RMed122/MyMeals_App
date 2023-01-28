import 'package:flutter_test/flutter_test.dart';
import 'package:mymeals/model/recipe.dart';
import 'package:mymeals/model/user_model.dart';

void main() {
  group('Model Tests: ', () {
    test("Recipe Model", () async {
      Recipe recipe = Recipe(
          calories: "100",
          time: "test",
          photo: "test",
          mealTime: "lunch",
          description: "dish",
          title: "pasta",
          ingridients: [Ingridient(name: "fusili", size: "100")],
          nutriments: [Ingridient(name: "calories", size: "100")]);
      expect(recipe.title, "pasta");
      expect(recipe.calories, "100");
      expect(recipe.description, "dish");
      expect(recipe.ingridients[0].name, "fusili");
    });
    test("Recipe List function test", (() {
      List<Map<String, Object>> json = [
        {"name": "fusili", "size": "100"}
      ];
      List<Ingridient> toList = Ingridient.toList(json);

      expect(toList[0].name, "fusili");
    }));

    test("Ingredient Model", (() {
      Ingridient ingr = Ingridient(name: "name", size: "size");
      expect(ingr.name, "name");
    }));

    test("User Model", (() {
      User user = User("uid", "email");
      expect(user.uid, "uid");
    }));
  });
}
