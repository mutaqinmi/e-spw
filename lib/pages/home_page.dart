import 'dart:convert';
import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List shopList = [];
  List productList = [];
  List topShopList = [];
  List topProductList = [];
  @override
  void initState() {
    super.initState();
    checkPassword();
    getDataToko(context: context).then((res) => setState(() {
      shopList = json.decode(res!.body)['data'];
    }));
    getDataProduk(context: context).then((res) => setState(() {
      productList = json.decode(res!.body)['data'];
    }));
    getDataTopToko(context: context).then((res) => setState(() {
      topShopList = json.decode(res!.body)['data'];
    }));
    getDataTopProduk(context: context).then((res) => setState(() {
      topProductList = json.decode(res!.body)['data'];
    }));
  }

  Widget _bannerList(BuildContext context){
    return const Carousel(
      banner: [
        Banner(
          imageURL: 'https://$baseUrl/images/banner.png',
        ),
      ]
    );
  }

  List<Widget> _topProduct(){
    NumberFormat formatter = NumberFormat("###,###.##", "id_ID");
    List<Widget> product = [];
    for(int i = 0; i < topProductList.length; i++){
      product.add(GestureDetector(
        onTap: () => context.pushNamed('shop', queryParameters: {'shopID': topProductList[i]['toko']['id_toko']}),
        child: Card(
          elevation: 0,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: 'https://$apiBaseUrl/public/${topProductList[i]['produk']['foto_produk']}',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Visibility(
                visible: i == 0 ? true : false,
                child: Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10), topLeft: Radius.circular(15)),
                      color: Theme.of(context).primaryColor
                    ),
                    child: const Text(
                      'Terlaris!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                      ),
                    )
                  ),
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
                        Text(topProductList[i]['toko']['rating_toko'].toString()),
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
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                topProductList[i]['produk']['nama_produk'],
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white
                                ),
                              ),
                              Text(
                                topProductList[i]['produk']['deskripsi_produk'],
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
                              'Rp. ${formatter.format(int.parse(topProductList[i]['produk']['harga']))}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                              ),
                            ),
                            Text(
                              'Terjual ${topProductList[i]['produk']['jumlah_terjual']}',
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
        ),
      ));
    }

    return product;
  }

  Future<void> checkPassword() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isDefaultPassword = prefs.getBool('isDefaultPassword');
    if(!mounted) return;
    if(isDefaultPassword!){
      return showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        context: context,
        builder: (BuildContext context) => Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(
                      'assets/image/not-secure.png',
                      width: 250
                    ),
                    const Gap(30),
                    const Text(
                      'Amankan akun anda',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    const Text(
                      'Anda belum mengatur kata sandi anda. Untuk keamanan akun, segera ubah kata sandi anda!',
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: () => context.pushNamed('change-password'),
                  child: const Text('Ubah kata sandi'),
                ),
              )
            ],
          ),
        )
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => Future.delayed(const Duration(seconds: 1), (){
          getDataToko(context: context).then((res) => setState(() {
            shopList = json.decode(res!.body)['data'];
          }));
          getDataProduk(context: context).then((res) => setState(() {
            productList = json.decode(res!.body)['data'];
          }));
          getDataTopToko(context: context).then((res) => setState(() {
            topShopList = json.decode(res!.body)['data'];
          }));
          getDataTopProduk(context: context).then((res) => setState(() {
            topProductList = json.decode(res!.body)['data'];
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
                height: 210,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: FutureBuilder(
                  future: getDataToko(context: context),
                  builder: (BuildContext context, AsyncSnapshot response){
                    if(response.connectionState == ConnectionState.done){
                      if(response.hasData){
                        if(json.decode(response.data.body)['data'].isNotEmpty){
                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: shopList.length + 1,
                            itemBuilder: (BuildContext context, int index){
                              if(index != shopList.length){
                                final shop = shopList[index];
                                return ShopCard(
                                  imageURL: 'https://$apiBaseUrl/public/${shop['toko']['foto_profil']}',
                                  className: shop['kelas']['kelas'],
                                  shopName: shop['toko']['nama_toko'],
                                  rating: double.parse(shop['toko']['rating_toko']),
                                  onTap: () => context.pushNamed('shop', queryParameters: {'shopID': shop['toko']['id_toko']}),
                                );
                              }

                              return Card(
                                elevation: 0,
                                child: SizedBox(
                                  width: 150,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25),
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.keyboard_arrow_right,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const Gap(10),
                                        const Text('Lihat semua')
                                      ],
                                    ),
                                  )
                                ),
                              );
                            },
                          );
                        }
                      }
                    } else if (response.connectionState == ConnectionState.waiting){
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index){
                          return Card(
                            elevation: 2,
                            child: SizedBox(
                              width: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                    child: Container(
                                      width: double.infinity,
                                      height: 120,
                                      color: Colors.grey.withAlpha(100),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withAlpha(100),
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                        ),
                                        const Gap(10),
                                        Container(
                                          width: 100,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withAlpha(100),
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                        ),
                                      ],
                                    )
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Toko tidak ditemukan.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          const Text(
                            'Jadilah yang pertama membuka bisnis anda.',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const Gap(10),
                          OutlinedButton(
                            onPressed: () => context.pushNamed('login-shop'),
                            child: const Text('Buat toko'),
                          )
                        ],
                      )
                    );
                  },
                ),
              ),
            ),
            FutureBuilder(
              future: getDataTopToko(context: context),
              builder: (BuildContext context, AsyncSnapshot response){
                if(response.connectionState == ConnectionState.done){
                  if(response.hasData){
                    return SliverToBoxAdapter(
                      child: Visibility(
                        visible: topShopList.isNotEmpty ? true : false,
                        child: SafeArea(
                          top: false,
                          bottom: false,
                          minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Terfavorit',
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    const Text(
                                      'Top 3 toko paling disukai sama pelanggan eSPW!',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ),
                      )
                    );
                  }
                }

                return const SliverToBoxAdapter();
              },
            ),
            FutureBuilder(
              future: getDataTopToko(context: context),
              builder: (BuildContext context, AsyncSnapshot response){
                if(response.connectionState == ConnectionState.done){
                  if(response.hasData){
                    if(json.decode(response.data.body)['data'].isNotEmpty){
                      return SliverList.builder(
                        itemCount: topShopList.length,
                        itemBuilder: (BuildContext context, int index){
                          final shop = topShopList[index];
                          return ListTile(
                            onTap: () => context.pushNamed('shop', queryParameters: {'shopID': shop['toko']['id_toko']}),
                            leading: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Text(
                                (index + 1).toString(),
                                style: const TextStyle(
                                  color: Colors.white
                                ),
                              ),
                            ),
                            title: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: 'https://$apiBaseUrl/public/${shop['toko']['foto_profil']}',
                                    width: 65,
                                    height: 65,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const Gap(10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        shop['kelas']['kelas'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        shop['toko']['nama_toko'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),
                                      Wrap(
                                        spacing: 5,
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          Text(shop['toko']['rating_toko']),
                                          const Icon(Icons.star_rate_rounded, size: 16),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            trailing: index == 0 ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: const Wrap(
                                spacing: 5,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    'Terfavorit',
                                    style: TextStyle(
                                      color: Colors.white
                                    ),
                                  ),
                                  Icon(
                                    Icons.emoji_events_outlined,
                                    size: 18,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ) : null,
                          );
                        },
                      );
                    }
                  }
                }

                return const SliverToBoxAdapter();
              },
            ),
            FutureBuilder(
              future: getDataTopToko(context: context),
              builder: (BuildContext context, AsyncSnapshot response){
                if(response.connectionState == ConnectionState.done){
                  if(response.hasData){
                    return SliverToBoxAdapter(
                      child: Visibility(
                        visible: topProductList.isNotEmpty ? true : false,
                        child: SafeArea(
                          top: false,
                          bottom: false,
                          minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Laris Manisss ...',
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    const Text(
                                      'Produk teratas yang paling banyak dibeli sama pelanggan eSPW!',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ),
                      )
                    );
                  }
                }

                return const SliverToBoxAdapter();
              },
            ),
            SliverToBoxAdapter(
              child: FutureBuilder(
                future: getDataTopProduk(context: context),
                builder: (BuildContext context, AsyncSnapshot response){
                  if(response.connectionState == ConnectionState.done){
                    if(response.hasData){
                      if(json.decode(response.data.body)['data'].isNotEmpty){
                        return CarouselSlider(
                          items: _topProduct(),
                          options: CarouselOptions(
                            enableInfiniteScroll: false,
                            disableCenter: true,
                            viewportFraction: .95,
                            height: 200
                          ),
                        );
                      }
                    }
                  }

                  return const SizedBox();
                },
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jelajahi Produk',
                            style: TextStyle(
                              fontSize: 24,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          const Text(
                            'Jelajahi produk yang sedang dipasarkan hari ini!',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300
                            ),
                          ),
                          const Gap(5),
                          ChoiceChip(
                            label: Text('Semua (${productList.length})'),
                            selected: true,
                            onSelected: (bool selected){},
                            showCheckmark: false,
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ),
            ),
            FutureBuilder(
              future: getDataProduk(context: context),
              builder: (BuildContext context, AsyncSnapshot response){
                if(response.connectionState == ConnectionState.done){
                  if(response.hasData){
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
                  }
                } else if (response.connectionState == ConnectionState.waiting){
                  return SliverList.builder(
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index){
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey.withAlpha(100),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      );
                    },
                  );
                }

                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Center(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/image/store-closed.png',
                            width: 250,
                          ),
                          const Gap(10),
                          const Text(
                            'Tidak ada toko yang berjualan hari ini.',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic
                            ),
                          ),
                        ],
                      )
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
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
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white
                      ),
                      child: Wrap(
                        spacing: 5,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(rating.toString(),),
                          Icon(
                            Icons.star_rate_rounded,
                            color: Theme.of(context).primaryColor,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
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
      minimum: const EdgeInsets.only(left: 16, right: 16, bottom: 5),
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
                      child: Wrap(
                        spacing: 2,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(rating.toString()),
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
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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