import 'dart:convert';
import 'package:espw/app/controllers.dart';
import 'package:espw/widgets/authenticator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CheckoutPage extends StatefulWidget{
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage>{
  final formatter = NumberFormat('###,###.###', 'id_ID');

  List cartList = [];
  List addressList = [];
  List defaultAddress = [];
  @override
  void initState() {
    super.initState();
    getDataKeranjang(context: context).then((res) => setState((){
      cartList = json.decode(res!.body)['data'];
    }));
    getAlamatDefault(context: context).then((res) => setState(() {
      defaultAddress = json.decode(res!.body)['data'];
    }));
    getAlamat(context: context).then((res) => setState(() {
      addressList = json.decode(res!.body)['data'];
    }));
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
      totalPrice += int.parse(cartList[i]['produk']['harga']) * cartList[i]['keranjang']['jumlah'];
    }
    return totalPrice;
  }

  void _submit(){
    if(defaultAddress.isNotEmpty){
      authenticator(context: context).then((res) {
        if(res!){
          for(int i = 0; i < cartList.length; i++){
            double totalHarga = 0.0;
            totalHarga += int.parse(cartList[i]['produk']['harga']) * cartList[i]['keranjang']['jumlah'];
            createPesanan(
              context: context,
              idProduk: cartList[i]['produk']['id_produk'],
              jumlah: cartList[i]['keranjang']['jumlah'],
              totalHarga: totalHarga,
              catatan: cartList[i]['keranjang']['catatan'],
              alamat: defaultAddress.first['alamat'],
              idToko: cartList[i]['toko']['id_toko']
            );
            context.goNamed('order-created');
          }
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) => const AlertDialog(
              content: Text('Password salah!'),
            )
          );
        }
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: const Text('Anda belum mengatur alamat anda'),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('OK'),
            )
          ],
        )
      );
    }
  }

  void _setDefault(int idAlamat){
    setAlamatDefault(context: context, idAlamat: idAlamat).then((res) => setState(() {
      defaultAddress = json.decode(res!.body)['data'];
      context.pop();
    }));
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
                      Expanded(
                        child: defaultAddress.isNotEmpty ? Text(
                          defaultAddress.first['alamat'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ) : const Text(
                          'Anda belum mengatur alamat',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      ),
                      IconButton(
                        onPressed: () => showModalBottomSheet(
                          isScrollControlled: true,
                          showDragHandle: true,
                          context: context,
                          builder: (BuildContext context) => Container(
                            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                            height: MediaQuery.of(context).size.height / 2,
                            child: ListView.builder(
                              itemCount: addressList.length + 1,
                              itemBuilder: (BuildContext context, int index){
                                if(index != addressList.length){
                                  final address = addressList[index];
                                  return GestureDetector(
                                    onLongPress: () => Clipboard.setData(ClipboardData(text: address['alamat'])),
                                    onTap: () => _setDefault(address['id_alamat']),
                                    child: Card(
                                      margin: const EdgeInsets.symmetric(vertical: 5),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1,
                                          color: address['id_alamat'] == defaultAddress.first['id_alamat'] ? Theme.of(context).primaryColor : Colors.grey
                                        ),
                                        borderRadius: const BorderRadius.all(Radius.circular(10))
                                      ),
                                      color: address['id_alamat'] == defaultAddress.first['id_alamat'] ? Theme.of(context).primaryColor.withAlpha(25) : Colors.white,
                                      elevation: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        child: Text(
                                          address['alamat'],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                return GestureDetector(
                                  onTap: () => context.pushNamed('add-address'),
                                  child: Card(
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      child: Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        alignment: WrapAlignment.center,
                                        spacing: 5,
                                        children: [
                                          Icon(Icons.add, color: Theme.of(context).primaryColor),
                                          Text(
                                            'Tambahkan Alamat',
                                            style: TextStyle(
                                              color: Theme.of(context).primaryColor
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
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
                              Text(item['toko']['nama_toko']),
                              _isOpen(item['toko']['is_open'])
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
                                  height: 35,
                                  child: Text(
                                    'Catatan: ${item['keranjang']['catatan'] == '' ? '...' : item['keranjang']['catatan']}',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  'x${item['keranjang']['jumlah']}',
                                  overflow: TextOverflow.ellipsis,
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
              onPressed: () => _submit(),
              style: ButtonStyle(
                shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20))
                )),
                backgroundColor: defaultAddress.isNotEmpty ? WidgetStatePropertyAll(Theme.of(context).primaryColor) : const WidgetStatePropertyAll(Colors.grey)
              ),
              child: const Text('Pesan Sekarang'),
            ),
          )
        ],
      ),
    );
  }
}