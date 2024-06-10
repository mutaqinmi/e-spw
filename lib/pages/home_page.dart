import 'dart:convert';
import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List shopList = [];
  List productList = [];
  @override
  void initState() {
    super.initState();
    shop().then((res) => setState(() {
      shopList = json.decode(res.body)['data'];
    }));
    products().then((res) => setState(() {
      productList = json.decode(res.body)['data'];
    }));
  }

  Widget _bannerList(BuildContext context){
    return const Carousel(
      banner: [
        Banner(
          imageURL: 'https://img.freepik.com/free-vector/hand-drawn-fast-food-sale-banner-template_23-2150992555.jpg?t=st=1711991574~exp=1711995174~hmac=4b0d453d2bfa45bbb32c55889576b1a011a16455d462cdc13aab000dae0226ca&w=900',
        ),
        Banner(
          imageURL: 'https://img.freepik.com/free-vector/flat-design-american-food-sale-banner_23-2149163587.jpg?t=st=1711991604~exp=1711995204~hmac=5de49a2ab6f0b442e7c2d6db47d1a5e55028e8efe8aa6438f9e793ad8d91fe75&w=900',
        ),
        Banner(
          imageURL: 'https://img.freepik.com/free-vector/flat-design-pizza-sale-banner_23-2149116013.jpg?t=st=1711991623~exp=1711995223~hmac=446528c1b3d4452aaa87fb4da8574e476b86b420b6708e9e8dca979fb8a41fa5&w=900',
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => Future.delayed(const Duration(seconds: 1), (){
          shop().then((res) => setState(() {
            shopList = json.decode(res.body)['data'];
          }));
          products().then((res) => setState(() {
            productList = json.decode(res.body)['data'];
          }));
        }),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              surfaceTintColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
              ),
              shadowColor: Colors.grey.withAlpha(50),
              pinned: true,
              expandedHeight: 265,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: _bannerList(context),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(10),
                child: AppBar(
                  surfaceTintColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
                  ),
                  toolbarHeight: 65,
                  title: SizedBox(
                    child: FilledButton(
                      style: const ButtonStyle(
                        side: WidgetStatePropertyAll(BorderSide(
                          color: Color.fromARGB(255, 155, 155, 155),
                          width: 0.5
                        )),
                        backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 245, 245, 245)),
                        foregroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 155, 155, 155)),
                        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 15))
                      ),
                      onPressed: () => context.pushNamed('search'),
                      child: const Row(
                        children: [
                          Icon(Icons.search),
                          Gap(10),
                          Text('Telusuri produk atau toko ...')
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SafeArea(
                top: false,
                bottom: false,
                minimum: const EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Toko',
                          style: TextStyle(
                            fontSize: 24,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        const Text(
                          'Jelajahi semua toko',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300
                          ),
                        ),
                        const Gap(5),
                        ChoiceChip(
                          label: const Text('Semua Toko'),
                          selected: true,
                          onSelected: (bool selected){},
                          showCheckmark: false,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 250,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: FutureBuilder(
                  future: shop(),
                  builder: (BuildContext context, AsyncSnapshot response){
                    if(response.connectionState == ConnectionState.done){
                      if(json.decode(response.data.body)['data'].isNotEmpty){
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: shopList.length,
                          itemBuilder: (BuildContext context, int index){
                            final shop = shopList[index];
                            return ShopCard(
                              imageURL: 'https://$apiBaseUrl/public/${shop['toko']['banner_toko']}',
                              className: shop['kelas']['kelas'],
                              shopName: shop['toko']['nama_toko'],
                              rating: double.parse(shop['toko']['rating_toko']),
                              onTap: () => context.pushNamed('shop', queryParameters: {'shopID': shop['toko']['id_toko']}),
                            );
                          },
                        );
                      }
                    } else if (response.connectionState == ConnectionState.waiting){
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (response.connectionState == ConnectionState.none){
                      return const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          child: Center(
                            child: Text(
                              'Gagal memuat',
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic
                              ),
                            ),
                          ),
                        )
                      );
                    }

                    return const Center(
                      child: Text(
                        'Toko tidak ditemukan.',
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SafeArea(
                top: false,
                bottom: false,
                minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explore',
                          style: TextStyle(
                            fontSize: 24,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        Text(
                          'Semua menu (${productList.length})',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ),
            ),
            FutureBuilder(
              future: products(),
              builder: (BuildContext context, AsyncSnapshot response){
                if(response.connectionState == ConnectionState.done){
                  if(json.decode(response.data.body)['data'].isNotEmpty){
                    return SliverList.builder(
                      itemCount: productList.length,
                      itemBuilder: (BuildContext context, int index){
                        final product = productList[index];
                        return ProductCard(
                          imageURL: 'https://$apiBaseUrl/public/${product['produk']['foto_produk']}',
                          productName: product['produk']['nama_produk'],
                          description: product['produk']['deskripsi_produk'],
                          soldTotal: product['produk']['jumlah_terjual'],
                          price: int.parse(product['produk']['harga']),
                          rating: double.parse(product['toko']['rating_toko']),
                          onTap: () => context.pushNamed('shop', queryParameters: {'shopID': product['produk']['id_toko']}),
                        );
                      },
                    );
                  }
                } else if (response.connectionState == ConnectionState.waiting){
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Center(
                        child: CircularProgressIndicator()
                      ),
                    )
                  );
                } else if (response.connectionState == ConnectionState.none){
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Center(
                        child: Text(
                          'Gagal memuat',
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic
                          ),
                        ),
                      ),
                    )
                  );
                }

                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Center(
                      child: Text(
                        'Tidak ada toko yang berjualan hari ini.',
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic
                        ),
                      ),
                    ),
                  )
                );
              },
            )
          ],
        ),
      )
    );
  }
}

