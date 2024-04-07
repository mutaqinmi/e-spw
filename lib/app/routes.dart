import 'package:espw/pages/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Pages
import 'package:espw/pages/main_page.dart';
import 'package:espw/pages/signin_page.dart';
import 'package:espw/pages/search_page.dart';
import 'package:espw/pages/navigation_bar.dart';
import 'package:espw/pages/verify_page.dart';
import 'package:espw/pages/search_result_page.dart';

var isAuthenticated = true;

final routes = GoRouter(
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      redirect: (BuildContext context, GoRouterState state){
        if(!isAuthenticated){
          return '/main';
        } else {
          return null;
        }
      },
      builder: (BuildContext context, GoRouterState state) => const NavBar(),
      routes: [
        GoRoute(
          name: 'search',
          path: 'search',
          builder: (BuildContext context, GoRouterState state) => const SearchPage(),
          routes: [
            GoRoute(
              name: 'searchResult',
              path: 'searchResult',
              builder: (BuildContext context, GoRouterState state) => SearchResult(
                searchQuery: state.uri.queryParameters['search'],
              )
            )
          ]
        )
      ]
    ),
    GoRoute(
      name: 'main',
      path: '/main',
      builder: (BuildContext context, GoRouterState state) => const MainPage(),
    ),
    GoRoute(
      name: 'signin',
      path: '/signin',
      builder: (BuildContext context, GoRouterState state) => const SignIn(),
      routes: [
        GoRoute(
          name: 'verify',
          path: 'verify',
          builder: (BuildContext context, GoRouterState state) => const Verify(),
        ),
      ]
    ),
    GoRoute(
      name: 'shop',
      path: '/shop',
      builder: (BuildContext context, GoRouterState state) => ShopPage(
        shopID: state.uri.queryParameters['shopID'],
      )
    )
  ]
);