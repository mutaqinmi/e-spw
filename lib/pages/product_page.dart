import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProductPage extends StatefulWidget{
  const ProductPage({super.key, required this.idToko});
  final String idToko;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>{
  final NumberFormat formatter = NumberFormat('###,###.###', 'id_ID');
  Future<bool?> _confirmDismiss(BuildContext context, String itemName){
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Hapus'),
        content: Text(
          'Apakah anda yakin ingin menghapus $itemName?'
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

  List shopList = [];
  @override
  void initState() {
    super.initState();
    shopById(widget.idToko).then((res) => setState(() {
      shopList = json.decode(res.body)['data'];
    }));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: FutureBuilder(
        future: shopById(widget.idToko),
        builder: (BuildContext context, AsyncSnapshot response){
          if(response.hasData && response.connectionState == ConnectionState.done){
            List product = [];
            for(int i = 0; i < shopList.length; i++){
              product.add(shopList[i]['produk']);
            }
            return CustomScrollView(
              slivers: [
                const SliverAppBar(
                  pinned: true,
                  title: Text(
                    'Produk',
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
                          'Swipe untuk mengatur produk',
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
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    child: Wrap(
                      spacing: 5,
                      children: [
                        ChoiceChip(
                          label: Text('Semua (${product.length})'),
                          selected: true,
                          onSelected: (bool selected){},
                        )
                      ],
                    )
                  ),
                ),
                product.isEmpty ?
                const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text('Produk tidak ditemukan!'),
                    ),
                  ),
                ) :
                SliverList.builder(
                  itemCount: product.length,
                  itemBuilder: (BuildContext context, int index){
                    final item = product[index];
                    return Dismissible(
                      key: Key(item['id_produk']),
                      dismissThresholds: const {
                        DismissDirection.startToEnd: .9,
                        DismissDirection.endToStart: .9
                      },
                      background: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Colors.white)
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
                      confirmDismiss: (DismissDirection dismissDirection){
                        if(dismissDirection == DismissDirection.endToStart){
                          return _confirmDismiss(context, item['nama_produk']);
                        } else if (dismissDirection == DismissDirection.startToEnd){
                          return context.pushNamed('edit-product', queryParameters: {'id_produk': item['id_produk'], 'id_toko': widget.idToko});
                        }

                        return Future.value(false);
                      },
                      onDismissed: (DismissDirection dismissDirection){
                        if(dismissDirection == DismissDirection.endToStart){
                          removeProduct(
                            context: context,
                            idProduk: item['id_produk']
                          );
                          setState(() {
                            item.removeAt[index];
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            const Gap(10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: 'https://$apiBaseUrl/public/${item['foto_produk']}',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const Gap(10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['nama_produk'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),
                                      Text(
                                        'Rp. ${formatter.format(int.parse(item['harga']))}',
                                      ),
                                      const Gap(35),
                                      Text(
                                        'Stok: ${item['stok']}'
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const Gap(10),
                          ],
                        )
                      ),
                    );
                  },
                )
              ],
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('add-product', queryParameters: {'id_toko': widget.idToko}),
        icon: const Icon(Icons.add),
        label: const Text('Tambah produk'),
      ),
    );
  }
}