class Meal {
  final String day;
  final List<MealItem> meals;

  Meal({
    required this.day,
    required this.meals,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    print('Meal.fromJson: Parsing day: ${json['day']}');
    print('Meal.fromJson: Raw meals data: ${json['meals']}');
    
    return Meal(
      day: json['day'] as String,
      meals: (json['meals'] as List<dynamic>)
          .map((meal) => MealItem.fromJson(meal))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'meals': meals.map((meal) => meal.toJson()).toList(),
    };
  }
}

class MealItem {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int calories;
  final List<String> ingredients;

  MealItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.calories,
    required this.ingredients,
  });

  factory MealItem.fromJson(Map<String, dynamic> json) {
    print('MealItem.fromJson: Parsing meal: ${json['name']}');
    print('MealItem.fromJson: Raw data: $json');
    
    return MealItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      calories: json['calories'] as int? ?? 0,
      ingredients: (json['ingredients'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'calories': calories,
      'ingredients': ingredients,
    };
  }
}
