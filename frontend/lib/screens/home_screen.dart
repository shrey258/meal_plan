import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meal_provider.dart';
import '../widgets/meal_item_card.dart';
import '../widgets/day_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<MealProvider>().fetchMeals(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Consumer<MealProvider>(
          builder: (context, mealProvider, child) {
            if (mealProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            }

            if (mealProvider.error != null) {
              return Center(
                child: Text(
                  'Error: ${mealProvider.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (mealProvider.meals.isEmpty) {
              return const Center(
                child: Text('No meals available'),
              );
            }

            return Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      AppBar(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        title: const Text(
                          'Meal Plan',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DaySelector(
                        meals: mealProvider.meals,
                        selectedMeal: mealProvider.selectedDay,
                        onDaySelected: mealProvider.selectDay,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      physics: const ClampingScrollPhysics(),
                    ),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          if (mealProvider.selectedDay != null) ...[
                            if (mealProvider.selectedDay!.meals.isEmpty)
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    'No meals available for this day',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              )
                            else
                              ...mealProvider.selectedDay!.meals.map((mealItem) => 
                                MealItemCard(
                                  key: ValueKey(mealItem.id),
                                  meal: mealItem,
                                  day: mealProvider.selectedDay!.day,
                                  isDraggable: true,
                                ),
                              ),
                          ] else
                            const Center(
                              child: Text('Select a day to view meals'),
                            ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
