import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';
import '../config/env.dart';

class MealService {
  static final String baseUrl = Environment.apiBaseUrl;

  Future<List<Meal>> getMeals() async {
    print('MealService: Fetching meals from $baseUrl/meals');
    try {
      final response = await http.get(Uri.parse('$baseUrl/meals'));
      print('MealService: Response status code: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        print('MealService: Raw response body: ${response.body}');
        List<dynamic> data = json.decode(response.body);
        print('MealService: Decoded JSON data: $data');
        
        final meals = data.map((json) {
          try {
            print('MealService: Parsing meal for day: ${json['day']}');
            print('MealService: Meal data: ${json['meals']}');
            return Meal.fromJson(json);
          } catch (e) {
            print('MealService: Error parsing meal: $e');
            print('MealService: Problematic JSON: $json');
            rethrow;
          }
        }).toList();
        
        print('MealService: Successfully parsed ${meals.length} meals');
        print('MealService: First meal details: ${meals.first.meals.first.toJson()}');
        return meals;
      } else {
        throw Exception('Failed to load meals: ${response.statusCode}');
      }
    } catch (e) {
      print('MealService: Error fetching meals: $e');
      rethrow;
    }
  }

  Future<void> moveMeal({
    required String sourceDay,
    required String mealId,
    required String targetDay,
  }) async {
    print('Moving meal:');
    print('From: $sourceDay');
    print('To: $targetDay');
    print('Meal ID: $mealId');
    
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/meals/move'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'sourceDay': sourceDay,
          'mealId': mealId,
          'targetDay': targetDay,
        }),
      );
      
      print('Move meal response: ${response.body}');
      
      if (response.statusCode != 200) {
        throw Exception('Failed to move meal: ${response.statusCode}');
      }
    } catch (e) {
      print('Error moving meal: $e');
      rethrow;
    }
  }
}
