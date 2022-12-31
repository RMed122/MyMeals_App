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

  factory Recipe.fromJson(Map<String, Object> json) {
    return Recipe(
      title: json['title'] as String,
      photo: json['photo'] as String,
      calories: json['calories'] as String,
      time: json['time'] as String,
      description: json['description'] as String,
      mealTime: json['mealTime'] as String,
      ingridients: [],
      nutriments: [],
    );
  }
}

class Ingridient {
  String name;
  String size;

  Ingridient({required this.name, required this.size});
  factory Ingridient.fromJson(Map<String, Object> json) => Ingridient(
        name: json['name'] as String,
        size: json['size'] as String,
      );

  Map<String, Object> toMap() {
    return {
      'name': name,
      'size': size,
    };
  }

  static List<Ingridient> toList(List<Map<String, Object>> json) {
    return List.from(json)
        .map((e) => Ingridient(name: e['name'], size: e['size']))
        .toList();
  }
}
