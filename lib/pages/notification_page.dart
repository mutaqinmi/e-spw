import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget{
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>{
  final NumberFormat formatter = NumberFormat('###,###.###', 'id_ID');
  int limit = 20;
  List onGoingOrderList = [];
  @override
  void initState() {
    super.initState();
    getDataPesanan(context: context, statusPesanan: 'Menunggu Konfirmasi').then((res) => setState(() {
      for(int i = 0; i < json.decode(res!.body)['data'].length; i++){
        onGoingOrderList.add(json.decode(res.body)['data'][i]);
      }
    }));
    getDataPesanan(context: context, statusPesanan: 'Diproses').then((res) => setState(() {
      for(int i = 0; i < json.decode(res!.body)['data'].length; i++){
        onGoingOrderList.add(json.decode(res.body)['data'][i]);
      }
    }));
    getDataPesanan(context: context, statusPesanan: 'Menunggu Konfirmasi Penjual').then((res) => setState(() {
      for(int i = 0; i < json.decode(res!.body)['data'].length; i++){
        onGoingOrderList.add(json.decode(res.body)['data'][i]);
      }
    }));
  }

  List<Widget> _orderList(){
    List<Widget> order = [];
    for(int i = 0; i < onGoingOrderList.length; i++){
      order.add(GestureDetector(
        child: Card(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: 'https://$apiBaseUrl/public/${onGoingOrderList[i]['produk']['foto_produk']}',
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            onGoingOrderList[i]['transaksi']['status'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontStyle: FontStyle.italic
                            ),
                          ),
                          Text(
                            onGoingOrderList[i]['produk']['nama_produk'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          Text(
                            'x${onGoingOrderList[i]['transaksi']['jumlah']}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      Text(
                        'Rp. ${formatter.format(onGoingOrderList[i]['transaksi']['total_harga'])}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600
                        ),
                      )
                    ],
                  ),
                ),
                OutlinedButton(
                  style: const ButtonStyle(
                    side: WidgetStatePropertyAll(BorderSide(
                      color: Colors.white
                    ))
                  ),
                  onPressed: () => context.pushNamed('order', queryParameters: {'initial_index': '0'}),
                  child: const Text(
                    'Lihat',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                )
              ],
            ),
          )
        ),
      ));
    }

    return order;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            title: Text(
              'Notifikasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Visibility(
              visible: onGoingOrderList.isNotEmpty ? true : false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CarouselSlider(
                  items: _orderList(),
                  options: CarouselOptions(
                    enableInfiniteScroll: false,
                    disableCenter: true,
                    viewportFraction: .95,
                    height: 125
                  ),
                ),
              )
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 5,
                children: [
                  ChoiceChip(
                    label: const Text('Semua'),
                    selected: true,
                    onSelected: (bool selected){},
                  ),
                ],
              ),
            )
          ),
          FutureBuilder(
            future: getDataNotifikasi(context: context, type: 'Informasi', limit: limit),
            builder: (BuildContext context, AsyncSnapshot response){
              if(response.hasData){
                final notificationList = json.decode(response.data.body)['data'];
                return SliverList.builder(
                  itemCount: notificationList.length + 1,
                  itemBuilder: (BuildContext context, int index){
                    if(index != notificationList.length){
                      final notification = notificationList[index];
                      return SafeArea(
                        minimum: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.info_outline),
                                const Gap(10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            notification['jenis_notifikasi']
                                          ),
                                          Text(
                                            '${notification['waktu'].split('T')[0]} ${notification['waktu'].split('T')[1].substring(0, 8)}'
                                          )
                                        ],
                                      ),
                                      Text(
                                        notification['judul_notifikasi'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),
                                      Text(
                                        notification['detail_notifikasi']
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    }

                    return Visibility(
                      visible: limit - notificationList.length != 0 ? false : true,
                      child: Center(
                        child: SafeArea(
                          top: false,
                          minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: SizedBox(
                            child: FilledButton(
                              onPressed: () => setState(() {
                                limit += 20;
                              }),
                              child: const Text('Lebih banyak')
                            )
                          ),
                        ),
                      ),
                    );
                  },
                );
              }

              return const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}