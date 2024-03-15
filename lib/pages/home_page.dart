import 'package:flutter/material.dart';
import 'package:e_spw/widgets/bottom_navigation_items.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: AppBar(
            title: SizedBox(
              width: double.infinity,
              height: 40,
              child: FilledButton(
                onPressed: (){
                  context.pushNamed('search');
                },
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                  backgroundColor: const MaterialStatePropertyAll(Color.fromARGB(255, 214, 214, 214)),
                  foregroundColor: const MaterialStatePropertyAll(Colors.grey),
                  padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 10))
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search_rounded),
                    Gap(5),
                    Text('Telusuri produk ...')
                  ],
                ),
              )
            ),
            actions: [
              IconButton(
                onPressed: (){},
                icon: const Icon(Icons.notifications_outlined),
              ),
              IconButton(
                onPressed: (){},
                icon: const Icon(Icons.account_circle_outlined),
              ),
            ],
          ),
        )
      ),
      body: const CustomScrollView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: const Icon(
          Icons.storefront_outlined
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          bottomnavitem(Icons.home_outlined, Icons.home, 'Beranda'),
          bottomnavitem(Icons.shopping_cart_outlined, Icons.shopping_cart, 'Keranjang'),
          bottomnavitem(Icons.receipt_long_outlined, Icons.receipt_long, 'Pesanan'),
          bottomnavitem(Icons.favorite_outline, Icons.favorite, 'Favorit')
        ],
      ),
    );
  }
}