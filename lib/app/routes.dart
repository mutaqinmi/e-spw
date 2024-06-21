import 'dart:convert';
import 'package:espw/app/controllers.dart';
import 'package:espw/pages/order_created_page.dart';
import 'package:espw/pages/add_product_oncreate_page.dart';
import 'package:espw/pages/add_product_page.dart';
import 'package:espw/pages/change_password.dart';
import 'package:espw/pages/change_phone.dart';
import 'package:espw/pages/checkout_page.dart';
import 'package:espw/pages/choose_shop.dart';
import 'package:espw/pages/create_shop_page.dart';
import 'package:espw/pages/detail_shop.dart';
import 'package:espw/pages/edit_product_page.dart';
import 'package:espw/pages/edit_profile_page.dart';
import 'package:espw/pages/favorite_page.dart';
import 'package:espw/pages/information_page.dart';
import 'package:espw/pages/join_shop_page.dart';
import 'package:espw/pages/list_address_page.dart';
import 'package:espw/pages/login_shop_page.dart';
import 'package:espw/pages/main_address_page.dart';
import 'package:espw/pages/member_page.dart';
import 'package:espw/pages/order_page.dart';
import 'package:espw/pages/order_status_page.dart';
import 'package:espw/pages/product_page.dart';
import 'package:espw/pages/profile_page.dart';
import 'package:espw/pages/quick_mode_page.dart';
import 'package:espw/pages/rate_page.dart';
import 'package:espw/pages/review_area_page.dart';
import 'package:espw/pages/set_schedule_page.dart';
import 'package:espw/pages/shop_rate_page.dart';
import 'package:espw/pages/shop_settings_page.dart';
import 'package:espw/pages/shopdash_page.dart';
import 'package:espw/pages/unique_code.dart';
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
      path: '/signin',
      builder: (BuildContext context, GoRouterState state) => const SignInPage(),
      routes: [
        GoRoute(
          name: 'verify',
          path: 'verify',
          builder: (BuildContext context, GoRouterState state) => Verify(
            token: state.uri.queryParameters['token']!,
          ),
        ),
      ]
    ),
    GoRoute(
      name: 'home',
      path: '/',
      builder: (BuildContext context, GoRouterState state) => const NavBar(),
      redirect: (BuildContext context, GoRouterState state) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        if(prefs.getBool('isAuthenticated') == null || false) return '/signin';
        return null;
      },
      onExit: (BuildContext context, GoRouterState state) async {
        bool? confirmDialog;
        if(state.uri.path == '/'){
          confirmDialog = await showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              content: const Text('Apakah anda yakin ingin keluar?'),
              actions: [
                TextButton(
                  onPressed: () => context.pop(false),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                    foregroundColor: const WidgetStatePropertyAll(Colors.white)
                  ),
                  onPressed: () => context.pop(true),
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
          builder: (BuildContext context, GoRouterState state) => const ProfilePage(),
        ),
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
            if(isRedirect == 'false') return null;
            final redirectTo = getSelfKelompok(context: context).then((res){
              if(json.decode(res!.body)['data'].isNotEmpty){
                return '/choose-shop';
              } else {
                return null;
              }
            });

            return redirectTo;
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
                  ),
                  routes: [
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
                            idToko: state.uri.queryParameters['id_toko'],
                          ),
                        )
                      ],
                    ),
                  ]
                ),
              ]
            ),
            GoRoute(
              name: 'join-shop',
              path: 'join-shop',
              builder: (BuildContext context, GoRouterState state) => const JoinShopPage(),
            ),
          ]
        ),
        GoRoute(
          name: 'choose-shop',
          path: 'choose-shop',
          builder: (BuildContext context, GoRouterState state) => const ChooseShop(),
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
                idToko: state.uri.queryParameters['id_toko']!,
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
              routes: [
                GoRoute(
                  name: 'edit-product',
                  path: 'edit-product',
                  builder: (BuildContext context, GoRouterState state) => EditProductPage(
                    idProduk: state.uri.queryParameters['id_produk']!,
                    idToko: state.uri.queryParameters['id_toko']!,
                  )
                )
              ]
            ),
            GoRoute(
              name: 'shop-rate',
              path: 'shop-rate',
              builder: (BuildContext context, GoRouterState state) => ShopRatePage(
                idToko: state.uri.queryParameters['id_toko']!,
              ),
            ),
            GoRoute(
              name: 'quick-mode',
              path: 'quick-mode',
              builder: (BuildContext context, GoRouterState state) => QuickModePage(
                idToko: state.uri.queryParameters['id_toko']!,
              )
            )
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
          name: 'address',
          path: 'address',
          builder: (BuildContext context, GoRouterState state) => const ListAddressPage(),
          routes: [
            GoRoute(
              name: 'add-address',
              path: 'add-address',
              builder: (BuildContext context, GoRouterState state) => const MainAddressPage(),
            ),
          ]
        ),
        GoRoute(
          name: 'shop-settings',
          path: 'shop-settings',
          builder: (BuildContext context, GoRouterState state) => ShopSettingsPage(
            idToko: state.uri.queryParameters['id_toko']!,
          ),
          routes: [
            GoRoute(
              name: 'shop-info',
              path: 'shop-info',
              builder: (BuildContext context, GoRouterState state) => InformationPage(
                idToko: state.uri.queryParameters['id_toko']!,
              ),
              routes: [
                GoRoute(
                  name: 'detail-shop',
                  path: 'detail-shop',
                  builder: (BuildContext context, GoRouterState state) => DetailShop(
                    idToko: state.uri.queryParameters['id_toko']!,
                  ),
                ),
                GoRoute(
                  name: 'unique-code',
                  path: 'unique-code',
                  builder: (BuildContext context, GoRouterState state) => UniqueCode(
                    idToko: state.uri.queryParameters['id_toko']!,
                  )
                ),
                GoRoute(
                  name: 'member',
                  path: 'member',
                  builder: (BuildContext context, GoRouterState state) => MemberPage(
                    idToko: state.uri.queryParameters['id_toko']!,
                  )
                )
              ]
            ),
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
          routes: [
            GoRoute(
              name: 'change-phone',
              path: 'change-phone',
              builder: (BuildContext context, GoRouterState state) => const ChangePhone(),
            )
          ]
        ),
        GoRoute(
          name: 'shop',
          path: 'shop',
          builder: (BuildContext context, GoRouterState state) => ShopPage(
            shopID: state.uri.queryParameters['shopID']!,
          ),
          routes: [
            GoRoute(
              name: 'review-area',
              path: 'review-area',
              builder: (BuildContext context, GoRouterState state) => ReviewAreaPage(
                idToko: state.uri.queryParameters['id_toko']!,
              ),
            )
          ]
        ),
        GoRoute(
          name: 'order-created',
          path: 'order-created',
          builder: (BuildContext context, GoRouterState state) => const OrderCreatedPage(),
        ),
        GoRoute(
          name: 'rate',
          path: 'rate',
          builder: (BuildContext context, GoRouterState state) => const RatePage(),
        )
      ],
    ),
  ]
);