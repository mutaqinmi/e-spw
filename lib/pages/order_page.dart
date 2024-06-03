import 'dart:convert';
import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatefulWidget{
  const OrderPage({super.key, required this.initialIndex});
  final String? initialIndex;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>{
  List onGoingOrderList = [];
  List finishedOrderList = [];
  List rating = [];
  @override
  void initState() {
    super.initState();
    orders(statusPesanan: 'Menunggu Konfirmasi').then((res) => setState(() {
      for(int i = 0; i < json.decode(res.body)['data'].length; i++){
        onGoingOrderList.add(json.decode(res.body)['data'][i]);
      }
    }));
    orders(statusPesanan: 'Diproses').then((res) => setState(() {
      for(int i = 0; i < json.decode(res.body)['data'].length; i++){
        onGoingOrderList.add(json.decode(res.body)['data'][i]);
      }
    }));
    orders(statusPesanan: 'Selesai').then((res) => setState(() {
      for(int i = 0; i < json.decode(res.body)['data'].length; i++){
        finishedOrderList.add(json.decode(res.body)['data'][i]);
      }
    }));
    getRate().then((res) => setState(() {
      List response = json.decode(res.body)['data'];
      for(int i = 0; i < response.length; i++){
        rating.add(response[i]['ulasan']['id_transaksi']);
      }
    }));
  }

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      initialIndex: widget.initialIndex == null ? 0 : int.parse(widget.initialIndex.toString()),
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerChildIsScrolled) => [
          SliverAppBar(
            forceElevated: innerChildIsScrolled,
            floating: true,
            pinned: true,
            snap: true,
            title: const Text(
              'Pesanan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
            ),
            bottom: const TabBar(
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: 'Diproses'),
                Tab(text: 'Selesai')
              ],
            ),
          )
        ],
        body: TabBarView(
          children: [
            _ongoingOrder(),
            _finishedOrder()
          ],
        ),
      ),
    );
  }

  Widget _ongoingOrder(){
    return Scaffold(
      body: ListView.builder(
        itemCount: onGoingOrderList.length,
        itemBuilder: (BuildContext context, int index){
          final order = onGoingOrderList[index];
          return OrderItem(
            shopName: order['toko']['nama_toko'],
            productImage: 'https://$baseUrl/assets/public/${order['produk']['foto_produk']}',
            productName: order['produk']['nama_produk'],
            date: order['transaksi']['waktu'].substring(0, 10),
            priceTotal: order['transaksi']['total_harga'],
            qty: order['transaksi']['jumlah'],
            status: order['transaksi']['status'],
            catatan: order['transaksi']['catatan'],
            idTransaksi: order['transaksi']['id_transaksi'],
            idToko: order['toko']['id_toko'],
          );
        },
      ),
    );
  }

  Widget _finishedOrder(){
    return Scaffold(
      body: ListView.builder(
        itemCount: finishedOrderList.length,
        itemBuilder: (BuildContext context, int index){
          final order = finishedOrderList[index];
          return OrderItem(
            shopName: order['toko']['nama_toko'],
            productImage: 'https://$baseUrl/assets/public/${order['produk']['foto_produk']}',
            productName: order['produk']['nama_produk'],
            date: order['transaksi']['waktu'].substring(0, 10),
            priceTotal: order['transaksi']['total_harga'],
            qty: order['transaksi']['jumlah'],
            status: order['transaksi']['status'],
            catatan: order['transaksi']['catatan'],
            idProduk: order['produk']['id_produk'],
            idTransaksi: order['transaksi']['id_transaksi'],
            idToko: order['toko']['id_toko'],
            rating: rating,
          );
        },
      ),
    );
  }
}

