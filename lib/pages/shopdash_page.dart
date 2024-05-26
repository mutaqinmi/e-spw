import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:espw/app/controllers.dart';
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
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Toko',
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
              onPressed: () => {},
              icon: const Icon(Icons.notifications_outlined)
            ),
          ),
          IconButton(
            onPressed: () => context.pushNamed('shop-settings'),
            icon: const Icon(Icons.settings_outlined),
          )
        ],
      ),
      body: FutureBuilder(
        future: shopById(widget.idToko),
        builder: (BuildContext context, AsyncSnapshot response){
          if(response.hasData && response.connectionState == ConnectionState.done){
            final shop = json.decode(response.data.body)['data'];
            return SingleChildScrollView(
              child: SafeArea(
                minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: CachedNetworkImageProvider(
                            'https://$baseUrl/assets/public/${shop.first['toko']['banner_toko']}'
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                shop.first['toko']['nama_toko'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              Text(
                                shop.first['kelas']['kelas']
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(30),
                    Column(
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () => context.pushNamed('order-status'),
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
                                onPressed: () => context.pushNamed('order-status', queryParameters: {'initial_index': '1'}),
                                child: const Column(
                                  children: [
                                    Icon(
                                      Icons.event_available_outlined,
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
                                onPressed: () => context.pushNamed('order-status', queryParameters: {'initial_index': '2'}),
                                child: const Column(
                                  children: [
                                    Icon(
                                      Icons.event_repeat_outlined,
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
                                  onPressed: () => context.pushNamed('add-product'),
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
                          onTap: () => context.pushNamed('product'),
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
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }
}