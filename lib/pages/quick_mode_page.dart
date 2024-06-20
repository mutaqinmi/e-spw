import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class QuickModePage extends StatefulWidget{
  const QuickModePage({super.key, required this.idToko});
  final String idToko;

  @override
  State<QuickModePage> createState() => _QuickModePageState();
}

class _QuickModePageState extends State<QuickModePage>{
  final NumberFormat formatter = NumberFormat("###,###.##", "id_ID");
  int qty = 0;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quick Mode',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
      body: FutureBuilder(
        future: getTokoByIdToko(context: context, shopId: widget.idToko),
        builder: (BuildContext context, AsyncSnapshot response){
          if(response.connectionState == ConnectionState.done){
            final productList = json.decode(response.data.body)['data'];
            return GridView.builder(
              itemCount: productList.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16
              ),
              itemBuilder: (BuildContext context, int index){
                final product = productList[index]['produk'];
                return GestureDetector(
                  onTap: () => showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context){
                      return Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: SingleChildScrollView(
                          child: SafeArea(
                            minimum: const EdgeInsets.only(left: 16, right: 16, top: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: (){},
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl: 'https://$apiBaseUrl/public/${product['foto_produk']}',
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
                                                        product['nama_produk'],
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600
                                                        ),
                                                      ),
                                                      Text(
                                                        'Terjual ${product['jumlah_terjual']}',
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Gap(30),
                                                  StatefulBuilder(
                                                    builder: (BuildContext context, StateSetter setState){
                                                      return Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Rp. ${formatter.format(double.parse(product['harga']) * qty)}',
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.w600
                                                            ),
                                                          ),
                                                          Row(
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
                                                      );
                                                    },
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
                                    height: 50,
                                    child: FilledButton(
                                      onPressed: () => createPesanan(
                                        context: context,
                                        idProduk: product['id_produk'],
                                        jumlah: qty,
                                        totalHarga: double.parse(product['harga']) * qty,
                                        catatan: 'Ini adalah pesanan dari Quick Mode ${productList.first['toko']['nama_toko']}',
                                        alamat: 'Quick Mode',
                                        idToko: widget.idToko
                                      ).then((res) => {
                                        if(res!.statusCode == 200){
                                          context.pop()
                                        }
                                      }),
                                      child: const Text('Beli Langsung'),
                                    ),
                                  )
                                ),
                              ],
                            )
                          ),
                        ),
                      );
                    }
                  ).whenComplete(() => setState(() {
                    qty = 0;
                  })),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: 'https://$apiBaseUrl/public/${product['foto_produk']}',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
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
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['nama_produk'],
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                                Text(
                                  'Rp. ${formatter.format(int.parse(product['harga']))}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            ),
                          )
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }
}