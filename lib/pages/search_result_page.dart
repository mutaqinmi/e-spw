import 'package:espw/app/dummy_data.dart';
import 'package:espw/pages/cart_page.dart';
import 'package:espw/pages/shop_result.dart';
import 'package:espw/widgets/product_result.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({super.key, this.searchQuery});
  final String? searchQuery;

  @override
  State<SearchResult> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchResult>{
  late List<Map> productList;
  late List<Map> shopList;
  @override
  void initState() {
    super.initState();
    productList = products;
    shopList = shop;
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
                  side: MaterialStatePropertyAll(BorderSide(
                    color: Color.fromARGB(255, 115, 115, 115),
                  )),
                  backgroundColor: MaterialStatePropertyAll(Colors.white),
                  foregroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 115, 115, 115)),
                  padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 15))
                ),
                onPressed: (){
                  context.pushNamed('search');
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
              IconButton(
                onPressed: (){
                  PersistentNavBarNavigator.pushNewScreen(context, screen: const CartPage(), withNavBar: false);
                },
                icon: const Icon(Icons.shopping_cart_outlined),
              ),
            ],
            bottom: const TabBar(
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
      body: ListView.builder(
        itemCount: productList.length,
        itemBuilder: (BuildContext context, int index){
          final product = productList[index];
          return ProductResult(
            imageURL: product['product_image'],
            shopName: product['shop_name'],
            productName: product['product_name'],
            soldTotal: product['sold_total'],
            price: product['price'],
            rating: product['rating'],
          );
        },
      ),
    );
  }

  Widget _shopResult(){
    return Scaffold(
      body: ListView.builder(
        itemCount: shopList.length,
        itemBuilder: (BuildContext context, int index){
          final shop = shopList[index];
          return ShopResult(
            imageURL: shop['profile_picture'],
            className: shop['class'],
            shopName: shop['name'],
          );
        },
      ),
    );
  }
}