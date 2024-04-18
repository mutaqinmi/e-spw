import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget{
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>{
  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerChildIsScrolled) => [
          const SliverAppBar(
            title: Text(
              'Notifikasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'Informasi',
                ),
                Tab(
                  text: 'Transaksi',
                )
              ],
            ),
          )
        ],
        body: TabBarView(
          children: [
            _information(),
            _transaction()
          ],
        ),
      ),
    );
  }

  Widget _information(){
    return const Center(
      child: Text(
        'Information'
      ),
    );
  }

  Widget _transaction(){
    return const Center(
      child: Text(
        'Transaction'
      ),
    );
  }
}