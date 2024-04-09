import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

// This is a dummy data that simulate API
import 'package:espw/app/dummy_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  bool _isOpen = false;

  bool _isUnder5K = false;
  bool _isUnder10K = false;
  bool _isAbove10K = false;
  bool _highestRating = false;
  bool _lowestRating = false;
  bool _isFood = false;
  bool _isDrink = false;
  bool _isOther = false;

  late List<Map> shopList;
  late List<Map> productList;
  @override
  void initState() {
    super.initState();
    shopList = shop;
    productList = products;
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            surfaceTintColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
            ),
            shadowColor: Colors.grey.withAlpha(50),
            pinned: true,
            expandedHeight: 240,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: _bannerList(context),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: AppBar(
                surfaceTintColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
                ),
                toolbarHeight: 55,
                title: SizedBox(
                  child: FilledButton(
                    style: const ButtonStyle(
                      side: MaterialStatePropertyAll(BorderSide(
                        color: Color.fromARGB(255, 155, 155, 155),
                        width: 0.5
                      )),
                      backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 240, 240, 240)),
                      foregroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 155, 155, 155)),
                      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 15))
                    ),
                    onPressed: (){
                      context.pushNamed('search');
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.search),
                        Gap(10),
                        Text('Telusuri produk atau toko ...')
                      ],
                    ),
                  ),
                ),
                actions: const [
                  ProfilePicture(
                    imageURL: 'https://images.unsplash.com/photo-1531891437562-4301cf35b7e4?q=80&w=1364&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              bottom: false,
              minimum: const EdgeInsets.symmetric(horizontal: 16),
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
                      Wrap(
                        spacing: 5,
                        children: [
                          const ChoiceChip(
                            label: Text('Semua Toko'),
                            selected: true,
                          ),
                          ChoiceChip(
                            label: const Text('Toko yang Buka'),
                            selected: _isOpen,
                            onSelected: (bool selected){
                              setState(() {
                                _isOpen = !_isOpen;
                              });
                            },
                          )
                        ],
                      )
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
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: shopList.length,
                itemBuilder: (BuildContext context, int index){
                  final shop = shopList[index];
                  return ShopCard(
                    imageURL: shop['profile_picture'],
                    className: shop['class'],
                    shopName: shop['name'],
                    rating: shop['rating'],
                    onTap: (){
                      context.pushNamed('shop');
                    },
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
                  ElevatedButton(
                    onPressed: (){
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context){
                          return SingleChildScrollView(
                            child: SafeArea(
                              minimum: const EdgeInsets.all(16),
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Filter',
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    const Gap(20),
                                    const Text(
                                      'Harga',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setState){
                                        return Wrap(
                                          spacing: 5,
                                          children: [
                                            ChoiceChip(
                                              label: const Text('Dibawah 5K'),
                                              selected: _isUnder5K,
                                              onSelected: (bool selected){
                                                setState(() {
                                                  _isUnder5K = !_isUnder5K;
                                                });
                                              },
                                            ),
                                            ChoiceChip(
                                              label: const Text('Dibawah 10K'),
                                              selected: _isUnder10K,
                                              onSelected: (bool selected){
                                                setState(() {
                                                  _isUnder10K = !_isUnder10K;
                                                });
                                              },
                                            ),
                                            ChoiceChip(
                                              label: const Text('Diatas 10K'),
                                              selected: _isAbove10K,
                                              onSelected: (bool selected){
                                                setState(() {
                                                  _isAbove10K = !_isAbove10K;
                                                });
                                              },
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                    const Gap(15),
                                    const Text(
                                      'Rating',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setState){
                                        return Wrap(
                                          spacing: 5,
                                          children: [
                                            ChoiceChip(
                                              label: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text('Diatas 4.0'),
                                                  Gap(5),
                                                  Icon(Icons.star_half)
                                                ],
                                              ),
                                              selected: _lowestRating,
                                              onSelected: (bool selected){
                                                setState(() {
                                                  _lowestRating = !_lowestRating;
                                                });
                                              },
                                            ),
                                            ChoiceChip(
                                              label: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text('Diatas 4.5'),
                                                  Gap(5),
                                                  Icon(Icons.star)
                                                ],
                                              ),
                                              selected: _highestRating,
                                              onSelected: (bool selected){
                                                setState(() {
                                                  _highestRating = !_highestRating;
                                                });
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    const Gap(15),
                                    const Text(
                                      'Jenis',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setState){
                                        return Wrap(
                                          spacing: 5,
                                          children: [
                                            ChoiceChip(
                                              label: const Text('Makanan'),
                                              selected: _isFood,
                                              onSelected: (bool selected){
                                                setState(() {
                                                  _isFood = !_isFood;
                                                });
                                              },
                                            ),
                                            ChoiceChip(
                                              label: const Text('Minuman'),
                                              selected: _isDrink,
                                              onSelected: (bool selected){
                                                setState(() {
                                                  _isDrink = !_isDrink;
                                                });
                                              },
                                            ),
                                            ChoiceChip(
                                              label: const Text('Lainnya'),
                                              selected: _isOther,
                                              onSelected: (bool selected){
                                                setState(() {
                                                  _isOther = !_isOther;
                                                });
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      );
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.tune),
                        Gap(10),
                        Text('Filter')
                      ],
                    ),
                  )
                ],
              )
            ),
          ),
          SliverList.builder(
            itemCount: productList.length,
            itemBuilder: (BuildContext context, int index){
              final product = productList[index];
              return ProductCard(
                imageURL: product['product_image'],
                productName: product['product_name'],
                description: product['product_description'],
                soldTotal: product['sold_total'],
                price: product['price'],
                rating: product['rating'],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProfilePicture extends StatelessWidget{
  const ProfilePicture({super.key, required this.imageURL, this.onTap});
  final String imageURL;
  final void Function()? onTap;

  Widget _isContainProfilePicture(){
    if(imageURL.isNotEmpty){
      return CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(imageURL),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset('assets/image/profile.png', width: 40, height: 40, fit: BoxFit.cover),
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: onTap,
        child: _isContainProfilePicture(),
      ),
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
        elevation: 4,
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
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
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
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          Text(
                            description,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
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
                    )
                  ],
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}