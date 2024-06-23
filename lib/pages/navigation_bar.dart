import 'dart:convert';
import 'package:espw/app/controllers.dart';
import 'package:espw/pages/profile_page.dart';
import 'package:flutter/material.dart';
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
          StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1)).asyncMap((t) => getDataKeranjang(context: context)),
            builder: (BuildContext context, AsyncSnapshot response){
              if(response.hasData){
                final cartCount = json.decode(response.data.body)['data'].length;
                return NavigationDestination(
                  selectedIcon: Badge(
                    isLabelVisible: cartCount == 0 ? false : true,
                    label: Text(cartCount.toString()),
                    child: const Icon(Icons.shopping_cart),
                  ),
                  icon: Badge(
                    isLabelVisible: cartCount == 0 ? false : true,
                    label: Text(cartCount.toString()),
                    child: const Icon(Icons.shopping_cart_outlined),
                  ),
                  label: 'Keranjang',
                );
              }

              return const NavigationDestination(
                selectedIcon: Badge(
                  isLabelVisible: false,
                  label: Text('0'),
                  child: Icon(Icons.shopping_cart),
                ),
                icon: Badge(
                  isLabelVisible: false,
                  label: Text('0'),
                  child: Icon(Icons.shopping_cart_outlined),
                ),
                label: 'Keranjang',
              );
            },
          ),
          const NavigationDestination(
            selectedIcon: Badge(
              isLabelVisible: false,
              label: Text('0'),
              child: Icon(Icons.notifications),
            ),
            icon: Badge(
              isLabelVisible: false,
              label: Text('0'),
              child: Icon(Icons.notifications_outlined),
            ),
            label: 'Notifikasi',
          ),
          NavigationDestination(
            icon: StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)).asyncMap((i) => getDataSiswa(context: context)),
              builder: (BuildContext context, AsyncSnapshot response){
                if(response.hasData){
                  final data = json.decode(response.data.body)['siswa']['foto_profil'];
                  return CircleAvatar(
                    radius: 14,
                    backgroundImage: NetworkImage(data.isEmpty ? 'https://$baseUrl/images/profile.png' : 'https://$apiBaseUrl/public/$data'),
                  );
                }

                return const CircleAvatar(
                  radius: 14,
                  backgroundImage: NetworkImage('https://$baseUrl/images/profile.png'),
                );
              },
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}