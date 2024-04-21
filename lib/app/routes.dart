import 'package:espw/pages/chat_dialog_page.dart';
import 'package:espw/pages/checkout_page.dart';
import 'package:espw/pages/create_shop_page.dart';
import 'package:espw/pages/join_shop_page.dart';
import 'package:espw/pages/login_shop_page.dart';
import 'package:espw/pages/order_page.dart';
import 'package:espw/pages/profile_page.dart';
import 'package:espw/pages/upload_profile_image_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Pages
import 'package:espw/pages/signin_page.dart';
import 'package:espw/pages/search_page.dart';
import 'package:espw/pages/navigation_bar.dart';
import 'package:espw/pages/verify_page.dart';
import 'package:espw/pages/search_result_page.dart';
import 'package:espw/pages/shop_page.dart';
import 'package:espw/pages/cart_page.dart';
import 'package:espw/pages/notification_page.dart';

final routes = GoRouter(
  routes: [
    GoRoute(
      name: 'signin',
      path: '/',
      builder: (BuildContext context, GoRouterState state) => const SignInPage(),
      redirect: (BuildContext context, GoRouterState state) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final isAuthenticated = prefs.getBool('isAuthenticated');
        if(isAuthenticated == null){
          prefs.setBool('isAuthenticated', false);
        }

        if(isAuthenticated!){
          return '/home';
        }

        return null;
      },
      routes: [
        GoRoute(
          name: 'verify',
          path: 'verify',
          builder: (BuildContext context, GoRouterState state) => const Verify(),
        ),
      ]
    ),
    GoRoute(
      name: 'home',
      path: '/home',
      builder: (BuildContext context, GoRouterState state) => const NavBar(),
      // onExit: (BuildContext context) async {
      //   final bool? confirmDialog = await showDialog(
      //     context: context,
      //     builder: (BuildContext context) => AlertDialog(
      //       content: const Text('Apakah anda yakin ingin keluar?'),
      //       actions: [
      //         TextButton(
      //           onPressed: (){
      //             context.pop(false);
      //           },
      //           child: const Text('Batal'),
      //         ),
      //         ElevatedButton(
      //           style: ButtonStyle(
      //             backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
      //             foregroundColor: const MaterialStatePropertyAll(Colors.white)
      //           ),
      //           onPressed: (){
      //             context.pop(true);
      //           },
      //           child: const Text('Keluar'),
      //         ),
      //       ],
      //     )
      //   );
      //
      //   return confirmDialog ?? false;
      // },
      routes: [
        GoRoute(
          name: 'search',
          path: 'search',
          builder: (BuildContext context, GoRouterState state) => const SearchPage(),
        ),
        GoRoute(
          name: 'searchResult',
          path: 'searchResult',
          builder: (BuildContext context, GoRouterState state) => SearchResult(
            searchQuery: state.uri.queryParameters['search'],
          )
        ),
        GoRoute(
          name: 'cart',
          path: 'cart',
          builder: (BuildContext context, GoRouterState state) => const CartPage(),
          routes: [
            GoRoute(
              name: 'checkout',
              path: 'checkout',
              builder: (BuildContext context, GoRouterState state) => const CheckoutPage(),
            )
          ]
        ),
        GoRoute(
          name: 'notification',
          path: 'notification',
          builder: (BuildContext context, GoRouterState state) => const NotificationPage(),
        ),
        GoRoute(
          name: 'profile',
          path: 'profile',
          builder: (BuildContext context, GoRouterState state) => ProfilePage(
            userID: state.uri.queryParameters['user_id'],
          ),
          routes: [
            GoRoute(
              name: 'order',
              path: 'order',
              builder: (BuildContext context, GoRouterState state) => OrderPage(
                initialIndex: state.uri.queryParameters['initial_index'],
              )
            ),
            GoRoute(
              name: 'login-shop',
              path: 'login-shop',
              builder: (BuildContext context, GoRouterState state) => const LoginShopPage(),
              routes: [
                GoRoute(
                  name: 'create-shop',
                  path: 'create-shop',
                  builder: (BuildContext context, GoRouterState state) => const CreateShopPage(),
                  routes: [
                    GoRoute(
                      name: 'upload-profile-image',
                      path: 'upload-profile-image',
                      builder: (BuildContext context, GoRouterState state) => const UploadProfileImagePage(),
                    )
                  ]
                ),
                GoRoute(
                  name: 'join-shop',
                  path: 'join-shop',
                  builder: (BuildContext context, GoRouterState state) => const JoinShopPage(),
                )
              ]
            )
          ]
        ),
        GoRoute(
          name: 'shop',
          path: 'shop',
          builder: (BuildContext context, GoRouterState state) => ShopPage(
            shopID: state.uri.queryParameters['shopID'],
          )
        ),
      ],
    ),
    GoRoute(
      name: 'chat',
      path: '/chat',
      builder: (BuildContext context, GoRouterState state) => Chat(
        chatID: state.uri.queryParameters['chat_id'],
      )
    )
  ]
);