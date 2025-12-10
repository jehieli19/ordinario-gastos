import 'package:flutter/material.dart';

enum Category {
  food,
  transport,
  entertainment,
  health,
  services,
  education,
  others,
}

class CategoryData {
  final String name;
  final IconData icon;
  final Color color;

  const CategoryData(this.name, this.icon, this.color);
}

const Map<Category, CategoryData> categoryDetails = {
  Category.food: CategoryData('Alimentación', Icons.restaurant, Colors.orange),
  Category.transport: CategoryData('Transporte', Icons.directions_car, Colors.blue),
  Category.entertainment: CategoryData('Entretenimiento', Icons.movie, Colors.purple),
  Category.health: CategoryData('Salud', Icons.local_hospital, Colors.red),
  Category.services: CategoryData('Servicios', Icons.bolt, Colors.yellow),
  Category.education: CategoryData('Educación', Icons.school, Colors.green),
  Category.others: CategoryData('Otros', Icons.more_horiz, Colors.grey),
};

// Helper for backward compatibility or easy access
final Map<Category, String> categoryNames = 
    categoryDetails.map((k, v) => MapEntry(k, v.name));

