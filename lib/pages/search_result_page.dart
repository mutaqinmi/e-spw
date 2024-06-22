import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:espw/app/controllers.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({super.key, this.searchQuery});
  final String? searchQuery;

  @override
  State<SearchResult> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchResult>{
  List productList = [];
  List shopList = [];
  @override
  void initState() {
    super.initState();
    search(context: context, query: widget.searchQuery!).then((res) => setState(() {
      productList = json.decode(res!.body)['dataProduk'];
      shopList = json.decode(res.body)['dataToko'];
    }));
  }

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: true,
            title: SizedBox(
              child: FilledButton(
                style: const ButtonStyle(
                  side: WidgetStatePropertyAll(BorderSide(
                    color: Color.fromARGB(255, 115, 115, 115),
                  )),
                  backgroundColor: WidgetStatePropertyAll(Colors.white),
                  foregroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 115, 115, 115)),
                  padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 15))
                ),
                onPressed: () => context.goNamed('search'),
                child: Row(
                  children: [
                    const Icon(Icons.search),
                    const Gap(10),
                    Expanded(
                      child: Text(widget.searchQuery!, overflow: TextOverflow.ellipsis),
                    )
                  ],
                ),
              ),
            ),
            actions: [
              FutureBuilder(
                future: getDataKeranjang(context: context),
                builder: (BuildContext context, AsyncSnapshot response){
                  if(response.hasData){
                    final cartCount = json.decode(response.data.body)['data'].length;
                    return Badge(
                      isLabelVisible: cartCount == 0 ? false : true,
                      offset: const Offset(-8, 8),
                      label: Text(cartCount.toString()),
                      child: IconButton(
                        onPressed: () => context.pushNamed('cart'),
                        icon: const Icon(Icons.shopping_cart_outlined),
                      ),
                    );
                  }

                  return IconButton(
                    onPressed: () => context.pushNamed('cart'),
                    icon: const Icon(Icons.shopping_cart_outlined),
                  );
                },
              ),
            ],
            bottom: const TabBar(
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: 'Produk'),
                Tab(text: 'Toko')
              ],
            ),
          )
        ],
        body: TabBarView(
          children: [
            _productResult(),
            _shopResult(),
          ],
        ),
      ),
    );
  }

  Widget _productResult(){
    return Scaffold(
      body: FutureBuilder(
        future: search(context: context, query: widget.searchQuery!),
        builder: (BuildContext context, AsyncSnapshot response){
          if(response.hasData && response.connectionState == ConnectionState.done && json.decode(response.data.body)['dataProduk'].isNotEmpty){
            return ListView.builder(
              itemCount: productList.length,
              itemBuilder: (BuildContext context, int index){
                final product = productList[index];
                return ProductResult(
                  imageURL: 'https://$apiBaseUrl/public/${product['produk']['foto_produk']}',
                  shopName: product['toko']['nama_toko'],
                  productName: product['produk']['nama_produk'],
                  soldTotal: product['produk']['jumlah_terjual'],
                  price: int.parse(product['produk']['harga']),
                  rating: double.parse(product['produk']['rating_produk']),
                  onTap: () => context.pushNamed('shop', queryParameters: {'shopID': product['toko']['id_toko']})
                );
              },
            );
          } else if (response.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/image/empty.png',
                  width: 250,
                ),
                const Gap(10),
                const Text(
                  'Produk tidak ditemukan!',
                  style: TextStyle(
                    fontStyle: FontStyle.italic
                  ),
                )
              ],
            ),
          );
        },
      )
    );
  }

  Widget _shopResult(){
    return Scaffold(
      body: FutureBuilder(
        future: search(context: context, query: widget.searchQuery!),
        builder: (BuildContext context, AsyncSnapshot response){
          if(response.hasData && response.connectionState == ConnectionState.done && json.decode(response.data.body)['dataToko'].isNotEmpty){
            return ListView.builder(
              itemCount: shopList.length,
              itemBuilder: (BuildContext context, int index){
                final shop = shopList[index];
                return ShopResult(
                  imageURL: 'http://$apiBaseUrl/public/${shop['toko']['foto_profil']}',
                  className: shop['kelas']['kelas'],
                  shopName: shop['toko']['nama_toko'],
                  onTap: () => context.pushNamed('shop', queryParameters: {'shopID': shop['toko']['id_toko']}),
                  fotoProduk: shop['produk']['foto_produk'],
                  namaProduk: shop['produk']['nama_produk'],
                  ratingProduk: double.parse(shop['produk']['rating_produk']),
                  deskripsiProduk: shop['produk']['deskripsi_produk'],
                  harga: shop['produk']['harga'],
                  jumlahTerjual: shop['produk']['jumlah_terjual'],
                );
              },
            );
          } else if (response.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/image/store-closed.png',
                  width: 250,
                ),
                const Gap(10),
                const Text(
                  'Toko tidak ditemukan!',
                  style: TextStyle(
                    fontStyle: FontStyle.italic
                  ),
                )
              ],
            ),
          );
        },
      )
    );
  }
}

class ProductResult extends StatelessWidget{
  const ProductResult({super.key, required this.imageURL, required this.shopName, required this.productName, required this.soldTotal, required this.price, required this.rating, this.onTap});
  final String imageURL;
  final String shopName;
  final String productName;
  final int soldTotal;
  final int price;
  final double rating;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context){
    NumberFormat formatter = NumberFormat("###,###.##", "id_ID");

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Card(
              elevation: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: imageURL,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      shopName,
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      productName,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    Text(
                                      'Terjual $soldTotal',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(20),
                                Text(
                                  'Rp. ${formatter.format(price)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Theme.of(context).primaryColor
                            ),
                            child: Wrap(
                              spacing: 5,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  rating.toString(),
                                  style: const TextStyle(
                                    color: Colors.white
                                  ),
                                ),
                                const Icon(
                                  Icons.star_rate_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ],
                            ),
                          )
                        ],
                      )
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
  }
}

class ShopResult extends StatelessWidget{
  const ShopResult({super.key, required this.imageURL, required this.className, required this.shopName, this.onTap, required this.fotoProduk, required this.namaProduk, required this.ratingProduk, required this.deskripsiProduk, required this.harga, required this.jumlahTerjual});
  final String imageURL;
  final String className;
  final String shopName;
  final void Function()? onTap;
  final String fotoProduk;
  final String namaProduk;
  final double ratingProduk;
  final String deskripsiProduk;
  final String harga;
  final int jumlahTerjual;

  @override
  Widget build(BuildContext context){
    final NumberFormat formatter = NumberFormat('###,###.###', 'id_ID');
    return SafeArea(
      top: false,
      bottom: false,
      minimum: const EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Card(
              elevation: 0,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      imageURL
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shopName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            Text(className)
                          ],
                        ),
                      ],
                    )
                  ),
                ],
              ),
            )
          ),
          const Gap(10),
          GestureDetector(
            onTap: onTap,
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
                            imageUrl: 'https://$apiBaseUrl/public/$fotoProduk',
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
                                Text(ratingProduk.toString()),
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
                                          namaProduk,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white
                                          ),
                                        ),
                                        Text(
                                          deskripsiProduk,
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
                                        'Rp. ${formatter.format(int.parse(harga))}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white
                                        ),
                                      ),
                                      Text(
                                        'Terjual $jumlahTerjual',
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
          const Gap(10),
          const Divider(
            thickness: 0.2,
          )
        ],
      )
    );
  }
}