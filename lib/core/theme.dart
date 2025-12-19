import 'package:cours_work/core/app_colors.dart';
import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark, // Темна тема
  scaffoldBackgroundColor: AppColors.background,
  fontFamily: 'Roboto', // Основний шрифт

  // Налаштування текстів
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.text, fontFamily: 'Georgia'
    ),
    displayMedium: TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.text, fontFamily: 'Georgia'
    ),
    bodyMedium: TextStyle(
        fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.text
    ),
    bodySmall: TextStyle(
        fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.textSecondary
    ),
  ),

  // Налаштування полів вводу (Input)
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.inputBackground, // Темно-сірий фон
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none, // Прибираємо рамку
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 1), // Акцент при фокусі
    ),
  ),

  // Налаштування кнопок
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.buttonText,
      minimumSize: const Size(double.infinity, 50), // На всю ширину
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold,
      ),
    ),
  ),

  // Налаштування чекбоксів
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return AppColors.primary;
      }
      return Colors.transparent;
    }),
    side: const BorderSide(color: Colors.grey, width: 2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  ),
);