import 'dart:convert';
import 'package:espw/app/controllers.dart';
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
  @override
  void initState() {
    super.initState();
    getAddress().then((res) => setState(() {
      addressList = json.decode(res.body)['data'];
    }));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(),
          const SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              minimum: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alamat',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22
                    ),
                  ),
                  Text(
                    'Alamat yang anda simpan'
                  ),
                  Gap(20)
                ],
              ),
            ),
          ),
          SliverList.builder(
            itemCount: addressList.length,
            itemBuilder: (BuildContext context, int index){
              final shop = addressList[index];
              return GestureDetector(
                onLongPress: () => Clipboard.setData(ClipboardData(text: shop['alamat'])),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: Colors.grey
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          shop['alamat'],
                        ),
                        IconButton(
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
                              deleteAddress(
                                context: context,
                                idAddress: shop['id_alamat']
                              );
                            }
                          },
                          icon: const Icon(Icons.close),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () => context.pushNamed('add-address'),
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
            ),
          )
        ],
      ),
    );
  }
}