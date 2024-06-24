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
          const SliverAppBar(
            title: Text(
              'Favorit',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          FutureBuilder(
            future: getFavorit(context: context),
            builder: (BuildContext context, AsyncSnapshot response){
              if(response.connectionState == ConnectionState.done) {
                if(json.decode(response.data.body)['data'].isNotEmpty) {
                  final shopList = json.decode(response.data.body)['data'];
                  return SliverList.builder(
                    itemCount: shopList.length,
                    itemBuilder: (BuildContext context, int index) {
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
                                    'https://$apiBaseUrl/public/${shop['toko']['foto_profil']}'
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
                                  onPressed: () {
                                    setState(() {
                                      favorite = !favorite;
                                    });

                                    if (!favorite) {
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

                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/image/shop.png',
                          width: 200,
                        ),
                        const Gap(10),
                        const Text(
                          'Anda belum menyukai toko apapun.',
                          style: TextStyle(
                            fontStyle: FontStyle.italic
                          ),
                        )
                      ],
                    ),
                  ),
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