import 'package:cached_network_image/cached_network_image.dart';
import 'package:espw/app/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ShopDashPage extends StatefulWidget{
  const ShopDashPage({super.key, required this.idToko});
  final String idToko;

  @override
  State<ShopDashPage> createState() => _ShopDashPageState();
}

class _ShopDashPageState extends State<ShopDashPage>{
  late List<Map> shopList;
  @override
  void initState() {
    super.initState();
    shopList = shop;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Toko Saya',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),
        ),
        actions: [
          Badge(
            isLabelVisible: false,
            offset: const Offset(-8, 8),
            child: IconButton(
              onPressed: (){},
              icon: const Icon(Icons.chat_outlined),
            ),
          ),
          Badge(
            isLabelVisible: false,
            offset: const Offset(-8, 8),
            child: IconButton(
              onPressed: (){},
              icon: const Icon(Icons.notifications_outlined)
            ),
          ),
          IconButton(
            onPressed: (){
              context.pushNamed('shop-settings');
            },
            icon: const Icon(Icons.settings_outlined),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: CachedNetworkImageProvider(
                      shopList[0]['profile_picture']
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shopList[0]['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        Text(
                          shopList[0]['class']
                        )
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: (){
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context){
                          return SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: CachedNetworkImageProvider(
                                          shopList[0]['profile_picture']
                                        ),
                                      ),
                                      const Gap(10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              shopList[0]['name'],
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600
                                              ),
                                            ),
                                            Text(
                                              shopList[0]['class']
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(20),
                                  GestureDetector(
                                    onTap: () => context.pushNamed('login-shop', queryParameters: {'isRedirect': 'false'}),
                                    child: Container(
                                      color: Colors.transparent,
                                      child: const Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.transparent,
                                            child: Icon(Icons.add, color: Colors.black),
                                          ),
                                          Gap(10),
                                          Expanded(
                                            child: Text(
                                              'Tambahkan Toko',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      );
                    },
                    icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                  )
                ],
              ),
              const Gap(30),
              Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      context.pushNamed('order-status');
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.transparent
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Penjualan'
                          ),
                          Icon(Icons.keyboard_arrow_right)
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: const ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                        )),
                        foregroundColor: WidgetStatePropertyAll(Colors.black),
                        padding: WidgetStatePropertyAll(EdgeInsets.zero),
                        overlayColor: WidgetStatePropertyAll(Colors.transparent)
                      ),
                      onPressed: (){
                        context.pushNamed('order-status', queryParameters: {'initial_index': '1'});
                      },
                      child: const Column(
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: 35,
                          ),
                          Gap(10),
                          Text('Pesanan baru')
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      style: const ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                        )),
                        foregroundColor: WidgetStatePropertyAll(Colors.black),
                        padding: WidgetStatePropertyAll(EdgeInsets.zero),
                        overlayColor: WidgetStatePropertyAll(Colors.transparent)
                      ),
                      onPressed: (){
                        context.pushNamed('order-status', queryParameters: {'initial_index': '2'});
                      },
                      child: const Column(
                        children: [
                          Icon(
                            Icons.local_shipping_outlined,
                            size: 35,
                          ),
                          Gap(10),
                          Text('Sedang Diantarkan')
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(30),
              Column(
                children: [
                  GestureDetector(
                    onTap: (){},
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.transparent
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Produk'
                          ),
                          TextButton(
                            onPressed: (){
                              context.pushNamed('add-product');
                            },
                            child: const Text('Tambah Produk'),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      context.pushNamed('product');
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.transparent
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Daftar Produk',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                              Text(
                                '0 Produk'
                              )
                            ],
                          ),
                          Icon(Icons.keyboard_arrow_right)
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const Gap(30),
              Column(
                children: [
                  GestureDetector(
                    onTap: (){},
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.transparent
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Penilaian Pembeli'
                          ),
                          TextButton(
                            onPressed: (){},
                            child: const Text('Lihat Semua'),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}