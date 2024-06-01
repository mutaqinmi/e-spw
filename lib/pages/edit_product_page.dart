import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EditProductPage extends StatefulWidget{
  const EditProductPage({super.key, required this.idProduk});
  final String idProduk;

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage>{
  bool _buttonClicked = false;
  final _namaProdukKey = GlobalKey<FormFieldState>();
  final _hargaKey = GlobalKey<FormFieldState>();
  final _stokKey = GlobalKey<FormFieldState>();
  final _deskripsiProdukKey = GlobalKey<FormFieldState>();
  final _detailProdukKey = GlobalKey<FormFieldState>();
  String _namaProduk = '';
  String _harga = '';
  String _stok = '';
  String _deskripsiProduk = '';
  String _detailProduk = '';

  void _submit(){
    if(_namaProdukKey.currentState!.validate() && _hargaKey.currentState!.validate() && _stokKey.currentState!.validate() && _deskripsiProdukKey.currentState!.validate()){
      _namaProdukKey.currentState!.save();
      _hargaKey.currentState!.save();
      _stokKey.currentState!.save();
      _deskripsiProdukKey.currentState!.save();
      _detailProdukKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Informasi Produk',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          )
        ),
      ),
      body: FutureBuilder(
        future: productById(widget.idProduk),
        builder: (BuildContext context, AsyncSnapshot response){
          if(response.connectionState == ConnectionState.done){
            final produk = json.decode(response.data.body)['data'].first['produk'];
            return SingleChildScrollView(
              child: SafeArea(
                minimum: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: CachedNetworkImageProvider(
                              'https://$baseUrl/assets/public/${produk['foto_produk']}'
                            ),
                          ),
                          const Gap(5),
                          TextButton(
                            onPressed: (){},
                            child: const Text('Ubah Foto Produk'),
                          )
                        ],
                      ),
                    ),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Nama Produk'),
                        const Gap(5),
                        TextFormField(
                          initialValue: produk['nama_produk'],
                          key: _namaProdukKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                            hintText: 'Nama Produk',
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Isi field terlebih dahulu!';
                            }

                            return null;
                          },
                          onSaved: (value) => _namaProduk = value!,
                        ),
                      ],
                    ),
                    const Gap(20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Harga'),
                        const Gap(5),
                        TextFormField(
                          initialValue: produk['harga'],
                          key: _hargaKey,
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                            hintText: 'Harga',
                            prefixText: 'Rp. '
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Isi field terlebih dahulu!';
                            }

                            return null;
                          },
                          onSaved: (value) => _harga = value!,
                        ),
                      ],
                    ),
                    const Gap(20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Stok'),
                        const Gap(5),
                        TextFormField(
                          initialValue: produk['stok'].toString(),
                          key: _stokKey,
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                            hintText: 'Stok',
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Isi field terlebih dahulu!';
                            }

                            return null;
                          },
                          onSaved: (value) => _stok = value!,
                        ),
                      ],
                    ),
                    const Gap(20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Deskripsi Produk'),
                        const Gap(5),
                        TextFormField(
                          initialValue: produk['deskripsi_produk'],
                          key: _deskripsiProdukKey,
                          maxLines: 5,
                          maxLength: 255,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            hintText: 'Deskripsi Produk',
                          ),
                          onSaved: (value) => _deskripsiProduk = value!,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Detail Produk'),
                        const Gap(5),
                        TextFormField(
                          initialValue: produk['detail_produk'],
                          key: _detailProdukKey,
                          maxLines: 5,
                          maxLength: 255,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            hintText: 'Detail Produk',
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Isi field terlebih dahulu!';
                            }

                            return null;
                          },
                          onSaved: (value) => _detailProduk = value!,
                        ),
                      ],
                    ),
                    // const Gap(20),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     const Text('Kelas'),
                    //     const Gap(5),
                    //     Text(
                    //       kelas['kelas'],
                    //       style: const TextStyle(
                    //         fontSize: 16
                    //       ),
                    //     )
                    //   ],
                    // ),
                    // const Gap(20),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     const Text('Deskripsi Toko'),
                    //     const Gap(5),
                    //     TextFormField(
                    //       initialValue: toko['deskripsi_toko'],
                    //       key: _deskripsiTokoKey,
                    //       maxLines: 5,
                    //       maxLength: 255,
                    //       autovalidateMode: AutovalidateMode.onUserInteraction,
                    //       decoration: const InputDecoration(
                    //         border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.all(Radius.circular(10))
                    //         ),
                    //         contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    //         hintText: 'Deskripsi Toko',
                    //       ),
                    //       onSaved: (value) => _deskripsiToko = value!,
                    //     ),
                    //   ],
                    // )
                  ],
                ),
              )
            );
          }

          return const Center(
            child: CircularProgressIndicator()
          );
        }
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: FilledButton(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                )
              ),
            ),
            child: _buttonClicked ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ) : const Text('Ubah Informasi Produk'),
            onPressed: () => _submit(),
          )
        ),
      )
    );
  }
}