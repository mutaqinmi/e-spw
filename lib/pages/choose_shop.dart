import 'dart:convert';
import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ChooseShop extends StatefulWidget {
  const ChooseShop({super.key});

  @override
  State<ChooseShop> createState() => _ChooseShopState();
}

class _ChooseShopState extends State<ChooseShop>{
  List shopList = [];
  @override
  void initState() {
    super.initState();
    kelompok().then((res) => setState(() {
      shopList = json.decode(res.body)['data'];
    }));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(),
          const SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              minimum: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilih Toko',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22
                    ),
                  ),
                  Text(
                    'Masuk ke toko yang anda ikuti.'
                  ),
                  Gap(20)
                ],
              ),
            ),
          ),
          SliverList.builder(
            itemCount: shopList.length,
            itemBuilder: (BuildContext context, int index){
              final shop = shopList[index];
              return GestureDetector(
                onTap: () => context.pushNamed('shop-dash', queryParameters: {'id_toko': shop['toko']['id_toko']}),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: Colors.grey
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            'https://$apiBaseUrl/public/${shop['toko']['banner_toko']}'
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                shop['toko']['nama_toko'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              Text(
                                shop['kelas']['kelas']
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () => context.pushNamed('login-shop', queryParameters: {'isRedirect': 'false'}),
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    spacing: 5,
                    children: [
                      Icon(Icons.add, color: Theme.of(context).primaryColor),
                      Text(
                        'Tambahkan toko',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}