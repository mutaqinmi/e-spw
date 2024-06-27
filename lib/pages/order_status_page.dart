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
    getPesananByToko(context: context, idToko: widget.idToko, statusPesanan: 'Menunggu Konfirmasi Penjual').then((res) => setState(() {
      for(int i = 0; i < json.decode(res!.body)['data'].length; i++){
        onGoingOrderList.add(json.decode(res.body)['data'][i]);
      }
    }));
    getPesananByToko(context: context, idToko: widget.idToko, statusPesanan: 'Menunggu Konfirmasi Pembeli').then((res) => setState(() {
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
      body: finishedOrderList.isNotEmpty ? ListView.builder(
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
      ) : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/order.png',
              width: 200,
            ),
            const Gap(10),
            const Text(
              'Belum ada pesanan',
              style: TextStyle(
                fontStyle: FontStyle.italic
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _newOrders(){
    return Scaffold(
      body: newOrderList.isNotEmpty ? ListView.builder(
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
      ) : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/order.png',
              width: 200,
            ),
            const Gap(10),
            const Text(
              'Belum ada pesanan',
              style: TextStyle(
                fontStyle: FontStyle.italic
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _ongoingOrders(){
    return Scaffold(
      body: onGoingOrderList.isNotEmpty ? ListView.builder(
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
      ) : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/order.png',
              width: 200,
            ),
            const Gap(10),
            const Text(
              'Belum ada pesanan',
              style: TextStyle(
                fontStyle: FontStyle.italic
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OrderItem extends StatefulWidget{
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

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem>{
  Widget _status(BuildContext context, String status){
    if(status == 'Menunggu Konfirmasi'){
      return FilledButton(
        onPressed: (){
          updateStatusPesanan(
            context: context,
            idTransaksi: widget.idTransaksi!,
            status: 'Diproses',
            idToko: widget.idToko!
          );
        },
        child: const Text('Konfirmasi Pesanan'),
      );
    } else if (status == 'Diproses'){
      return FilledButton(
        onPressed: () => {
          updateStatusPesanan(
            context: context,
            idTransaksi: widget.idTransaksi!,
            status: 'Menunggu Konfirmasi Pembeli',
            idToko: widget.idToko!
          )
        },
        child: const Text('Selesaikan Pesanan'),
      );
    } else if (status == 'Menunggu Konfirmasi Penjual') {
      return FilledButton(
        onPressed: () => {
          updateStatusPesanan(
            context: context,
            idTransaksi: widget.idTransaksi!,
            status: 'Selesai',
          )
        },
        child: const Text('Selesaikan Pesanan'),
      );
    } else if (status == 'Menunggu Konfirmasi Pembeli') {
      return FilledButton(
        onPressed: () => {},
        child: const Text('Diminta'),
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
                  imageUrl: widget.productImage,
                  width: 75,
                  height: 75,
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
                        widget.productName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      Wrap(
                        spacing: 5,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text(
                            'Pemesan :',
                            style: TextStyle(
                              color: Colors.grey
                            ),
                          ),
                          Text(widget.nama)
                        ],
                      ),
                      Wrap(
                        spacing: 5,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text(
                            'Alamat :',
                            style: TextStyle(
                              color: Colors.grey
                            ),
                          ),
                          Text(widget.alamat)
                        ],
                      ),
                      Wrap(
                        spacing: 5,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text(
                            'Catatan :',
                            style: TextStyle(
                              color: Colors.grey
                            ),
                          ),
                          Text(widget.catatan)
                        ],
                      ),
                    ],
                  ),
                )
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Rp. ${formatter.format(widget.priceTotal)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  Text(
                    'x${widget.qty}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _status(context, widget.status),
            ],
          ),
          const Gap(20)
        ],
      ),
    );
  }
}