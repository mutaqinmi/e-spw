import 'package:flutter/material.dart';

class OrderStatusPage extends StatefulWidget{
  const OrderStatusPage({super.key, this.initialIndex});
  final String? initialIndex;

  @override
  State<OrderStatusPage> createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage>{
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
              tabs: [
                Tab(
                  text: 'Semua',
                ),
                Tab(
                  text: 'Pesanan Baru',
                ),
                Tab(
                  text: 'Sedang Diantarkan',
                )
              ],
            ),
          )
        ],
        body: TabBarView(
          children: [
            _allOrders(),
            _newOrders(),
            _ongoingOrders(),
          ],
        ),
      ),
    );
  }

  Widget _allOrders(){
    return const Scaffold(
      body: Center(
        child: Text('Semua Pesanan'),
      ),
    );
  }

  Widget _newOrders(){
    return const Scaffold(
      body: Center(
        child: Text('Pesanan Baru'),
      ),
    );
  }

  Widget _ongoingOrders(){
    return const Scaffold(
      body: Center(
        child: Text('Sedang Diantarkan'),
      ),
    );
  }
}