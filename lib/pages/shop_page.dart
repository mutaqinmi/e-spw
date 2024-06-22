import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:espw/app/controllers.dart';
import 'package:espw/widgets/bottom_snack_bar.dart';

class ShopPage extends StatefulWidget{
  const ShopPage({super.key, required this.shopID});
  final String shopID;

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage>{
  NumberFormat formatter = NumberFormat("###,###.##", "id_ID");
  final _catatanKey = GlobalKey<FormFieldState>();
  String _catatan = '';
  int qty = 0;
  bool subscribe = false;

  List shopList = [];
  List topProductList = [];
  String cartCount = '';
  bool favorite = false;
  @override
  void initState() {
    super.initState();
    getTokoByIdToko(context: context, shopId: widget.shopID).then((res) => setState(() {
      shopList = json.decode(res!.body)['data'];
    }));
    getDataTopProdukByToko(context: context, idToko: widget.shopID).then((res) => setState(() {
      topProductList = json.decode(res!.body)['data'];
    }));
    // getDataKeranjang(context: context).then((res) => setState(() {
    //   cartCount = json.decode(res!.body)['data'].length.toString();
    // }));
    getFavorit(context: context).then((res){
      List data = json.decode(res!.body)['data'];
      for(int i = 0; i < data.length; i++){
        if(data[i]['toko']['id_toko'] != shopList.first['toko']['id_toko']){
          Future.delayed(const Duration(seconds: 1), (){
            setState(() {
              favorite = false;
            });
          });
        } else {
          Future.delayed(const Duration(seconds: 1), (){
            setState(() {
              favorite = true;
            });
          });
        }
      }
    });
  }

  Widget _isOpen(bool isOpen){
    if(isOpen){
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        decoration: const BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(15))
        ),
        child: const Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 12,
              color: Colors.white,
            ),
            Text(
              'Buka',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12
              ),
            )
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      child: const Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 5,
        children: [
          Icon(
            Icons.cancel_outlined,
            size: 12,
            color: Colors.white,
          ),
          Text(
            'Tutup',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12
            ),
          )
        ],
      ),
    );
  }

  void _addToCart(BuildContext context, String idProduk, int qty){
    _catatanKey.currentState!.save();
    if(qty != 0){
      addToKeranjang(
        context: context,
        idProduk: idProduk,
        qty: qty,
        catatan: _catatan
      ).then((res){
        if(res!.statusCode == 200){
          successSnackBar(
            context: context,
            content: 'Produk berhasil ditambahkan!'
          );
          context.pop();
        }
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: const Text('Tentukan jumlah produk yang akan dibeli!'),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('OK'),
            )
          ],
        )
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => Future.delayed(const Duration(seconds: 1), (){
          getTokoByIdToko(context: context, shopId: widget.shopID).then((res) => setState(() {
            shopList = json.decode(res!.body)['data'];
          }));
          getDataTopProdukByToko(context: context, idToko: widget.shopID).then((res) => setState(() {
            topProductList = json.decode(res!.body)['data'];
          }));
          // getDataKeranjang(context: context).then((res) => setState(() {
          //   cartCount = json.decode(res!.body)['data'].length.toString();
          // }));
          getFavorit(context: context).then((res){
            List data = json.decode(res!.body)['data'];
            for(int i = 0; i < data.length; i++){
              if(data[i]['toko']['id_toko'] != shopList.first['toko']['id_toko']){
                Future.delayed(const Duration(seconds: 1), (){
                  setState(() {
                    favorite = false;
                  });
                });
              } else {
                Future.delayed(const Duration(seconds: 1), (){
                  setState(() {
                    favorite = true;
                  });
                });
              }
            }
          });
        }),
        child: FutureBuilder(
          future: getTokoByIdToko(context: context, shopId: widget.shopID),
          builder: (BuildContext context, AsyncSnapshot response){
            if(response.hasData){
              if(shopList.isNotEmpty){
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      foregroundColor: Theme.of(context).primaryColor,
                      expandedHeight: 200,
                      flexibleSpace: FlexibleSpaceBar(
                        background: CachedNetworkImage(
                          imageUrl: 'https://$apiBaseUrl/public/${shopList.first['toko']['foto_profil']}',
                          fit: BoxFit.cover,
                        ),
                      ),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(20),
                        child: Container(
                          width: double.infinity,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                          ),
                        )
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SafeArea(
                        top: false,
                        minimum: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        spacing: 5,
                                        children: [
                                          Text(
                                            '${shopList.first['toko']['nama_toko']}',
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600
                                            ),
                                          ),
                                          _isOpen(shopList.first['toko']['is_open'])
                                        ],
                                      ),
                                      Text(
                                        shopList.first['toko']['deskripsi_toko'],
                                      ),
                                      const Gap(5),
                                      Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        spacing: 5,
                                        children: [
                                          RatingBar(
                                            ignoreGestures: true,
                                            allowHalfRating: true,
                                            initialRating: double.parse(shopList.first['toko']['rating_toko']),
                                            itemSize: 18,
                                            ratingWidget: RatingWidget(
                                              full: Icon(Icons.star, color: Theme.of(context).primaryColor),
                                              half: Icon(Icons.star_half, color: Theme.of(context).primaryColor),
                                              empty: Icon(Icons.star_outline, color: Theme.of(context).primaryColor)
                                            ),
                                            onRatingUpdate: (rating){},
                                          ),
                                          Text(
                                            shopList.first['toko']['rating_toko'].toString()
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                FutureBuilder(
                                  future: getFavorit(context: context),
                                  builder: (BuildContext context, AsyncSnapshot response){
                                    if(response.hasData){
                                      return IconButton(
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
                                      );
                                    }

                                    return const SizedBox();
                                  },
                                )
                              ],
                            ),
                            const Gap(10),
                            GestureDetector(
                              onTap: () => _showAddToCart(0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Card(
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(15),
                                            child: CachedNetworkImage(
                                              imageUrl: 'https://$apiBaseUrl/public/${topProductList.first['produk']['foto_produk']}',
                                              width: double.infinity,
                                              height: 200,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10), topLeft: Radius.circular(15)),
                                                color: Theme.of(context).primaryColor
                                              ),
                                              child: const Text(
                                                'Terfavorit!',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600
                                                ),
                                              )
                                            ),
                                          ),
                                          Positioned(
                                            top: 10,
                                            right: 10,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                                color: Colors.white
                                              ),
                                              child: Wrap(
                                                spacing: 2,
                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                children: [
                                                  Text(topProductList.first['produk']['rating_produk'].toString()),
                                                  Icon(
                                                    Icons.star_rate_rounded,
                                                    color: Theme.of(context).primaryColor,
                                                    size: 16,
                                                  ),
                                                ],
                                              )
                                            ),
                                          ),
                                          Positioned(
                                            left: 0,
                                            right: 0,
                                            bottom: 0,
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.transparent,
                                                    Colors.black
                                                  ]
                                                )
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            topProductList.first['produk']['nama_produk'],
                                                            overflow: TextOverflow.ellipsis,
                                                            style: const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.white
                                                            ),
                                                          ),
                                                          Text(
                                                            topProductList.first['produk']['deskripsi_produk'],
                                                            overflow: TextOverflow.ellipsis,
                                                            style: const TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.white
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Gap(20),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          'Rp. ${formatter.format(int.parse(topProductList.first['produk']['harga']))}',
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.white
                                                          ),
                                                        ),
                                                        Text(
                                                          'Terjual ${topProductList.first['produk']['jumlah_terjual']}',
                                                          style: const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.white
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Gap(20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Menu',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                                Text(
                                  'Semua menu (${shopList.length})'
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SliverList.builder(
                      itemCount: shopList.length,
                      itemBuilder: (BuildContext context, int index){
                        final product = shopList[index];
                        return SafeArea(
                          top: false,
                          bottom: false,
                          minimum: const EdgeInsets.only(left: 16, right: 16, top: 10),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => showModalBottomSheet(
                                  isScrollControlled: true,
                                  showDragHandle: true,
                                  context: context,
                                  builder: (BuildContext context) => SingleChildScrollView(
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 18),
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: CachedNetworkImage(
                                              imageUrl: 'https://$apiBaseUrl/public/${product['produk']['foto_produk']}',
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const Gap(10),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      product['produk']['nama_produk'],
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 26,
                                                        fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                    Text(
                                                      'Terjual ${product['produk']['jumlah_terjual']} | Stok ${product['produk']['stok']}',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Text(product['produk']['deskripsi_produk']),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                'Rp. ${formatter.format(int.parse(product['produk']['harga']))}',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ),
                                child: Card(
                                  elevation: 0,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: 'https://$apiBaseUrl/public/${product['produk']['foto_produk']}',
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
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    product['produk']['nama_produk'],
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600
                                                    ),
                                                  ),
                                                  Text(
                                                    'Terjual ${product['produk']['jumlah_terjual']} | Stok ${product['produk']['stok']}',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Gap(20),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    'Rp. ${formatter.format(int.parse(product['produk']['harga']))}',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w600
                                                    ),
                                                  ),
                                                  OutlinedButton(
                                                    onPressed: () => _showAddToCart(index),
                                                    style: const ButtonStyle(
                                                      visualDensity: VisualDensity.compact
                                                    ),
                                                    child: const Text('Beli'),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ),
                              const Gap(5),
                              const Divider(
                                thickness: 0.2,
                              )
                            ],
                          )
                        );
                      },
                    ),
                    FutureBuilder(
                      future: getUlasanByToko(context: context, idToko: widget.shopID),
                      builder: (BuildContext context, AsyncSnapshot response){
                        if(response.hasData){
                          if(json.decode(response.data.body)['data'].isNotEmpty){
                            return SliverToBoxAdapter(
                              child: SafeArea(
                                minimum: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Ulasan',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        Text(
                                          'Ulasan terbaru.',
                                        ),
                                      ],
                                    ),
                                    OutlinedButton(
                                      onPressed: () => context.pushNamed('review-area', queryParameters: {'id_toko': widget.shopID}),
                                      child: const Text('Lihat Semua'),
                                    )
                                  ],
                                )
                              )
                            );
                          }
                        }

                        return const SliverToBoxAdapter();
                      },
                    ),
                    FutureBuilder(
                      future: getUlasanByToko(context: context, idToko: widget.shopID),
                      builder: (BuildContext context, AsyncSnapshot response){
                        if(response.hasData){
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

                        return const SliverFillRemaining(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    )
                  ],
                );
              } else if (shopList.isEmpty){
                return const CustomScrollView(
                  slivers: [
                    SliverAppBar(),
                    SliverFillRemaining(
                      child: Center(
                        child: Text('Toko ini belum memiliki produk.'),
                      ),
                    )
                  ],
                );
              }
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )
      ),
      floatingActionButton: StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 1)).asyncMap((t) => getDataKeranjang(context: context)),
        builder: (BuildContext context, AsyncSnapshot response){
          if(response.hasData){
            return FloatingActionButton(
              onPressed: () => context.pushNamed('cart'),
              child: Badge(
                label: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    json.decode(response.data.body)['data'].length.toString(),
                    style: const TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            );
          }

          return FloatingActionButton(
            onPressed: () => context.pushNamed('cart'),
            child: const Icon(Icons.shopping_cart_outlined)
          );
        },
      ),
    );
  }

  void _showAddToCart(int index){
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context){
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: SafeArea(
              minimum: const EdgeInsets.only(left: 16, right: 16, top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Center(
                        child: Text(
                          'Tambahkan menu',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                      const Gap(20),
                      GestureDetector(
                        onTap: (){},
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: 'https://$apiBaseUrl/public/${shopList[index]['produk']['foto_produk']}',
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
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          shopList[index]['produk']['nama_produk'],
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        Text(
                                          'Terjual ${shopList[index]['produk']['jumlah_terjual']} | Stok ${shopList[index]['produk']['stok']}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Gap(30),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Rp. ${formatter.format(int.parse(shopList[index]['produk']['harga']))}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setState){
                                            return Row(
                                              children: [
                                                IconButton(
                                                  onPressed: (){
                                                    if(qty > 0){
                                                      setState(() {
                                                        qty--;
                                                      });
                                                    }
                                                  },
                                                  visualDensity: VisualDensity.compact,
                                                  style: ButtonStyle(
                                                    backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                                                    padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                                                  ),
                                                  icon: const Icon(
                                                    Icons.remove,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                  constraints: const BoxConstraints(
                                                    maxWidth: 50,
                                                    maxHeight: 50
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                  child: Center(
                                                    child: Text(
                                                      qty.toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16
                                                      ),
                                                    ),
                                                  )
                                                ),
                                                IconButton(
                                                  onPressed: (){
                                                    if(qty >= shopList[index]['produk']['stok']){
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) => const AlertDialog(
                                                          content: Text('Jumlah yang anda pilih melebihi batas stok barang!'),
                                                        )
                                                      );
                                                    }
                                                    if(qty < shopList[index]['produk']['stok']){
                                                      setState(() {
                                                        qty++;
                                                      });
                                                    }
                                                  },
                                                  visualDensity: VisualDensity.compact,
                                                  style: ButtonStyle(
                                                    backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                                                    padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                                                  ),
                                                  icon: const Icon(
                                                    Icons.add,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                  constraints: const BoxConstraints(
                                                    maxWidth: 50,
                                                    maxHeight: 50
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      key: _catatanKey,
                      maxLength: 50,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Colors.grey
                          )
                        ),
                        contentPadding: EdgeInsets.zero,
                        prefixIcon: Icon(Icons.sticky_note_2_outlined),
                        hintText: 'Tambah catatan ...'
                      ),
                      onSaved: (value) => _catatan = value!,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        onPressed: () => _addToCart(context, shopList[index]['produk']['id_produk'], qty),
                        child: const Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 5,
                          children: [
                            Icon(Icons.add, size: 14),
                            Text('Keranjang')
                          ],
                        ),
                      ),
                    )
                  ),
                ],
              )
            ),
          ),
        );
      }
    ).whenComplete(() => setState(() {
      qty = 0;
      // getDataKeranjang(context: context).then((res) => setState(() {
      //   cartCount = json.decode(res!.body)['data'].length.toString();
      // }));
    }));
  }
}