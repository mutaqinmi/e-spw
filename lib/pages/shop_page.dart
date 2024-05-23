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
  const ShopPage({super.key, this.shopID});
  final String? shopID;

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage>{
  NumberFormat formatter = NumberFormat("###,###.##", "id_ID");
  int qty = 0;

  List shopList = [];
  final int cartBadge = 0;
  @override
  void initState() {
    super.initState();
    shopById(widget.shopID).then((res) => setState(() {
      shopList = json.decode(res.body)['data'];
    }));
    // cartBadge = carts.length;
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
    if(qty != 0){
      addToCart(idProduk, qty).then((res) => {
        if(res.statusCode == 200){
          successSnackBar(
            context: context,
            content: 'Produk berhasil ditambahkan!'
          ),
          context.pop()
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
        onRefresh: (){
          return Future.delayed(const Duration(seconds: 1), (){
            shopById(widget.shopID).then((res) => setState(() {
              shopList = json.decode(res.body)['data'];
            }));
          });
        },
        child: FutureBuilder(
          future: shopById(widget.shopID),
          builder: (BuildContext context, AsyncSnapshot response){
            if(response.hasData || response.connectionState == ConnectionState.done){
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    foregroundColor: Theme.of(context).primaryColor,
                    pinned: true,
                    actions: [
                      IconButton(
                        onPressed: (){},
                        icon: const Icon(Icons.info_outline),
                      ),
                      Badge(
                        isLabelVisible: cartBadge == 0 ? false : true,
                        offset: const Offset(-8, 8),
                        label: Text(cartBadge.toString()),
                        child: IconButton(
                          onPressed: (){
                            context.pushNamed('cart');
                          },
                          icon: const Icon(Icons.shopping_cart_outlined),
                        ),
                      ),
                    ],
                    expandedHeight: 200,
                    flexibleSpace: FlexibleSpaceBar(
                      background: CachedNetworkImage(
                        imageUrl: 'https://$baseUrl/assets/public/${shopList.first['toko']['banner_toko']}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SafeArea(
                      top: false,
                      minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                              IconButton(
                                onPressed: (){},
                                icon: Icon(Icons.favorite_outline, color: Theme.of(context).primaryColor),
                              )
                            ],
                          ),
                          const Gap(20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Wrap(
                                spacing: 5,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    'Unggulan',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                  )
                                ],
                              ),
                              const Text(
                                'Yang paling disukai di toko ini.',
                              ),
                              const Gap(10),
                              GestureDetector(
                                onTap: (){_showAddToCart(0);},
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
                                                imageUrl: 'http://$baseUrl/assets/public/${shopList.first['produk']['foto_produk']}',
                                                width: double.infinity,
                                                height: 200,
                                                fit: BoxFit.cover,
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
                                                child: Row(
                                                  children: [
                                                    Text(shopList.first['produk']['rating_produk'].toString()),
                                                    Icon(Icons.star_rate_rounded, color: Theme.of(context).primaryColor),
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
                                                              shopList.first['produk']['nama_produk'],
                                                              overflow: TextOverflow.ellipsis,
                                                              style: const TextStyle(
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.w600,
                                                                color: Colors.white
                                                              ),
                                                            ),
                                                            Text(
                                                              shopList.first['produk']['deskripsi_produk'],
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
                                                            'Rp. ${formatter.format(int.parse(shopList.first['produk']['harga']))}',
                                                            style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.white
                                                            ),
                                                          ),
                                                          Text(
                                                            'Terjual ${shopList.first['produk']['jumlah_terjual']}',
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
                              )
                            ],
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
                              onTap: (){},
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: 'http://$baseUrl/assets/public/${product['produk']['foto_produk']}',
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
                                                'Terjual ${product['produk']['jumlah_terjual']}',
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
                                                onPressed: (){_showAddToCart(index);},
                                                style: const ButtonStyle(
                                                  visualDensity: VisualDensity.compact
                                                ),
                                                child: const Text('Tambah'),
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
                            const Gap(10),
                            const Divider(
                              thickness: 0.2,
                            )
                          ],
                        )
                      );
                    },
                  ),
                ],
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )
      )
    );
  }

  void _showAddToCart(int index){
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context){
        return SingleChildScrollView(
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
                              imageUrl: 'http://$baseUrl/assets/public/${shopList[index]['produk']['foto_produk']}',
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
                                        'Terjual ${shopList[index]['produk']['jumlah_terjual']}',
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
                                                  setState(() {
                                                    qty++;
                                                  });
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
                )
              ],
            )
          ),
        );
      }
    ).whenComplete(() {
      setState(() {
        qty = 0;
      });
    });
  }
}