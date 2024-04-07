import 'package:espw/app/dummy_data.dart';
import 'package:espw/widgets/order_item.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget{
  const OrderPage({super.key});

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