import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ShopRatePage extends StatefulWidget{
  const ShopRatePage({super.key, required this.idToko});
  final String idToko;

  @override
  State<ShopRatePage> createState() => _ShopRatePageState();
}

class _ShopRatePageState extends State<ShopRatePage>{
  final formatter = NumberFormat('###,###.###', 'id_ID');
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text(
              'Penilaian',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          FutureBuilder(
            future: getUlasanByToko(context: context, idToko: widget.idToko),
            builder: (BuildContext context, AsyncSnapshot response){
              if(response.connectionState == ConnectionState.done){
                if(json.decode(response.data.body)['data'].isNotEmpty){
                  final rating = json.decode(response.data.body)['data'];
                  return SliverList.builder(
                    itemCount: rating.length,
                    itemBuilder: (BuildContext context, int index){
                      final rate = rating[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        elevation: 0,
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(
                                            rate['siswa']['foto_profil'].isEmpty ? 'https://$baseUrl/images/profile.png' : 'https://$apiBaseUrl/public/${rate['siswa']['foto_profil']}'
                                        ),
                                      ),
                                      const Gap(10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            rate['siswa']['nama'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600
                                            ),
                                          ),
                                          Text(
                                              rate['kelas']['kelas']
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    children: [
                                      RatingBar(
                                        ignoreGestures: true,
                                        allowHalfRating: true,
                                        initialRating: double.parse(rate['ulasan']['jumlah_rating']),
                                        itemSize: 18,
                                        ratingWidget: RatingWidget(
                                            full: Icon(Icons.star, color: Theme.of(context).primaryColor),
                                            half: Icon(Icons.star_half, color: Theme.of(context).primaryColor),
                                            empty: Icon(Icons.star_outline, color: Theme.of(context).primaryColor)
                                        ),
                                        onRatingUpdate: (rating){},
                                      ),
                                      const Gap(5),
                                      Text(
                                          rate['ulasan']['jumlah_rating']
                                      )
                                    ],
                                  ),
                                ),
                                Text(
                                  rate['transaksi']['waktu'].substring(0, 10),
                                  style: TextStyle(
                                      color: Colors.black.withAlpha(150)
                                  ),
                                ),
                                const Gap(5),
                                Card(
                                    elevation: 0,
                                    color: Colors.grey.withAlpha(80),
                                    shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Colors.grey,
                                            width: .5
                                        ),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl: 'https://$apiBaseUrl/public/${rate['produk']['foto_produk']}',
                                              width: 45,
                                              height: 45,
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
                                                      rate['toko']['nama_toko'],
                                                      style: TextStyle(
                                                          color: Colors.black.withAlpha(150)
                                                      ),
                                                    ),
                                                    Text(
                                                      rate['produk']['nama_produk'],
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.black.withAlpha(150)
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                          )
                                        ],
                                      ),
                                    )
                                ),
                                const Gap(5),
                                Text(
                                    rate['ulasan']['deskripsi_ulasan']
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
                          'assets/image/rate-review.png',
                          width: 200,
                        ),
                        const Gap(10),
                        const Text(
                          'Toko ini belum memiliki penilaian.',
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
      ),
    );
  }
}