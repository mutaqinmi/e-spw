import 'dart:convert';

import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FavoritePage extends StatefulWidget{
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>{
  bool favorite = true;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(),
          const SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              minimum: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Favorit',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Text('Toko yang anda sukai.'),
                  Gap(10),
                ],
              ),
            )
          ),
          FutureBuilder(
            future: getFavorit(context: context),
            builder: (BuildContext context, AsyncSnapshot response){
              if(response.hasData){
                final shopList = json.decode(response.data.body)['data'];
                return SliverList.builder(
                  itemCount: shopList.length,
                  itemBuilder: (BuildContext context, int index){
                    final shop = shopList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      elevation: 0,
                      child: Column(
                        children: [
                          Row(
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
                              IconButton(
                                onPressed: (){
                                  setState(() {
                                    favorite = !favorite;
                                  });

                                  if(!favorite){
                                    removeFromFavorite(
                                      context: context,
                                      idToko: shopList.first['toko']['id_toko']
                                    );
                                  } else {
                                    addToFavorit(
                                      context: context,
                                      idToko: shopList.first['toko']['id_toko']
                                    );
                                  }
                                },
                                icon: Icon(
                                  favorite ? Icons.favorite : Icons.favorite_outline,
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                            ],
                          ),
                          const Gap(5),
                          const Divider(
                            thickness: .5,
                            color: Colors.grey,
                          )
                        ],
                      )
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
      )
    );
  }
}