class Carousel extends StatelessWidget{
  const Carousel({super.key, required this.banner});
  final List<Widget> banner;

  @override
  Widget build(BuildContext context){
    return CarouselSlider(
      items: banner,
      options: CarouselOptions(
        viewportFraction: 1,
        autoPlay: true,
      ),
    );
  }
}

class Banner extends StatelessWidget{
  const Banner({super.key, required this.imageURL, this.onTap});
  final String imageURL;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: onTap,
        child: CachedNetworkImage(
          imageUrl: imageURL,
          fit: BoxFit.cover,
        ),
      )
    );
  }
}

class ShopCard extends StatelessWidget{
  const ShopCard({super.key, required this.imageURL, required this.className, required this.shopName, required this.rating, this.onTap});
  final String imageURL;
  final String className;
  final String shopName;
  final double rating;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: SizedBox(
          width: 150,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: CachedNetworkImage(
                  imageUrl: imageURL,
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      className,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      shopName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    const Gap(15),
                    Row(
                      children: [
                        Icon(Icons.star_rate_rounded, color: Theme.of(context).primaryColor,),
                        const Gap(5),
                        Text(rating.toString())
                      ],
                    ),
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget{
  const ProductCard({super.key, required this.imageURL, required this.productName, required this.description, required this.soldTotal, required this.price, required this.rating, this.onTap});
  final String imageURL;
  final String productName;
  final String description;
  final int soldTotal;
  final int price;
  final double rating;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context){
    NumberFormat formatter = NumberFormat("###,###.##", "id_ID");

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 4,
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: imageURL,
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
                          Text(rating.toString()),
                          Icon(Icons.star_rate_rounded, color: Theme.of(context).primaryColor,),
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
                                    productName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white
                                    ),
                                  ),
                                  Text(
                                    description,
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
                                  'Rp. ${formatter.format(price)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white
                                  ),
                                ),
                                Text(
                                  'Terjual $soldTotal',
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
          )
        ),
      ),
    );
  }
}