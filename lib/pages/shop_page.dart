import 'package:cached_network_image/cached_network_image.dart';
import 'package:espw/app/dummy_data.dart';
import 'package:espw/pages/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class ShopPage extends StatefulWidget{
  const ShopPage({super.key, this.shopID});
  final String? shopID;

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage>{
  NumberFormat formatter = NumberFormat("###,###.##", "id_ID");
  int qty = 0;

  late List<Map> shopList;
  late List<Map> productList;
  @override
  void initState() {
    super.initState();
    shopList = shop;
    productList = products;
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

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            foregroundColor: Theme.of(context).primaryColor,
            pinned: true,
            actions: [
              IconButton(
                onPressed: (){
                  PersistentNavBarNavigator.pushNewScreen(context, screen: const CartPage());
                },
                icon: const Icon(Icons.shopping_cart_outlined),
              )
            ],
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: shopList[0]['profile_picture'],
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
                                  '${shopList[0]['name']}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                                _isOpen(productList[0]['is_open'])
                              ],
                            ),
                            Text(
                              shopList[0]['short_description']
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 5,
                              children: [
                                RatingBar(
                                  ignoreGestures: true,
                                  allowHalfRating: true,
                                  initialRating: shopList[0]['rating'],
                                  itemSize: 18,
                                  ratingWidget: RatingWidget(
                                    full: Icon(Icons.star, color: Theme.of(context).primaryColor),
                                    half: Icon(Icons.star_half, color: Theme.of(context).primaryColor),
                                    empty: Icon(Icons.star_outline, color: Theme.of(context).primaryColor)
                                  ),
                                  onRatingUpdate: (rating){},
                                ),
                                Text(
                                  shopList[0]['rating'].toString()
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
                      const Text(
                        'Deskripsi Toko',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      Text(
                        shopList[0]['description']
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
                        'Semua menu (${productList.length})'
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          SliverList.builder(
            itemCount: productList.length,
            itemBuilder: (BuildContext context, int index){
              final product = productList[index];
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
                              imageUrl: product['product_image'],
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
                                        product['product_name'],
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),
                                      Text(
                                        'Terjual ${product['sold_total']}',
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
                                        'Rp. ${formatter.format(product['price'])}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),
                                      OutlinedButton(
                                        onPressed: (){
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context){
                                              return SafeArea(
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
                                                                  imageUrl: productList[0]['product_image'],
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
                                                                            productList[0]['product_name'],
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: const TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w600
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            'Terjual ${productList[0]['sold_total']}',
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
                                                                            'Rp. ${formatter.format(productList[0]['price'])}',
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
                                                                                      backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
                                                                                      padding: const MaterialStatePropertyAll(EdgeInsets.zero),
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
                                                                                      backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
                                                                                      padding: const MaterialStatePropertyAll(EdgeInsets.zero),
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
                                                        child: FilledButton(
                                                          onPressed: (){
                                                            context.pop();
                                                          },
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
                                              );
                                            }
                                          ).whenComplete(() {
                                            setState(() {
                                              qty = 0;
                                            });
                                          });
                                        },
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
      ),
    );
  }
}