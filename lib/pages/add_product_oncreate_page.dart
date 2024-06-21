import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AddProductOnCreatePage extends StatefulWidget{
  const AddProductOnCreatePage({super.key, required this.idToko});
  final String idToko;

  @override
  State<AddProductOnCreatePage> createState() => _AddProductOnCreatePageState();
}

class _AddProductOnCreatePageState extends State<AddProductOnCreatePage>{
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

      context.pushNamed('upload-product-image-oncreate', queryParameters: {
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).primaryColor
                          ),
                          child: const Center(
                            child: Text(
                              '1',
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 75,
                          child: Divider(
                            thickness: 3,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).primaryColor
                          ),
                          child: const Center(
                            child: Text(
                              '2',
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 75,
                          child: Divider(
                            thickness: 3,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).primaryColor
                          ),
                          child: const Center(
                            child: Text(
                              '3',
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 75,
                          child: Divider(
                            thickness: 3,
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey
                          ),
                          child: const Center(
                            child: Text(
                              '4',
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Center(
                            child: Text(
                              'Buat Toko',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 45,
                          child: Divider(
                            thickness: 0,
                            color: Colors.transparent,
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Center(
                            child: Text(
                              'Foto Profil',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 45,
                          child: Divider(
                            thickness: 0,
                            color: Colors.transparent,
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Center(
                            child: Text(
                              'Tambah Produk',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 45,
                          child: Divider(
                            thickness: 0,
                            color: Colors.transparent,
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Center(
                            child: Text(
                              'Foto Produk',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tambah Produk',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Text(
                    'Isi informasi produk anda.',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  )
                ],
              ),
              const Gap(20),
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
                          'Deskripsi Produk (Opsional)',
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