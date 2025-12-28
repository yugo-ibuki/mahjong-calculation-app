import 'package:flutter/material.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/explanation/presentation/pages/explanation_page.dart';
import '../features/practice/presentation/pages/practice_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String explanation = '/explanation';
  static const String practice = '/practice';

  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const HomePage(),
        explanation: (context) => const ExplanationPage(),
        practice: (context) => const PracticePage(),
      };
}
