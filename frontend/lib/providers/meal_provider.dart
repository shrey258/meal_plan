import 'package:flutter/foundation.dart';
import '../models/meal.dart';
import '../services/meal_service.dart';

class MealProvider with ChangeNotifier {
  final MealService _mealService = MealService();
  List<Meal> _meals = [];
  Meal? _selectedDay;
  bool _isLoading = false;
  String? _error;

  List<Meal> get meals => _meals;
  Meal? get selectedDay => _selectedDay;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMeals() async {
    print('MealProvider: Starting fetchMeals');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('MealProvider: Calling getMeals');
      _meals = await _mealService.getMeals();
      print('MealProvider: Got ${_meals.length} meals');
      
      if (_meals.isNotEmpty) {
        print('MealProvider: Setting selected day');
        // Select the first day if no day is selected
        _selectedDay ??= _meals[0];
        print('MealProvider: Selected day is ${_selectedDay?.day}');
      }
    } catch (e) {
      _error = e.toString();
      print('MealProvider: Error fetching meals: $e');
    }

    _isLoading = false;
    print('MealProvider: Finished fetchMeals, notifying listeners');
    notifyListeners();
  }

  void selectDay(Meal day) {
    print('MealProvider: Selecting day ${day.day}');
    _selectedDay = day;
    notifyListeners();
  }

  Future<void> moveMeal({
    required String sourceDay,
    required String mealId,
    required String targetDay,
  }) async {
    print('MealProvider: Moving meal from $sourceDay to $targetDay');
    
    // Find the meal to move
    final sourceDayMeal = _meals.firstWhere((m) => m.day == sourceDay);
    final targetDayMeal = _meals.firstWhere((m) => m.day == targetDay);
    final mealToMove = sourceDayMeal.meals.firstWhere((m) => m.id == mealId);
    
    // Update local state optimistically
    sourceDayMeal.meals.removeWhere((m) => m.id == mealId);
    targetDayMeal.meals.add(mealToMove);
    notifyListeners();

    try {
      await _mealService.moveMeal(
        sourceDay: sourceDay,
        mealId: mealId,
        targetDay: targetDay,
      );

    } catch (e) {
      // Revert optimistic update on error
      targetDayMeal.meals.removeWhere((m) => m.id == mealId);
      sourceDayMeal.meals.add(mealToMove);
      _error = e.toString();
      print('MealProvider: Error moving meal: $e');
      notifyListeners();
    }
  }
}
