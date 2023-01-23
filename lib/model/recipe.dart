class Recipe {
  String title;
  String mealTime;
  String photo;
  String calories;
  String time;
  String description;

  List<Ingridient> ingridients;
  List<Ingridient> nutriments;

  Recipe({
    required this.title,
    required this.photo,
    required this.calories,
    required this.mealTime,
    required this.time,
    required this.description,
    required this.ingridients,
    required this.nutriments,
  });
}

class Ingridient {
  String name;
  String size;

  Ingridient({required this.name, required this.size});

  static List<Ingridient> toList(List<Map<String, Object>> json) {
    return List.from(json)
        .map((e) => Ingridient(name: e['name'], size: e['size']))
        .toList();
  }
}
