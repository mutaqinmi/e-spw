import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProductPage extends StatefulWidget{
  const ProductPage({super.key, required this.idToko});
  final String idToko;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>{
  final _namaProdukKey = GlobalKey<FormFieldState>();
  final _hargaKey = GlobalKey<FormFieldState>();
  final _stokKey = GlobalKey<FormFieldState>();
  final _deskripsiProdukKey = GlobalKey<FormFieldState>();
  String _namaProduk = '';
  String _harga = '';
  String _stok = '';
  String _deskripsiProduk = '';

  void _editProduk(String idProduk){
    if(_namaProdukKey.currentState!.validate() && _hargaKey.currentState!.validate() && _stokKey.currentState!.validate() && _deskripsiProdukKey.currentState!.validate()){
      _namaProdukKey.currentState!.save();
      _hargaKey.currentState!.save();
      _stokKey.currentState!.save();
      _deskripsiProdukKey.currentState!.save();
      updateProduk(
        context: context,
        idProduk: idProduk,
        namaProduk: _namaProduk,
        harga: _harga,
        stok: _stok,
        deskripsiProduk: _deskripsiProduk,
        idToko: widget.idToko
      );
    }
  }

  void _updateFotoProduk(String idProduk, String oldImage) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    File? file = File(image!.path);
    file = await _cropImage(imageFile: file);
    if(!mounted) return;
    return updateFotoProduk(
      context: context,
      idProduk: idProduk,
      fotoProduk: file!,
      oldImage: oldImage,
      idToko: widget.idToko,
    );
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      cropStyle: CropStyle.circle,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Edit',
          lockAspectRatio: true,
          hideBottomControls: true
        )
      ]
    );
    if(croppedImage == null) return null;
    return File(croppedImage.path);
  }

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
    getTokoByIdToko(context: context, shopId: widget.idToko).then((res) => setState(() {
      shopList = json.decode(res!.body)['data'];
    }));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: FutureBuilder(
        future: getTokoByIdToko(context: context, shopId: widget.idToko),
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
                product.isEmpty ?
                SliverToBoxAdapter(
                  child: Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/image/empty.png',
                          width: 200,
                        ),
                        const Gap(5),
                        const Text(
                          'Produk tidak ditemukan!',
                          style: TextStyle(
                            fontStyle: FontStyle.italic
                          ),
                        ),
                      ],
                    )
                  ),
                ) :
                SliverList.builder(
                  itemCount: product.length + 1,
                  itemBuilder: (BuildContext context, int index){
                    if(index != product.length){
                      final item = product[index];
                      return Dismissible(
                        key: Key(item['id_produk']),
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
                        confirmDismiss: (DismissDirection dismissDirection) => _confirmDismiss(context, item['nama_produk']),
                        onDismissed: (DismissDirection dismissDirection){
                          removeProduct(
                            context: context,
                            idProduk: item['id_produk']
                          );
                          setState(() {
                            item.removeAt[index];
                          });
                        },
                        child: InkWell(
                          onTap: () => showModalBottomSheet(
                            isScrollControlled: true,
                            showDragHandle: true,
                            context: context,
                            builder: (BuildContext context) => SingleChildScrollView(
                              child: Container(
                                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 18),
                                child: Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: GestureDetector(
                                          onTap: () =>_updateFotoProduk(item['id_produk'], item['foto_produk']),
                                          child: CircleAvatar(
                                            radius: 60,
                                            backgroundImage: NetworkImage(
                                              'https://$apiBaseUrl/public/${item['foto_produk']}'
                                            ),
                                            child: Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor.withAlpha(100),
                                                borderRadius: BorderRadius.circular(60),
                                              ),
                                              child: const Icon(Icons.edit_outlined),
                                            ),
                                          ),
                                        )
                                      ),
                                      const Gap(20),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Nama Produk'),
                                          const Gap(5),
                                          TextFormField(
                                            initialValue: item['nama_produk'],
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
                                      const Gap(10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Harga'),
                                          const Gap(5),
                                          TextFormField(
                                            initialValue: item['harga'],
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
                                      const Gap(10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Stok'),
                                          const Gap(5),
                                          TextFormField(
                                            initialValue: item['stok'].toString(),
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
                                      const Gap(10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Deskripsi Produk'),
                                          const Gap(5),
                                          TextFormField(
                                            initialValue: item['deskripsi_produk'],
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
                                          const Gap(10),
                                          SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: FilledButton(
                                              onPressed: () => _editProduk(item['id_produk']),
                                              child: const Text('Ubah Produk'),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ),
                            )
                          ),
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
                                        width: 75,
                                        height: 75,
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
                                          const Gap(15),
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
                            'Swipe untuk menghapus produk',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 12
                            ),
                          )
                        ],
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