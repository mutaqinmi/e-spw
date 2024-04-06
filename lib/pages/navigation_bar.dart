import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

// Pages
import 'package:espw/pages/home_page.dart';
import 'package:espw/pages/cart_page.dart';
import 'package:espw/pages/notification_page.dart';
import 'package:espw/pages/order_page.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  List<Widget> _screens(){
    return const [
      HomePage(),
      CartPage(),
      OrderPage(),
      NotificationPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _items(context){
    return [
      navBarItem(
        context: context,
        icon: Icons.home,
        inactiveIcon: Icons.home_outlined,
        title: 'Beranda'
      ),
      navBarItem(
        context: context,
        icon: Icons.shopping_cart,
        inactiveIcon: Icons.shopping_cart_outlined,
        title: 'Keranjang'
      ),
      navBarItem(
        context: context,
        icon: Icons.receipt_long,
        inactiveIcon: Icons.receipt_long_outlined,
        title: 'Pesanan'
      ),
      navBarItem(
        context: context,
        icon: Icons.notifications,
        inactiveIcon: Icons.notifications_outlined,
        title: 'Notifikasi'
      ),
    ];
  }

  @override
  Widget build(BuildContext context){
    return PersistentTabView(
      context,
      navBarHeight: 60,
      screens: _screens(),
      items: _items(context),
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      ),
      decoration: NavBarDecoration(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(80),
              blurRadius: 10,
            )
          ]
      ),
      navBarStyle: NavBarStyle.style3,
    );
  }

  PersistentBottomNavBarItem navBarItem({required BuildContext context, required IconData icon, required IconData inactiveIcon, required String title}){
    return PersistentBottomNavBarItem(
      icon: Icon(icon),
      inactiveIcon: Icon(inactiveIcon),
      title: (title),
      activeColorPrimary: Theme.of(context).primaryColor,
      inactiveColorPrimary: Colors.grey,
    );
  }
}