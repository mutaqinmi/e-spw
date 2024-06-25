import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AddProductPage extends StatefulWidget{
  const AddProductPage({super.key, required this.idToko});
  final String idToko;

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage>{
  final _namaProdukKey = GlobalKey<FormFieldState>();
  final _hargaKey = GlobalKey<FormFieldState>();
  final _stokKey = GlobalKey<FormFieldState>();
  final _deskripsiProdukKey = GlobalKey<FormFieldState>();
  String _namaProduk = '';
  String _harga = '';
  String _stok = '';
  String _deskripsiProduk = '';

  void _submit(){
    if(_namaProdukKey.currentState!.validate() && _hargaKey.currentState!.validate() && _stokKey.currentState!.validate() && _deskripsiProdukKey.currentState!.validate()){
      _namaProdukKey.currentState!.save();
      _hargaKey.currentState!.save();
      _stokKey.currentState!.save();
      _deskripsiProdukKey.currentState!.save();

      context.pushNamed('upload-product-image', queryParameters: {
        'nama_produk': _namaProduk,
        'harga': _harga,
        'stok': _stok,
        'deskripsi_produk': _deskripsiProduk,
        'id_toko': widget.idToko,
        'isRedirect': 'false',
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Produk',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nama Produk',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        const Gap(5),
                        TextFormField(
                          key: _namaProdukKey,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            hintText: 'Nama Produk'
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Masukkan nama produk terlebih dahulu';
                            }
                            return null;
                          },
                          onSaved: (value) => _namaProduk = value!,
                        )
                      ],
                    ),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Harga',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        const Gap(5),
                        TextFormField(
                          key: _hargaKey,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            hintText: 'Harga',
                            prefixText: 'Rp. ',
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Masukkan harga produk terlebih dahulu';
                            }
                            return null;
                          },
                          onSaved: (value) => _harga = value!,
                        )
                      ],
                    ),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Stok',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        const Gap(5),
                        TextFormField(
                          key: _stokKey,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            hintText: 'Stok',
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Masukkan stok produk terlebih dahulu';
                            }
                            return null;
                          },
                          onSaved: (value) => _stok = value!,
                        )
                      ],
                    ),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Deskripsi Produk',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        const Gap(5),
                        TextFormField(
                          key: _deskripsiProdukKey,
                          maxLines: 5,
                          maxLength: 255,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            hintText: 'Deskripsi',
                          ),
                          onSaved: (value) => _deskripsiProduk = value!,
                        )
                      ],
                    ),
                    const Gap(10),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
              child: const Text(
                'Selanjutnya',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () => _submit(),
            ),
          ),
        )
      ),
    );
  }
}