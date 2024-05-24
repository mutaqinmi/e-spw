import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:espw/pages/chat_page.dart';
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

  final int cartBadge = 0;
  final int notificationBadge = 0;
  final int chatBadge = 0;

  void checkConnectivity() async {
    final List<ConnectivityResult> connectivity = await Connectivity().checkConnectivity();
    if(!mounted) return;
    if(connectivity.contains(ConnectivityResult.mobile) || connectivity.contains(ConnectivityResult.wifi)){
      return null;
    }

    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: const Center(
          child: Text('Tidak ada internet!'),
        ),
      )
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   carts().then((res) => {
  //     setState((){
  //       cartBadge = json.decode(res.body)['data'].length;
  //     })
  //   });
  // }

  @override
  Widget build(BuildContext context){
    checkConnectivity();

    return Scaffold(
      body: const [
        HomePage(),
        CartPage(),
        NotificationPage(),
        ChatPage(),
      ][currentPage],
      bottomNavigationBar: NavigationBar(
        elevation: 20,
        shadowColor: Colors.grey,
        height: 70,
        selectedIndex: currentPage,
        onDestinationSelected: (int index){
          setState(() {
            currentPage = index;
          });
        },
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
            selectedIcon: Badge(
              isLabelVisible: notificationBadge == 0 ? false : true,
              label: Text(notificationBadge.toString()),
              child: const Icon(Icons.chat),
            ),
            icon: Badge(
              isLabelVisible: notificationBadge == 0 ? false : true,
              label: Text(notificationBadge.toString()),
              child: const Icon(Icons.chat_outlined),
            ),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}