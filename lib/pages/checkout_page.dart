import 'package:espw/app/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CheckoutPage extends StatefulWidget{
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage>{
  final formatter = NumberFormat('###,###.###', 'id_ID');

  late List<Map> cartList;
  @override
  void initState() {
    super.initState();
    cartList = carts;
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
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
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
        spacing: 5,
        crossAxisAlignment: WrapCrossAlignment.center,
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

  double _totalPrice(){
    double totalPrice = 0.0;
    for(int i = 0; i < cartList.length; i++){
      totalPrice += cartList[i]['product'][0]['price'] * cartList[i]['qty'];
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            title: Text(
              'Checkout',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              minimum: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                surfaceTintColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  side: BorderSide(
                    color: Colors.grey,
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined),
                      const Gap(10),
                      const Expanded(
                        child: Text(
                          'Lab. RPL, Gedung Teknologi Informasi lt.2, SMK Negeri 2 Tasikmalaya',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: (){},
                        icon: const Icon(Icons.edit_outlined),
                      )
                    ],
                  ),
                )
              ),
            )
          ),
          SliverList.builder(
            itemCount: cartList.length,
            itemBuilder: (BuildContext context, int index){
              final item = cartList[index];
              return SafeArea(
                top: false,
                minimum: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            spacing: 5,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Icon(Icons.storefront),
                              Text(item['product'][0]['shop_name']),
                              _isOpen(item['product'][0]['is_open'])
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: item['product'][0]['product_image'],
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  item['product'][0]['product_name'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                                Text(
                                  item['extra'].join(', '),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'x${item['qty']}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Gap(10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Rp. ${formatter.format(item['product'][0]['price'])}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
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
                      ),
                    )
                  ],
                ),
              );
            }
          )
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 12
                    ),
                  ),
                  Text(
                    'Rp. ${formatter.format(_totalPrice())}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 65,
            child: FilledButton(
              onPressed: (){},
              style: const ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero
                ))
              ),
              child: const Text('Pesan'),
            ),
          )
        ],
      ),
    );
  }
}