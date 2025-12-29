import 'package:go_router/go_router.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/explanation/presentation/pages/explanation_page.dart';
import '../features/practice/presentation/pages/practice_page.dart';
import '../features/calculation/presentation/pages/calculation_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String explanation = '/explanation';
  static const String practice = '/practice';
  static const String calculation = '/calculation';

  static final router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: explanation,
        builder: (context, state) => const ExplanationPage(),
      ),
      GoRoute(
        path: practice,
        builder: (context, state) => const PracticePage(),
      ),
      GoRoute(
        path: calculation,
        builder: (context, state) => const CalculationPage(),
      ),
    ],
  );
}
