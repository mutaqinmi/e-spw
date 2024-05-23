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
  final int cartBadge = 0;
  @override
  void initState() {
    super.initState();
    search(widget.searchQuery!).then((res) => {
      setState(() {
        productList = json.decode(res.body)['dataProduk'];
        shopList = json.decode(res.body)['dataToko'];
      })
    });
  }

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
          SliverAppBar(
            forceElevated: innerBoxIsScrolled,
            foregroundColor: Theme.of(context).primaryColor,
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
                onPressed: (){
                  context.goNamed('search');
                },
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
        future: products(),
        builder: (BuildContext context, AsyncSnapshot response){
          if(response.hasData || response.connectionState == ConnectionState.done){
            return ListView.builder(
              itemCount: productList.length,
              itemBuilder: (BuildContext context, int index){
                final product = productList[index];
                return ProductResult(
                  imageURL: 'http://$baseUrl/assets/public/${product['produk']['foto_produk']}',
                  shopName: product['toko']['nama_toko'],
                  productName: product['produk']['nama_produk'],
                  soldTotal: product['produk']['jumlah_terjual'],
                  price: int.parse(product['produk']['harga']),
                  rating: double.parse(product['produk']['rating_produk']),
                  onTap: () => context.pushNamed('shop', queryParameters: {'shopID': product['toko']['id_toko']})
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }

  Widget _shopResult(){
    return Scaffold(
      body: FutureBuilder(
        future: shop(),
        builder: (BuildContext context, AsyncSnapshot response){
          if(response.hasData || response.connectionState == ConnectionState.done){
            return ListView.builder(
              itemCount: shopList.length,
              itemBuilder: (BuildContext context, int index){
                final shop = shopList[index];
                return ShopResult(
                  imageURL: 'http://$baseUrl/assets/public/${shop['toko']['banner_toko']}',
                  className: shop['kelas']['kelas'],
                  shopName: shop['toko']['nama_toko'],
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
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
      bottom: false,
      minimum: const EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
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
                        Row(
                          children: [
                            Icon(Icons.star_rate_rounded, color: Theme.of(context).primaryColor),
                            Text(rating.toString())
                          ],
                        )
                      ],
                    )
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
  }
}

class ShopResult extends StatelessWidget{
  const ShopResult({super.key, required this.imageURL, required this.className, required this.shopName, this.onTap});
  final String imageURL;
  final String className;
  final String shopName;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context){
    return SafeArea(
      top: false,
      bottom: false,
      minimum: const EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
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
          ),
          const Gap(10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Placeholder(
                fallbackHeight: 110,
                fallbackWidth: 110,
              ),
              Placeholder(
                fallbackHeight: 110,
                fallbackWidth: 110,
              ),
              Placeholder(
                fallbackHeight: 110,
                fallbackWidth: 110,
              )
            ],
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