import 'dart:convert';
import 'package:espw/app/controllers.dart';
import 'package:espw/pages/add_product_oncreate_page.dart';
import 'package:espw/pages/add_product_page.dart';
import 'package:espw/pages/change_password.dart';
import 'package:espw/pages/chat_dialog_page.dart';
import 'package:espw/pages/checkout_page.dart';
import 'package:espw/pages/choose_shop.dart';
import 'package:espw/pages/create_shop_page.dart';
import 'package:espw/pages/edit_profile_page.dart';
import 'package:espw/pages/favorite_page.dart';
import 'package:espw/pages/join_shop_page.dart';
import 'package:espw/pages/login_failed.dart';
import 'package:espw/pages/login_shop_page.dart';
import 'package:espw/pages/order_page.dart';
import 'package:espw/pages/order_status_page.dart';
import 'package:espw/pages/product_page.dart';
import 'package:espw/pages/profile_page.dart';
import 'package:espw/pages/set_schedule_page.dart';
import 'package:espw/pages/shop_settings_page.dart';
import 'package:espw/pages/shopdash_page.dart';
import 'package:espw/pages/upload_product_image_oncreate_page.dart';
import 'package:espw/pages/upload_product_image_page.dart';
import 'package:espw/pages/upload_profile_image_page.dart';
import 'package:espw/pages/verify_password_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
          builder: (BuildContext context, GoRouterState state) => Verify(
            nis: state.uri.queryParameters['nis']!,
            nama: state.uri.queryParameters['nama']!,
            kelas: state.uri.queryParameters['kelas']!,
            password: state.uri.queryParameters['password']!,
            telepon: state.uri.queryParameters['telepon']!,
            fotoProfil: state.uri.queryParameters['foto_profil']!,
            token: state.uri.queryParameters['token']!,
          ),
        ),
        GoRoute(
          name: 'login-failed',
          path: 'login-failed',
          builder: (BuildContext context, GoRouterState state) => const LoginFailed(),
        )
      ]
    ),
    GoRoute(
      name: 'home',
      path: '/home',
      builder: (BuildContext context, GoRouterState state) => const NavBar(),
      onExit: (BuildContext context, GoRouterState state) async {
        bool? confirmDialog;
        if(state.uri.path == '/home'){
          confirmDialog = await showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              content: const Text('Apakah anda yakin ingin keluar?'),
              actions: [
                TextButton(
                  onPressed: (){
                    context.pop(false);
                  },
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                    foregroundColor: const WidgetStatePropertyAll(Colors.white)
                  ),
                  onPressed: (){
                    context.pop(true);
                  },
                  child: const Text('Keluar'),
                ),
              ],
            )
          );
        } else {
          return true;
        }

        return confirmDialog ?? false;
      },
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
              redirect: (BuildContext context, GoRouterState state) async {
                final String? isRedirect = state.uri.queryParameters['isRedirect'];
                final dataKelompok = await kelompok();
                if(isRedirect == 'false'){
                  return null;
                }

                if(json.decode(dataKelompok.body)['data'].isNotEmpty){
                  return '/home/profile/login-shop/choose-shop';
                }

                return null;
              },
              routes: [
                GoRoute(
                  name: 'create-shop',
                  path: 'create-shop',
                  builder: (BuildContext context, GoRouterState state) => const CreateShopPage(),
                  routes: [
                    GoRoute(
                      name: 'upload-profile-image',
                      path: 'upload-profile-image',
                      builder: (BuildContext context, GoRouterState state) => UploadProfileImagePage(
                        namaToko: state.uri.queryParameters['nama_toko'],
                        kelas: state.uri.queryParameters['kelas'],
                        deskripsiToko: state.uri.queryParameters['deskripsi_toko'],
                        kategoriToko: state.uri.queryParameters['kategori_toko'],
                      ),
                    )
                  ]
                ),
                GoRoute(
                  name: 'add-product-oncreate',
                  path: 'add-product-oncreate',
                  builder: (BuildContext context, GoRouterState state) => AddProductOnCreatePage(
                    idToko: state.uri.queryParameters['id_toko']!,
                  ),
                  routes: [
                    GoRoute(
                      name: 'upload-product-image-oncreate',
                      path: 'upload-product-image-oncreate',
                      builder: (BuildContext context, GoRouterState state) => UploadProductImageOnCreatePage(
                        namaProduk: state.uri.queryParameters['nama_produk'],
                        harga: state.uri.queryParameters['harga'],
                        stok: state.uri.queryParameters['stok'],
                        deskripsiProduk: state.uri.queryParameters['deskripsi_produk'],
                        detailProduk: state.uri.queryParameters['detail_produk'],
                        idToko: state.uri.queryParameters['id_toko'],
                      ),
                    )
                  ],
                ),
                GoRoute(
                  name: 'join-shop',
                  path: 'join-shop',
                  builder: (BuildContext context, GoRouterState state) => const JoinShopPage(),
                ),
                GoRoute(
                  name: 'choose-shop',
                  path: 'choose-shop',
                  builder: (BuildContext context, GoRouterState state) => const ChooseShop(),
                )
              ]
            ),
            GoRoute(
              name: 'shop-dash',
              path: 'shop-dash',
              builder: (BuildContext context, GoRouterState state) => ShopDashPage(
                idToko: state.uri.queryParameters['id_toko']!
              ),
              routes: [
                GoRoute(
                  name: 'order-status',
                  path: 'order-status',
                  builder: (BuildContext context, GoRouterState state) => OrderStatusPage(
                    initialIndex: state.uri.queryParameters['initial_index'],
                  ),
                ),
                GoRoute(
                  name: 'add-product',
                  path: 'add-product',
                  builder: (BuildContext context, GoRouterState state) => AddProductPage(
                    idToko: state.uri.queryParameters['id_toko']!,
                  ),
                  routes: [
                    GoRoute(
                      name: 'upload-product-image',
                      path: 'upload-product-image',
                      builder: (BuildContext context, GoRouterState state) => UploadProductImagePage(
                        namaProduk: state.uri.queryParameters['nama_produk'],
                        harga: state.uri.queryParameters['harga'],
                        stok: state.uri.queryParameters['stok'],
                        deskripsiProduk: state.uri.queryParameters['deskripsi_produk'],
                        detailProduk: state.uri.queryParameters['detail_produk'],
                        idToko: state.uri.queryParameters['id_toko'],
                      )
                    )
                  ]
                ),
                GoRoute(
                  name: 'product',
                  path: 'product',
                  builder: (BuildContext context, GoRouterState state) => ProductPage(
                    idToko: state.uri.queryParameters['id_toko']!,
                  ),
                ),
              ]
            ),
            GoRoute(
              name: 'verify-password',
              path: 'verify-password',
              builder: (BuildContext context, GoRouterState state) => const VerifyPassword(),
            ),
            GoRoute(
              name: 'change-password',
              path: 'change-password',
              builder: (BuildContext context, GoRouterState state) => const ChangePassword(),
            ),
            GoRoute(
              name: 'favorite',
              path: 'favorite',
              builder: (BuildContext context, GoRouterState state) => const FavoritePage(),
            ),
            GoRoute(
              name: 'shop-settings',
              path: 'shop-settings',
              builder: (BuildContext context, GoRouterState state) => ShopSettingsPage(
                idToko: state.uri.queryParameters['id_toko']!,
              ),
              routes: [
                GoRoute(
                  name: 'set-schedule',
                  path: 'set-schedule',
                  builder: (BuildContext context, GoRouterState state) => SetSchedulePage(
                    idToko: state.uri.queryParameters['id_toko']!,
                  )
                )
              ]
            ),
            GoRoute(
              name: 'edit-profile',
              path: 'edit-profile',
              builder: (BuildContext context, GoRouterState state) => const EditProfilePage(),
            )
          ]
        ),
        GoRoute(
          name: 'shop',
          path: 'shop',
          builder: (BuildContext context, GoRouterState state) => ShopPage(
            shopID: state.uri.queryParameters['shopID'],
          ),
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