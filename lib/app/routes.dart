import 'package:go_router/go_router.dart';

// Pages
import 'package:e_spw/pages/main_page.dart';
import 'package:e_spw/pages/home_page.dart';
import 'package:e_spw/pages/signup_page.dart';
import 'package:e_spw/pages/signin_page.dart';
import 'package:e_spw/pages/verify_page.dart';
import 'package:e_spw/pages/search_page.dart';

final routes = GoRouter(
  routes: [
    GoRoute(
      name: 'main',
      path: '/',
      builder: (context, state) => const MainPage(),
      routes: [
        GoRoute(
          name: 'signup',
          path: 'signup',
          builder: (context, state) => const SignUp(),
        ),
        GoRoute(
          name: 'signin',
          path: 'signin',
          builder: (context, state) => const SignIn(),
          routes: [
            GoRoute(
              name: 'verify',
              path: 'verify',
              builder: (context, state) => const Verify(),
            )
          ]
        )
      ]
    ),
    GoRoute(
      name: 'home',
      path: '/home',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          name: 'search',
          path: 'search',
          builder: (context, state) => const SearchPage(),
        )
      ]
    )
  ]
);