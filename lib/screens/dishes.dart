class Dishes {
  String title;
  String ingredients;
  String steps;

  Dishes({
    required this.title,
    required this.ingredients,
    required this.steps,
  });

  factory Dishes.fromJson(Map<String, dynamic> json) => Dishes(
    title: json["title"],
    ingredients: json["ingredients"],
    steps: json["steps"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "ingredients": ingredients,
    "steps": steps,
  };
}
