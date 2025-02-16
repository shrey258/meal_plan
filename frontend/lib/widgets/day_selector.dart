import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/meal_provider.dart';

class DaySelector extends StatelessWidget {
  final List<Meal> meals;
  final Meal? selectedMeal;
  final Function(Meal) onDaySelected;

  const DaySelector({
    super.key,
    required this.meals,
    required this.selectedMeal,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: meals.length,
        itemBuilder: (context, index) {
          final meal = meals[index];
          final isSelected = selectedMeal?.day == meal.day;

          return DragTarget<Map<String, String>>(
            builder: (context, candidateData, rejectedData) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 16 : 8,
                  right: index == meals.length - 1 ? 16 : 8,
                ),
                child: Stack(
                  children: [
                    Material(
                      color: isSelected ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () => onDaySelected(meal),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? Colors.transparent : Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              meal.day,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (candidateData.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                  ],
                ),
              );
            },
            onWillAccept: (data) {
              if (data == null) return false;
              print('DaySelector: Checking drop on ${meal.day} from ${data['day']}');
              print('DaySelector: Source meal ID: ${data['id']}');
              return data['day'] != meal.day;
            },
            onAccept: (data) {
              print('DaySelector: Accepting drop on ${meal.day}');
              print('DaySelector: Moving meal (ID: ${data['id']}) from ${data['day']} to ${meal.day}');
              
              context.read<MealProvider>().moveMeal(
                    sourceDay: data['day']!,
                    mealId: data['id']!,
                    targetDay: meal.day,
                  );
            },
          );
        },
      ),
    );
  }
}