class OrderItem extends StatefulWidget{
  const OrderItem({super.key, required this.shopName, required this.productImage, required this.productName, required this.date, required this.priceTotal, required this.qty, required this.status, required this.catatan, this.idTransaksi, this.idToko, this.idProduk, this.rating});
  final String shopName;
  final String productImage;
  final String productName;
  final String date;
  final int priceTotal;
  final int qty;
  final String status;
  final String catatan;
  final String? idTransaksi;
  final String? idToko;
  final String? idProduk;
  final List? rating;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem>{
  double initialRate = 0;
  final _ulasanKey = GlobalKey<FormFieldState>();
  String _ulasan = '';

  Widget _status(String status){
    if(status == 'Menunggu Konfirmasi'){
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(15))
        ),
        child: const Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 12,
              color: Colors.white,
            ),
            Text(
              'Menunggu Konfirmasi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12
              ),
            )
          ],
        ),
      );
    } else if (status == 'Diproses'){
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        decoration: const BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(15))
        ),
        child: const Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 12,
              color: Colors.white,
            ),
            Text(
              'Diproses',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12
              ),
            )
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      child: const Wrap(
        spacing: 5,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(
            Icons.done,
            size: 12,
            color: Colors.white,
          ),
          Text(
            'Selesai',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12
            ),
          )
        ],
      ),
    );
  }

  Widget _isFinished(BuildContext context, String status, String? idToko){
    if(status == 'Selesai'){
      return Wrap(
        spacing: 10,
        children: [
          OutlinedButton(
            onPressed: () => context.goNamed('shop', queryParameters: {'shopID': idToko}),
            child: const Text('Beli lagi'),
          ),
          Visibility(
            visible: widget.rating!.contains(widget.idTransaksi) ? false : true,
            child: FilledButton(
              onPressed: () => _rateOrder(context),
              child: const Text('Beri penilaian'),
            ),
          )
        ],
      );
    } else if (status == 'Diproses'){
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
    }

    return const SizedBox();
  }

  void _submit(){
    _ulasanKey.currentState!.save();
    rateProduct(
      context: context,
      idProduk: widget.idProduk!,
      idTransaksi: widget.idTransaksi!,
      ulasan: _ulasan,
      rate: initialRate.toString()
    );
  }

  @override
  Widget build(BuildContext context){
    final formatter = NumberFormat('###,###.###', 'id_ID');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Wrap(
                  spacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Icon(Icons.storefront),
                    Text(widget.shopName),
                  ],
                ),
                Text(
                  widget.date
                )
              ],
            )
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: widget.productImage,
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
                      _status(widget.status),
                      const Gap(5),
                      Text(
                        widget.productName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      Text(
                        'Rp. ${formatter.format(widget.priceTotal)}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'x${widget.qty}',
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
              child: Row(
                children: [
                  const Text('Catatan:'),
                  const Gap(5),
                  Expanded(
                    child: Text(widget.catatan == '' ? '...' : widget.catatan),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _isFinished(context, widget.status, widget.idToko)
            ],
          ),
          const Gap(20)
        ],
      ),
    );
  }

  _rateOrder(BuildContext context){
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context){
        return SingleChildScrollView(
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState){
                        return RatingBar(
                          itemSize: 40,
                          ratingWidget: RatingWidget(
                            full: Icon(Icons.star_rounded, color: Theme.of(context).primaryColor),
                            half: Icon(Icons.star_half_rounded, color: Theme.of(context).primaryColor),
                            empty: Icon(Icons.star_outline_rounded, color: Theme.of(context).primaryColor)
                          ),
                          onRatingUpdate: (rating) => setState((){
                            initialRate = rating;
                          }),
                        );
                      },
                    )
                  ),
                  const Divider(
                    thickness: .5,
                    color: Colors.grey,
                  ),
                  const Gap(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Apa yang buat anda puas?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const Gap(10),
                      TextFormField(
                        key: _ulasanKey,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15))
                          ),
                          hintText: 'Contoh: Rasanya pas tidak terlalu pedas dan tidak terlalu hambar, pengantarannya cepat'
                        ),
                        onSaved: (value) => _ulasan = value!,
                      ),
                    ],
                  ),
                  const Gap(20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: () => _submit(),
                      child: const Text('Beri penilaian'),
                    )
                  ),
                ],
              ),
            ),
          )
        );
      }
    ).whenComplete(() => setState(() {
      initialRate = 0;
      _ulasan = '';
    }));
  }
}