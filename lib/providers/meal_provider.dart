import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/meal_model.dart';

class MealProvider with ChangeNotifier {
  List<Meal> _meals = [];

  List<Meal> get meals => _meals;

  Future<void> fetchMeals(String query) async {
    final url = 'https://www.themealdb.com/api/json/v1/1/search.php?s=$query';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body);
      final List<Meal> loadedMeals = [];
      if (extractedData['meals'] != null) {
        extractedData['meals'].forEach((mealData) {
          loadedMeals.add(Meal.fromJson(mealData));
        });
      }
      _meals = loadedMeals;
      notifyListeners();
    } else {
      throw Exception('Failed to load meals');
    }
  }
}
