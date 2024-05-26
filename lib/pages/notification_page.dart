import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget{
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>{
  bool _isTransaction = false;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            foregroundColor: Theme.of(context).primaryColor,
            title: const Text(
              'Notifikasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
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
                  ChoiceChip(
                    label: const Text('Transaksi'),
                    selected: _isTransaction,
                    onSelected: (bool selected) => setState(() {
                      _isTransaction = !_isTransaction;
                    }),
                  ),
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}