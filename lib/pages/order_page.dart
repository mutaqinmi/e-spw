import 'package:espw/app/dummy_data.dart';
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
  late List<Map> onGoingOrderList;
  late List<Map> finishedOrderList;
  @override
  void initState() {
    super.initState();
    onGoingOrderList = ordersOnGoing;
    finishedOrderList = ordersFinished;
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
            foregroundColor: Theme.of(context).primaryColor,
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
            shopName: order['shop_name'],
            productImage: order['product_image'],
            productName: order['product_name'],
            date: order['transaction_date'],
            priceTotal: order['price_total'],
            qty: order['qty'],
            isFinished: order['is_finished'],
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
            shopName: order['shop_name'],
            productImage: order['product_image'],
            productName: order['product_name'],
            date: order['transaction_date'],
            priceTotal: order['price_total'],
            qty: order['qty'],
            isFinished: order['is_finished'],
          );
        },
      ),
    );
  }
}

class OrderItem extends StatelessWidget{
  const OrderItem({super.key, required this.shopName, required this.productImage, required this.productName, required this.date, required this.priceTotal, required this.qty, required this.isFinished});
  final String shopName;
  final String productImage;
  final String productName;
  final String date;
  final int priceTotal;
  final int qty;
  final bool isFinished;

  Widget _isFinished(BuildContext context, bool isFinished){
    if(isFinished){
      return Wrap(
        spacing: 10,
        children: [
          OutlinedButton(
            onPressed: () => context.goNamed('shop'),
            child: const Text('Beli lagi'),
          ),
          FilledButton(
            onPressed: () => _rateOrder(context),
            child: const Text('Beri penilaian'),
          ),
        ],
      );
    }

    return FilledButton(
      onPressed: (){},
      child: const Text('Chat penjual'),
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
                    Text(shopName),
                  ],
                ),
                Text(
                  date
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _isFinished(context, isFinished)
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
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Pelayanan Toko'),
                        RatingBar(
                          itemSize: 26,
                          ratingWidget: RatingWidget(
                            full: Icon(Icons.star, color: Theme.of(context).primaryColor),
                            half: Icon(Icons.star_half, color: Theme.of(context).primaryColor),
                            empty: Icon(Icons.star_outline, color: Theme.of(context).primaryColor)
                          ),
                          onRatingUpdate: (rating){},
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Kepuasan Produk'),
                        RatingBar(
                          itemSize: 26,
                          ratingWidget: RatingWidget(
                            full: Icon(Icons.star, color: Theme.of(context).primaryColor),
                            half: Icon(Icons.star_half, color: Theme.of(context).primaryColor),
                            empty: Icon(Icons.star_outline, color: Theme.of(context).primaryColor)
                          ),
                          onRatingUpdate: (rating){},
                        ),
                      ],
                    ),
                  ),
                  const Gap(10),
                  TextFormField(
                    maxLines: 5,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                      hintText: 'Ceritakan tentang produk yang anda beli ...'
                    ),
                  ),
                  const Gap(20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: (){},
                      child: const Text('Beri penilaian'),
                    )
                  )
                ],
              ),
            ),
          )
        );
      }
    );
  }
}