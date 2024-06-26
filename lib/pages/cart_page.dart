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
  int cartCount = 0;
  @override
  void initState() {
    super.initState();
    getDataKeranjang(context: context).then((res) => {
      setState((){
        cartList = json.decode(res!.body)['data'];
        cartCount = cartList.length;
      })
    });
  }

  void _deleteFromCart(BuildContext context, int idKeranjang){
    deleteFromKeranjang(
      context: context,
      idKeranjang: idKeranjang
    ).then((res) => {
      if(res!.statusCode == 200){
        successSnackBar(
          context: context,
          content: 'Produk berhasil dihapus!'
        ),
      }
    });
  }

  void _addQty(int qty, int idKeranjang){
    qty++;
    updateKeranjang(
      context: context,
      idKeranjang: idKeranjang,
      qty: qty
    );
  }

  void _removeQty(int qty, int idKeranjang){
    qty--;
    updateKeranjang(
      context: context,
      idKeranjang: idKeranjang,
      qty: qty
    );
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

  Future<bool?> _confirmDismiss(BuildContext context, String itemName){
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
      totalPrice += int.parse(cartList[i]['produk']['harga']) * cartList[i]['keranjang']['jumlah'];
    }
    return totalPrice;
  }

  WidgetStateProperty<Color> _buttonColor(){
    List item = [];
    for(int i = 0; i < cartList.length; i++){
      item.add(cartList[i]['toko']['is_open']);
    }
    if(cartList.isNotEmpty && item.contains(true)){
      return WidgetStatePropertyAll(Theme.of(context).primaryColor);
    }

    return const WidgetStatePropertyAll(Colors.grey);
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
          cartList.isEmpty ?
          SliverToBoxAdapter(
            child: SafeArea(
              minimum: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/image/cart.png',
                      width: 200,
                    ),
                    const Gap(10),
                    const Text(
                      'Keranjang kamu masih kosong!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(5),
                    const Text(
                      'Jelajahi berbagai macam produk dan tambahkan ke keranjang!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12
                      ),
                    )
                  ],
                ),
              ),
            )
          ) :
          SliverList.builder(
            itemCount: cartList.length + 1,
            itemBuilder: (BuildContext context, int index){
              if(index != cartList.length){
                final item = cartList[index];
                return Dismissible(
                  key: Key(item['keranjang']['id_keranjang'].toString()),
                  dismissThresholds: const {
                    DismissDirection.startToEnd: .9,
                    DismissDirection.endToStart: .9
                  },
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
                  confirmDismiss: (DismissDirection dismissDirection) => _confirmDismiss(context, item['produk']['nama_produk']),
                  onDismissed: (DismissDirection dismissDirection){
                    _deleteFromCart(context, item['keranjang']['id_keranjang']);
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
                              Text(item['toko']['nama_toko']),
                              _isOpen(item['toko']['is_open'])
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: 'https://$apiBaseUrl/public/${item['produk']['foto_produk']}',
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
                                      item['produk']['nama_produk'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      child: Text(
                                        'Catatan: ${item['keranjang']['catatan'] == '' ? '...' : item['keranjang']['catatan']}',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Rp. ${formatter.format(int.parse(item['produk']['harga']))}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: (){
                                                if(item['toko']['is_open']){
                                                  if(item['keranjang']['jumlah'] > 1){
                                                    _removeQty(item['keranjang']['jumlah'], item['keranjang']['id_keranjang']);
                                                    setState(() {
                                                      item['keranjang']['jumlah']--;
                                                    });
                                                  }
                                                }
                                              },
                                              visualDensity: VisualDensity.compact,
                                              style: ButtonStyle(
                                                backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                                                padding: const WidgetStatePropertyAll(EdgeInsets.zero),
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
                                                  item['keranjang']['jumlah'].toString(),
                                                  style: const TextStyle(
                                                    fontSize: 16
                                                  ),
                                                ),
                                              )
                                            ),
                                            IconButton(
                                              onPressed: (){
                                                if(item['toko']['is_open']){
                                                  _addQty(item['keranjang']['jumlah'], item['keranjang']['id_keranjang']);
                                                  setState(() {
                                                    item['keranjang']['jumlah']++;
                                                  });
                                                }
                                              },
                                              visualDensity: VisualDensity.compact,
                                              style: ButtonStyle(
                                                backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                                                padding: const WidgetStatePropertyAll(EdgeInsets.zero),
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
                        ),
                      ],
                    ),
                  )
                );
              }

              return const SafeArea(
                top: false,
                minimum: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Divider(
                      thickness: .25,
                    ),
                    Gap(5),
                    Text(
                      'Swipe untuk menghapus produk dari keranjang',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 12
                      ),
                    )
                  ],
                ),
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
                List item = [];
                for(int i = 0; i < cartList.length; i++){
                  item.add(cartList[i]['toko']['is_open']);
                }
                if(cartList.isNotEmpty && item.contains(true)){
                  context.pushNamed('checkout');
                }
              },
              style: ButtonStyle(
                shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20))
                )),
                backgroundColor: _buttonColor()
              ),
              child: StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)).asyncMap((t) => getDataKeranjang(context: context)),
                builder: (BuildContext context, AsyncSnapshot response){
                  if(response.hasData){
                    return Text('Checkout (${json.decode(response.data.body)['data'].length})');
                  }

                  return const Text('Checkout (0)');
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}