import 'package:go_router/go_router.dart';
import '../core/models/expense.dart';
import '../features/auth/screens/splash_screen.dart';

import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/profile_screen.dart';
import '../features/auth/screens/verify_email_screen.dart';
import '../features/expenses/screens/expenses_list_screen.dart';
import '../features/expenses/screens/expense_form_screen.dart';
import '../features/expenses/screens/expense_detail_screen.dart';
import '../features/expenses/screens/filters_bottom_sheet.dart';
import '../features/summary/screens/summary_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/verify',
      builder: (context, state) {
        final email = state.extra as String;
        return VerifyEmailScreen(email: email);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/expenses',
      builder: (context, state) => const ExpensesListScreen(),
      routes: [
        GoRoute(
          path: 'add',
          builder: (context, state) {
            final expense = state.extra as Expense?;
            return ExpenseFormScreen(initialExpense: expense);
          },
        ),
        GoRoute(
          path: ':id',
          builder: (context, state) => const ExpenseDetailScreen(),
        ),
        GoRoute(
          path: 'filters',
          builder: (context, state) => const FiltersBottomSheet(),
        ),
      ],
    ),
    GoRoute(
      path: '/summary',
      builder: (context, state) => const SummaryScreen(),
    ),
  ],
);
