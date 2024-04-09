import 'package:flutter/material.dart';

// Pages
import 'package:espw/pages/home_page.dart';
import 'package:espw/pages/cart_page.dart';
import 'package:espw/pages/notification_page.dart';

class NavBar extends StatefulWidget{
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar>{
  int currentPage = 0;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: const [
        HomePage(),
        CartPage(),
        NotificationPage(),
        NotificationPage(),
      ][currentPage],
      bottomNavigationBar: NavigationBar(
        height: 70,
        selectedIndex: currentPage,
        onDestinationSelected: (int index){
          setState(() {
            currentPage = index;
          });
        },
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Beranda',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.shopping_cart),
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Keranjang',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.notifications),
            icon: Icon(Icons.notifications_outlined),
            label: 'Notifikasi',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.chat),
            icon: Icon(Icons.chat_outlined),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}