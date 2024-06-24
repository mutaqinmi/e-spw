import 'dart:convert';
import 'package:espw/app/controllers.dart';
import 'package:espw/widgets/bottom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ListAddressPage extends StatefulWidget {
  const ListAddressPage({super.key});

  @override
  State<ListAddressPage> createState() => _ListAddressPageState();
}

class _ListAddressPageState extends State<ListAddressPage>{
  List addressList = [];
  List defaultAddress = [];
  @override
  void initState() {
    super.initState();
    getAlamat(context: context).then((res) => setState(() {
      addressList = json.decode(res!.body)['data'];
    }));
    getAlamatDefault(context: context).then((res) => setState(() {
      defaultAddress = json.decode(res!.body)['data'];
    }));
  }

  void _setDefault(int idAlamat){
    setAlamatDefault(context: context, idAlamat: idAlamat).then((res) => setState(() {
      defaultAddress = json.decode(res!.body)['data'];
      successSnackBar(
        context: context,
        content: 'Alamat default berhasil diubah'
      );
    }));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text(
              'Alamat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          SliverList.builder(
            itemCount: addressList.length,
            itemBuilder: (BuildContext context, int index){
              final alamat = addressList[index];
              return GestureDetector(
                onLongPress: () => Clipboard.setData(ClipboardData(text: alamat['alamat'])),
                onTap: () => _setDefault(alamat['id_alamat']),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: alamat['id_alamat'] == defaultAddress.first['id_alamat'] ? Theme.of(context).primaryColor : Colors.grey
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))
                  ),
                  color: alamat['id_alamat'] == defaultAddress.first['id_alamat'] ? Theme.of(context).primaryColor.withAlpha(25) : Colors.white,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: alamat['id_alamat'] == defaultAddress.first['id_alamat'] ? true : false,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(15)
                            ),
                            child: const Wrap(
                              spacing: 5,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  'Default',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12
                                  ),
                                ),
                                Icon(
                                  Icons.check_circle_outline,
                                  size: 14,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                        Text(
                          alamat['alamat'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const Gap(20),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () async {
                                  final bool? confirm = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      content: const Text('Apakah anda ingin menghapus alamat ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => context.pop(false),
                                          child: const Text('Batal'),
                                        ),
                                        FilledButton(
                                          onPressed: () => context.pop(true),
                                          child: const Text('Hapus'),
                                        )
                                      ],
                                    )
                                  );

                                  if(!context.mounted) return;
                                  if(confirm!){
                                    deleteAlamat(
                                      context: context,
                                      idAlamat: alamat['id_alamat']
                                    );
                                  }
                                },
                                child: const Text('Hapus Alamat'),
                              ),
                            ),
                            const Gap(5),
                            Expanded(
                              child: FilledButton(
                                onPressed: () => context.pushNamed('edit-address', queryParameters: {'id_alamat': alamat['id_alamat'].toString()}),
                                child: const Text('Edit Alamat'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('add-address'),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Alamat'),
      ),
    );
  }
}