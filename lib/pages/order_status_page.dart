import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class OrderStatusPage extends StatefulWidget{
  const OrderStatusPage({super.key, required this.idToko, this.initialIndex});
  final String idToko;
  final String? initialIndex;

  @override
  State<OrderStatusPage> createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage>{
  List newOrderList = [];
  List onGoingOrderList = [];
  List finishedOrderList = [];
  @override
  void initState() {
    super.initState();
    getPesananByToko(context: context, idToko: widget.idToko, statusPesanan: 'Menunggu Konfirmasi').then((res) => setState(() {
      for(int i = 0; i < json.decode(res!.body)['data'].length; i++){
        newOrderList.add(json.decode(res.body)['data'][i]);
      }
    }));
    getPesananByToko(context: context, idToko: widget.idToko, statusPesanan: 'Diproses').then((res) => setState(() {
      for(int i = 0; i < json.decode(res!.body)['data'].length; i++){
        onGoingOrderList.add(json.decode(res.body)['data'][i]);
      }
    }));
    getPesananByToko(context: context, idToko: widget.idToko, statusPesanan: 'Selesai').then((res) => setState(() {
      for(int i = 0; i < json.decode(res!.body)['data'].length; i++){
        finishedOrderList.add(json.decode(res.body)['data'][i]);
      }
    }));
  }

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      initialIndex: widget.initialIndex == null ? 0 : int.parse(widget.initialIndex.toString()),
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerChildIsScrolled) => [
          const SliverAppBar(
            title: Text(
              'Pesanan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
            ),
            bottom: TabBar(
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  text: 'Pesanan Baru',
                ),
                Tab(
                  text: 'Diproses',
                ),
                Tab(
                  text: 'Selesai',
                ),
              ],
            ),
          )
        ],
        body: TabBarView(
          children: [
            _newOrders(),
            _ongoingOrders(),
            _allOrders(),
          ],
        ),
      ),
    );
  }

  Widget _allOrders(){
    return Scaffold(
      body: ListView.builder(
        itemCount: finishedOrderList.length,
        itemBuilder: (BuildContext context, int index){
          final order = finishedOrderList[index];
          return OrderItem(
            productImage: 'https://$apiBaseUrl/public/${order['produk']['foto_produk']}',
            productName: order['produk']['nama_produk'],
            date: order['transaksi']['waktu'].substring(0, 10),
            priceTotal: order['transaksi']['total_harga'],
            qty: order['transaksi']['jumlah'],
            status: order['transaksi']['status'],
            catatan: order['transaksi']['catatan'],
            nama: order['siswa']['nama'],
            fotoProfil: order['siswa']['foto_profil'],
            alamat: order['transaksi']['alamat'],
          );
        },
      ),
    );
  }

  Widget _newOrders(){
    return Scaffold(
      body: ListView.builder(
        itemCount: newOrderList.length,
        itemBuilder: (BuildContext context, int index){
          final order = newOrderList[index];
          return OrderItem(
            productImage: 'https://$apiBaseUrl/public/${order['produk']['foto_produk']}',
            productName: order['produk']['nama_produk'],
            date: order['transaksi']['waktu'].substring(0, 10),
            priceTotal: order['transaksi']['total_harga'],
            qty: order['transaksi']['jumlah'],
            status: order['transaksi']['status'],
            catatan: order['transaksi']['catatan'],
            idTransaksi: order['transaksi']['id_transaksi'],
            idToko: widget.idToko,
            nama: order['siswa']['nama'],
            fotoProfil: order['siswa']['foto_profil'],
            alamat: order['transaksi']['alamat'],
          );
        },
      ),
    );
  }

  Widget _ongoingOrders(){
    return Scaffold(
      body: ListView.builder(
        itemCount: onGoingOrderList.length,
        itemBuilder: (BuildContext context, int index){
          final order = onGoingOrderList[index];
          return OrderItem(
            productImage: 'https://$apiBaseUrl/public/${order['produk']['foto_produk']}',
            productName: order['produk']['nama_produk'],
            date: order['transaksi']['waktu'].substring(0, 10),
            priceTotal: order['transaksi']['total_harga'],
            qty: order['transaksi']['jumlah'],
            status: order['transaksi']['status'],
            catatan: order['transaksi']['catatan'],
            idTransaksi: order['transaksi']['id_transaksi'],
            idToko: widget.idToko,
            nama: order['siswa']['nama'],
            fotoProfil: order['siswa']['foto_profil'],
            alamat: order['transaksi']['alamat'],
          );
        },
      ),
    );
  }
}

class OrderItem extends StatelessWidget{
  const OrderItem({super.key, required this.productImage, required this.productName, required this.date, required this.priceTotal, required this.qty, required this.status, required this.catatan, this.idTransaksi, this.idToko, required this.nama, required this.fotoProfil, required this.alamat});
  final String productImage;
  final String productName;
  final String date;
  final int priceTotal;
  final int qty;
  final String status;
  final String catatan;
  final String? idTransaksi;
  final String? idToko;
  final String nama;
  final String fotoProfil;
  final String alamat;

  Widget _status(BuildContext context, String status){
    if(status == 'Menunggu Konfirmasi'){
      return FilledButton(
        onPressed: (){
          updateStatusPesanan(
            context: context,
            idTransaksi: idTransaksi!,
            status: 'Diproses',
            idToko: idToko!
          );
        },
        child: const Text('Konfirmasi Pesanan'),
      );
    } else if (status == 'Diproses'){
      return FilledButton(
        onPressed: () => {
          updateStatusPesanan(
            context: context,
            idTransaksi: idTransaksi!,
            status: 'Selesai',
            idToko: idToko!
          )
        },
        child: const Text('Selesaikan Pesanan'),
      );
    }

    return const SizedBox();
  }

  @override
  Widget build(BuildContext context){
    final formatter = NumberFormat('###,###.###', 'id_ID');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: productImage,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      Text(
                        'Rp. ${formatter.format(priceTotal)}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'x$qty',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ],
          ),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: .5,
              ),
              borderRadius: BorderRadius.circular(10)
            ),
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nama Pemesan:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      const Gap(5),
                      Expanded(
                        child: Text(nama),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Alamat:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      const Gap(5),
                      Expanded(
                        child: Text(alamat),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Catatan:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      const Gap(5),
                      Expanded(
                        child: Text(catatan == '' ? '...' : catatan),
                      )
                    ],
                  ),
                ],
              )
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _status(context, status)
            ],
          ),
          const Gap(20)
        ],
      ),
    );
  }
}