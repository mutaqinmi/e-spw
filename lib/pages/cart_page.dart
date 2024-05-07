import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:espw/widgets/bottom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:espw/app/controllers.dart';

class CartPage extends StatefulWidget{
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>{
  final formatter = NumberFormat('###,###.###', 'id_ID');

  List cartList = [];
  @override
  void initState() {
    super.initState();
    carts().then((res) => {
      setState((){
        cartList = json.decode(res.body)['data'];
      })
    });
  }

  void _deleteFromCart(BuildContext context, int idKeranjang){
    deleteCart(idKeranjang).then((res) => {
      if(res.statusCode == 200){
        successSnackBar(
          context: context,
          content: 'Produk berhasil dihapus!'
        ),
      }
    });
  }

  void _addQty(int qty, int idKeranjang){
    qty++;
    updateCart(idKeranjang, qty);
  }

  void _removeQty(int qty, int idKeranjang){
    qty--;
    updateCart(idKeranjang, qty);
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

  Future<bool?> _confirmDismiss(BuildContext context, int idKeranjang, String itemName){
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
              context.pop(false);
            },
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: (){
              context.pop(true);
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
      totalPrice += cartList[i]['harga'] * cartList[i]['qty'];
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
              'Keranjang',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Swipe untuk menghapus item dari keranjang',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                  Gap(10),
                  Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                    indent: 16,
                    endIndent: 16,
                  )
                ],
              ),
            )
          ),
          SliverList.builder(
            itemCount: cartList.length,
            itemBuilder: (BuildContext context, int index){
              final item = cartList[index];
              return Dismissible(
                key: Key(item['id_keranjang'].toString()),
                background: Container(
                  decoration: const BoxDecoration(
                    color: Colors.red
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.white)
                      ],
                    ),
                  )
                ),
                secondaryBackground: Container(
                  decoration: const BoxDecoration(
                    color: Colors.red
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.delete, color: Colors.white)
                      ],
                    ),
                  )
                ),
                confirmDismiss: (DismissDirection dismissDirection) => _confirmDismiss(context, item['id_keranjang'], item['nama_produk']),
                onDismissed: (DismissDirection dismissDirection){
                  _deleteFromCart(context, item['id_keranjang']);
                  setState(() {
                    cartList.removeAt(index);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Wrap(
                          spacing: 5,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Icon(Icons.storefront),
                            Text(item['nama_toko']),
                            _isOpen(item['is_open'])
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: 'http://$baseUrl/assets/public/${item['foto_produk']}',
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
                                    item['nama_produk'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  // Text(
                                  //   item['extra'].join(', '),
                                  //   overflow: TextOverflow.ellipsis,
                                  // ),
                                  const Gap(40),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Rp. ${formatter.format(item['harga'])}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: (){
                                              if(item['is_open']){
                                                if(item['qty'] > 1){
                                                  _removeQty(item['qty'], item['id_keranjang']);
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
                                              if(item['is_open']){
                                                _addQty(item['qty'], item['id_keranjang']);
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
              onPressed: (){
                context.pushNamed('checkout');
              },
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