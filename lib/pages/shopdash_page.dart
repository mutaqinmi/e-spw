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
      ),
      body: FutureBuilder(
        future: shopById(widget.idToko),
        builder: (BuildContext context, AsyncSnapshot response){
          if(response.hasData && response.connectionState == ConnectionState.done){
            final shop = json.decode(response.data.body)['data'];
            return SingleChildScrollView(
              child: SafeArea(
                top: false,
                minimum: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Card(
                      elevation: 0,
                      color: shop.first['toko']['is_open'] == true ? Colors.green : Colors.red,
                      margin: const EdgeInsets.only(bottom: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Toko anda sedang ',
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                            Text(
                              shop.first['toko']['is_open'] == true ? 'Buka' : 'Tutup',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
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
                        FilledButton(
                          style: ButtonStyle(
                            visualDensity: VisualDensity.compact,
                            backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
                            foregroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                            side: WidgetStatePropertyAll(BorderSide(
                              color: Theme.of(context).primaryColor
                            ))
                          ),
                          onPressed: () => context.pushNamed('shop', queryParameters: {'shopID': shop.first['toko']['id_toko']}),
                          child: const Text('Kunjungi toko')
                        )
                      ],
                    ),
                    const Gap(30),
                    Column(
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () => context.pushNamed('order-status'),
                              child: const Card(
                                elevation: 0,
                                child: Row(
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
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.upcoming_outlined,
                                      size: 35,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const Gap(10),
                                    const Text('Pesanan baru')
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
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.event_repeat_outlined,
                                      size: 35,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const Gap(10),
                                    const Text('Diproses')
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Card(
                          elevation: 0,
                          child: Text(
                            'Produk'
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.pushNamed('product', queryParameters: {'id_toko': shop.first['toko']['id_toko']}),
                          child: Card(
                            elevation: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 10,
                                  children: [
                                    Icon(
                                      Icons.inventory_2_outlined,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Daftar Produk',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500
                                          ),
                                        ),
                                        Text(
                                          '${shop.length} Produk'
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                const Icon(Icons.keyboard_arrow_right)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const Gap(30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Card(
                          elevation: 0,
                          child: Text(
                            'Penilaian Pembeli'
                          ),
                        ),
                        GestureDetector(
                          onTap: () => (),
                          child: Card(
                            elevation: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 10,
                                  children: [
                                    Icon(
                                      Icons.star_rate_outlined,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const Text(
                                      'Ulasan',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.keyboard_arrow_right)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const Gap(30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Card(
                          elevation: 0,
                          child: Text(
                            'Lainnya'
                          ),
                        ),
                        const Gap(5),
                        GestureDetector(
                          onTap: () => (),
                          child: Card(
                            elevation: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 10,
                                  children: [
                                    Icon(
                                      Icons.ads_click,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const Text(
                                      'Promosi',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.keyboard_arrow_right)
                              ],
                            ),
                          ),
                        ),
                        const Gap(10),
                        GestureDetector(
                          onTap: () => (),
                          child: Card(
                            elevation: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 10,
                                  children: [
                                    Icon(
                                      Icons.storefront_outlined,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const Text(
                                      'Live Mode',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.keyboard_arrow_right)
                              ],
                            ),
                          ),
                        ),
                        const Gap(10),
                        GestureDetector(
                          onTap: () => context.pushNamed('shop-settings'),
                          child: Card(
                            elevation: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 10,
                                  children: [
                                    Icon(
                                      Icons.settings_outlined,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const Text(
                                      'Pengaturan toko',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.keyboard_arrow_right)
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){},
        icon: const Icon(Icons.assignment_outlined),
        label: const Text('Laporan'),
      ),
    );
  }
}