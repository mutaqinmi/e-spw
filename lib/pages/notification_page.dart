import 'dart:convert';

import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NotificationPage extends StatefulWidget{
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>{
  // bool _isTransaction = false;

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
                  // ChoiceChip(
                  //   label: const Text('Transaksi'),
                  //   selected: _isTransaction,
                  //   onSelected: (bool selected) => setState(() {
                  //     _isTransaction = !_isTransaction;
                  //   }),
                  // ),
                ],
              ),
            )
          ),
          FutureBuilder(
            future: getNotification(type: 'Informasi'),
            builder: (BuildContext context, AsyncSnapshot response){
              if(response.hasData){
                final notificationList = json.decode(response.data.body)['data'];
                return SliverList.builder(
                  itemCount: notificationList.length,
                  itemBuilder: (BuildContext context, int index){
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