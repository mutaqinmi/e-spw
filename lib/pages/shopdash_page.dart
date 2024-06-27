import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ShopDashPage extends StatefulWidget{
  const ShopDashPage({super.key, required this.idToko});
  final String idToko;

  @override
  State<ShopDashPage> createState() => _ShopDashPageState();
}

class _ShopDashPageState extends State<ShopDashPage>{
  final formFieldKey = GlobalKey<FormFieldState>();
  final _deskripsiTokoKey = GlobalKey<FormFieldState>();
  String confirmText = '';
  String _deskripsiToko = '';
  bool isOpen = false;
  @override
  void initState() {
    super.initState();
    getTokoByIdToko(context: context, shopId: widget.idToko).then((res) => setState(() {
      isOpen = json.decode(res!.body)['data'].first['toko']['is_open'];
    }));
  }

  void _updateDeskripsiToko(){
    _deskripsiTokoKey.currentState!.save();
    updateDeskripsiToko(
      context: context,
      deskripsiToko: _deskripsiToko,
      idToko: widget.idToko
    );
    context.pop();
  }

  void _updateJadwalToko(){
    setState(() {
      isOpen = !isOpen;
    });
    updateJadwalToko(
      context: context,
      idToko: widget.idToko,
      isOpen: isOpen
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
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,
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
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 5,
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

  void _getImage(String oldImage) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    File? file = File(image!.path);
    file = await _cropImage(imageFile: file);
    if(!mounted) return;
    return updateFotoProfilToko(
      context: context,
      bannerToko: file!,
      idToko: widget.idToko,
      oldImage: oldImage
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

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: FutureBuilder(
        future: getTokoByIdToko(context: context, shopId: widget.idToko),
        builder: (BuildContext context, AsyncSnapshot response){
          if(response.hasData){
            if(json.decode(response.data.body)['data'].isNotEmpty){
              final shop = json.decode(response.data.body)['data'];
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    foregroundColor: Theme.of(context).primaryColor,
                    expandedHeight: 120,
                    flexibleSpace: FlexibleSpaceBar(
                      background: CachedNetworkImage(
                        imageUrl: 'https://$apiBaseUrl/public/${shop.first['toko']['foto_profil']}',
                        width: double.infinity,
                        fit: BoxFit.cover
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () => _getImage(shop.first['toko']['foto_profil']),
                        icon: const Icon(Icons.edit_outlined),
                      )
                    ],
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(20),
                      child: Container(
                        width: double.infinity,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                        ),
                      )
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SafeArea(
                      top: false,
                      minimum: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  shop.first['kelas']['kelas'],
                                ),
                                Wrap(
                                  spacing: 5,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      shop.first['toko']['nama_toko'],
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    _isOpen(isOpen)
                                  ],
                                ),
                                Wrap(
                                  spacing: 10,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      shop.first['toko']['deskripsi_toko'],
                                    ),
                                    GestureDetector(
                                      onTap: () => showModalBottomSheet(
                                        showDragHandle: true,
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (BuildContext context) => SingleChildScrollView(
                                          child: Padding(
                                            padding: MediaQuery.of(context).viewInsets,
                                            child: Container(
                                              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 18),
                                              child: Column(
                                                children: [
                                                  TextFormField(
                                                    initialValue: shop.first['toko']['deskripsi_toko'],
                                                    key: _deskripsiTokoKey,
                                                    maxLines: 5,
                                                    maxLength: 255,
                                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                                    decoration: const InputDecoration(
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                                      ),
                                                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                                      hintText: 'Deskripsi Toko',
                                                    ),
                                                    onSaved: (value) => _deskripsiToko = value!,
                                                  ),
                                                  const Gap(10),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    height: 50,
                                                    child: FilledButton(
                                                      onPressed: () => _updateDeskripsiToko(),
                                                      child: const Text('Ubah Deskripsi'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        )
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        size: 16,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => context.pushNamed('shop', queryParameters: {'shopID': shop.first['toko']['id_toko']}),
                            icon: const Icon(Icons.storefront_outlined),
                          ),
                        ],
                      ),
                    )
                  ),
                  SliverToBoxAdapter(
                    child: SafeArea(
                      minimum: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () => context.pushNamed('order-status', queryParameters: {'id_toko': widget.idToko, 'initial_index': '2'}),
                                child: const Card(
                                  elevation: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Penjualan'
                                      ),
                                      Icon(Icons.keyboard_arrow_right)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          const Gap(10),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  style: const ButtonStyle(
                                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero
                                    )),
                                    foregroundColor: WidgetStatePropertyAll(Colors.black),
                                    padding: WidgetStatePropertyAll(EdgeInsets.zero),
                                    overlayColor: WidgetStatePropertyAll(Colors.transparent)
                                  ),
                                  onPressed: () => context.pushNamed('order-status', queryParameters: {'id_toko': widget.idToko, 'initial_index': '0'}),
                                  child: Column(
                                    children: [
                                      StreamBuilder(
                                        stream: Stream.periodic(const Duration(seconds: 1)).asyncMap((t) => getAllPesananByToko(context: context, idToko: widget.idToko)),
                                        builder: (BuildContext context, AsyncSnapshot response){
                                          if(response.hasData){
                                            final order = json.decode(response.data.body)['data'];
                                            final orderList = [];
                                            for(int i = 0; i < order.length; i++){
                                              if(order[i]['transaksi']['status'] == 'Menunggu Konfirmasi'){
                                                orderList.add(order[i]);
                                              }
                                            }

                                            return Badge(
                                              isLabelVisible: orderList.isNotEmpty ? true : false,
                                              label: Text(orderList.length.toString()),
                                              child: Icon(
                                                Icons.upcoming_outlined,
                                                color: Theme.of(context).primaryColor,
                                                size: 35,
                                              ),
                                            );
                                          }

                                          return Badge(
                                            isLabelVisible: false,
                                            child: Icon(
                                              Icons.upcoming_outlined,
                                              color: Theme.of(context).primaryColor,
                                              size: 35,
                                            ),
                                          );
                                        },
                                      ),
                                      const Gap(10),
                                      const Text('Pesanan baru')
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  style: const ButtonStyle(
                                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero
                                    )),
                                    foregroundColor: WidgetStatePropertyAll(Colors.black),
                                    padding: WidgetStatePropertyAll(EdgeInsets.zero),
                                    overlayColor: WidgetStatePropertyAll(Colors.transparent)
                                  ),
                                  onPressed: () => context.pushNamed('order-status', queryParameters: {'id_toko': widget.idToko, 'initial_index': '1'}),
                                  child: Column(
                                    children: [
                                      StreamBuilder(
                                        stream: Stream.periodic(const Duration(seconds: 1)).asyncMap((t) => getAllPesananByToko(context: context, idToko: widget.idToko)),
                                        builder: (BuildContext context, AsyncSnapshot response){
                                          if(response.hasData){
                                            final order = json.decode(response.data.body)['data'];
                                            final orderList = [];
                                            for(int i = 0; i < order.length; i++){
                                              if(order[i]['transaksi']['status'] != 'Menunggu Konfirmasi' && order[i]['transaksi']['status'] != 'Selesai'){
                                                orderList.add(order[i]);
                                              }
                                            }

                                            return Badge(
                                              isLabelVisible: orderList.isNotEmpty ? true : false,
                                              label: Text(orderList.length.toString()),
                                              child: Icon(
                                                Icons.event_repeat_outlined,
                                                color: Theme.of(context).primaryColor,
                                                size: 35,
                                              ),
                                            );
                                          }

                                          return Badge(
                                            isLabelVisible: false,
                                            child: Icon(
                                              Icons.event_repeat_outlined,
                                              color: Theme.of(context).primaryColor,
                                              size: 35,
                                            ),
                                          );
                                        },
                                      ),
                                      const Gap(10),
                                      const Text('Diproses')
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(10),
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => context.pushNamed('quick-mode', queryParameters: {'id_toko': widget.idToko}),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 10,
                                      children: [
                                        Icon(
                                          Icons.storefront_outlined,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        const Text(
                                          'Quick Mode',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.keyboard_arrow_right)
                                  ],
                                ),
                              ),
                            )
                          ),
                        ],
                      ),
                    )
                  ),
                  SliverToBoxAdapter(
                    child: SafeArea(
                      minimum: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Card(
                            elevation: 0,
                            child: Text(
                              'Produk'
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => context.pushNamed('product', queryParameters: {'id_toko': shop.first['toko']['id_toko']}),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 10,
                                      children: [
                                        Icon(
                                          Icons.inventory_2_outlined,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Daftar Produk',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500
                                              ),
                                            ),
                                            Text(
                                              '${shop.length} Produk'
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.keyboard_arrow_right)
                                  ],
                                ),
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SafeArea(
                      minimum: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Card(
                            elevation: 0,
                            child: Text(
                              'Penilaian'
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => context.pushNamed('shop-rate', queryParameters: {'id_toko': widget.idToko}),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 10,
                                      children: [
                                        Icon(
                                          Icons.star_outline_rounded,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        const Text(
                                          'Ulasan',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.keyboard_arrow_right)
                                  ],
                                ),
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SafeArea(
                      minimum: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Card(
                            elevation: 0,
                            child: Text(
                              'Toko'
                            ),
                          ),
                          const Gap(5),
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => _updateJadwalToko(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0),
                              child: Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 10,
                                      children: [
                                        Icon(
                                          Icons.schedule,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        const Text(
                                          'Buka Sekarang',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Switch(
                                      value: isOpen,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      onChanged: (value) => _updateJadwalToko(),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ),
                          const Gap(5),
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => context.pushNamed('unique-code', queryParameters: {'id_toko': widget.idToko}),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 10,
                                      children: [
                                        Icon(
                                          Icons.pin_outlined,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        const Text(
                                          'Kode Unik',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.keyboard_arrow_right)
                                  ],
                                ),
                              ),
                            )
                          ),
                          const Gap(5),
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => context.pushNamed('member', queryParameters: {'id_toko': widget.idToko}),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 10,
                                      children: [
                                        Icon(
                                          Icons.group_outlined,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        const Text(
                                          'Anggota Kelompok',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.keyboard_arrow_right)
                                  ],
                                ),
                              ),
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SafeArea(
                      minimum: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Card(
                            elevation: 0,
                            child: Text(
                              'Lainnya'
                            ),
                          ),
                          const Gap(5),
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () async {
                              final bool? confirm = await showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  content: const Text('Apakah anda yakin ingin keluar?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => context.pop(false),
                                      child: const Text('Batal'),
                                    ),
                                    FilledButton(
                                      onPressed: () => context.pop(true),
                                      child: const Text('Keluar'),
                                    )
                                  ],
                                )
                              );

                              if(!context.mounted) return;
                              if(confirm!){
                                removeFromKelompok(
                                  context: context,
                                  idToko: widget.idToko
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 10,
                                      children: [
                                        Icon(
                                          Icons.logout,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        const Text(
                                          'Keluar Toko',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.keyboard_arrow_right)
                                  ],
                                ),
                              ),
                            )
                          ),
                          const Gap(5),
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () async {
                              final bool? confirm = await showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Hapus toko?'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Konfirmasi dengan mengetik kata dibawah ini.'),
                                      const Gap(10),
                                      TextFormField(
                                        key: formFieldKey,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        autofocus: true,
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                                          hintText: widget.idToko,
                                        ),
                                        validator: (value){
                                          if(value!.isEmpty){
                                            return 'Isi field terlebih dahulu!';
                                          }

                                          if(value != widget.idToko){
                                            return 'Kata tidak sesuai';
                                          }

                                          return null;
                                        },
                                        onChanged: (value){
                                          confirmText = value;
                                        },
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => context.pop(false),
                                      child: const Text('Batal'),
                                    ),
                                    FilledButton(
                                      onPressed: (){
                                        if(confirmText == widget.idToko){
                                          context.pop(true);
                                        }
                                      },
                                      child: const Text('Hapus'),
                                    )
                                  ],
                                )
                              );

                              if(!context.mounted) return;
                              if(confirm!){
                                deleteToko(
                                  context: context,
                                  idToko: widget.idToko
                                );
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 10,
                                      children: [
                                        Icon(
                                          Icons.delete_forever_outlined,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          'Hapus Toko',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.red
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Colors.red,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/image/empty.png',
                    width: 200,
                  ),
                  const Gap(10),
                  const Text(
                    'Toko anda belum memiliki produk',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  const Text('Tambahkan produk untuk memulai'),
                  const Gap(20),
                  FilledButton(
                    onPressed: () => context.pushNamed('add-product', queryParameters: {'id_toko': widget.idToko}),
                    child: const Text('Tambahkan Produk'),
                  )
                ],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}