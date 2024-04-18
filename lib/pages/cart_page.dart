import 'package:cached_network_image/cached_network_image.dart';
import 'package:espw/app/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget{
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>{
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

  Future<bool?> _confirmDismiss(BuildContext context, int index, String itemName, bool isButton){
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Hapus'),
        content: Text(
          'Apakah anda yakin ingin menghapus $itemName dari keranjang?'
        ),
        actions: [
          TextButton(
            onPressed: (){
              if(isButton){
                context.pop();
              } else {
                context.pop(false);
              }
            },
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: (){
              if(isButton){
                setState(() {
                  cartList.removeAt(index);
                });
                context.pop();
              } else {
                context.pop(true);
              }
            },
            child: const Text('Hapus'),
          )
        ],
      )
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
      appBar: AppBar(
        title: const Text(
          'Keranjang',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: cartList.length,
        itemBuilder: (BuildContext context, int index){
          final item = cartList[index];
          return Dismissible(
            key: Key(item['cartID']),
            background: Container(
              decoration: const BoxDecoration(
                color: Colors.red
              ),
              child: const Center(
                child: Icon(Icons.delete, color: Colors.white),
              ),
            ),
            confirmDismiss: (DismissDirection dismissDirection) => _confirmDismiss(context, index, item['product'][0]['product_name'], false),
            onDismissed: (DismissDirection dismissDirection){
              setState(() {
                cartList.removeAt(index);
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
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
                      IconButton(
                        onPressed: (){_confirmDismiss(context, index, item['product'][0]['product_name'], true);},
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                      )
                    ],
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
                              const Gap(25),
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
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: (){
                                          if(item['qty'] < 1){
                                            _confirmDismiss(context, index, item['product'][0]['product_name'], true);
                                          }

                                          if(item['product'][0]['is_open']){
                                            if(item['qty'] > 0){
                                              setState(() {
                                                item['qty']--;
                                              });
                                            }
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
                                            item['qty'].toString(),
                                            style: const TextStyle(
                                              fontSize: 16
                                            ),
                                          ),
                                        )
                                      ),
                                      IconButton(
                                        onPressed: (){
                                          if(item['product'][0]['is_open']){
                                            setState(() {
                                              item['qty']++;
                                            });
                                          }
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
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      )
                    ],
                  )
                ],
              ),
            )
          );
        },
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
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero
                ))
              ),
              child: const Text('Checkout'),
            ),
          )
        ],
      ),
    );
  }
}