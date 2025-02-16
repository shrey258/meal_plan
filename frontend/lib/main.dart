import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/meal_provider.dart';
import 'screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MealProvider(),
      child: MaterialApp(
        title: 'Meal Plan',
        theme: ThemeData(
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          colorScheme: const ColorScheme.light(
            primary: Colors.black,
            secondary: Colors.grey,
            surface: Colors.white,
            background: Colors.white,
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            onSurface: Colors.black,
            onBackground: Colors.black,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
