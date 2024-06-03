import 'package:espw/app/controllers.dart';
import 'package:espw/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:espw/pages/home_page.dart';
import 'package:espw/pages/cart_page.dart';
import 'package:espw/pages/notification_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget{
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar>{
  int currentPage = 0;
  final int cartBadge = 0;
  final int notificationBadge = 0;
  final int chatBadge = 0;

  Future<String> _getFotoProfil() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final fotoProfil = prefs.getString('foto_profil');
    return fotoProfil!;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: const [
        HomePage(),
        CartPage(),
        NotificationPage(),
        ProfilePage(),
      ][currentPage],
      bottomNavigationBar: NavigationBar(
        elevation: 20,
        shadowColor: Colors.grey,
        height: 70,
        selectedIndex: currentPage,
        onDestinationSelected: (int index) => setState(() {
          currentPage = index;
        }),
        destinations: [
          const NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Beranda',
          ),
          NavigationDestination(
            selectedIcon: Badge(
              isLabelVisible: cartBadge == 0 ? false : true,
              label: Text(cartBadge.toString()),
              child: const Icon(Icons.shopping_cart),
            ),
            icon: Badge(
              isLabelVisible: cartBadge == 0 ? false : true,
              label: Text(cartBadge.toString()),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            label: 'Keranjang',
          ),
          NavigationDestination(
            selectedIcon: Badge(
              isLabelVisible: notificationBadge == 0 ? false : true,
              label: Text(notificationBadge.toString()),
              child: const Icon(Icons.notifications),
            ),
            icon: Badge(
              isLabelVisible: notificationBadge == 0 ? false : true,
              label: Text(notificationBadge.toString()),
              child: const Icon(Icons.notifications_outlined),
            ),
            label: 'Notifikasi',
          ),
          NavigationDestination(
            // selectedIcon: Badge(
            //   isLabelVisible: notificationBadge == 0 ? false : true,
            //   label: Text(notificationBadge.toString()),
            //   child: const Icon(Icons.chat),
            // ),
            icon: FutureBuilder(
              future: _getFotoProfil(),
              builder: (BuildContext context, AsyncSnapshot response){
                if(response.hasData){
                  return CircleAvatar(
                    radius: 14,
                    backgroundImage: NetworkImage('https://$baseUrl/assets/${response.data.isEmpty ? 'images/profile.png' : 'public/${response.data}'}'),
                  );
                }

                return const CircularProgressIndicator();
              },
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}