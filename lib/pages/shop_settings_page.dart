import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ShopSettingsPage extends StatelessWidget{
  const ShopSettingsPage({super.key, required this.idToko});
  final String idToko;

  @override
  Widget build(BuildContext context){
    final formFieldKey = GlobalKey<FormFieldState>();
    String confirmText = '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengaturan Toko',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            ItemButton(
              itemTitle: const Text('Informasi'),
              onPressed: () => context.pushNamed('search'),
            ),
            ItemButton(
              itemTitle: const Text('Jadwal Operasional'),
              onPressed: () => context.pushNamed('set-schedule', queryParameters: {'id_toko': idToko}),
            ),
            ItemButton(
              itemTitle: const Text('Lokasi'),
              onPressed: () => context.pushNamed('search'),
            ),
            const Divider(
              thickness: 0.25,
            ),
            ItemButton(
              itemTitle: const Text('Keluar Toko'),
              onPressed: () async {
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
                    idToko: idToko
                  );
                }
              },
            ),
            ItemButton(
              itemTitle: const Text(
                'Hapus Toko',
                style: TextStyle(
                  color: Colors.red
                ),
              ),
              onPressed: () async {
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
                            hintText: idToko,
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Isi field terlebih dahulu!';
                            }

                            if(value != idToko){
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
                          if(confirmText == idToko){
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
                  deleteShop(
                    context: context,
                    idToko: idToko
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ItemButton extends StatelessWidget{
  const ItemButton({super.key, required this.itemTitle, this.onPressed});
  final Widget itemTitle;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context){
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onPressed,
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              itemTitle,
              const Icon(Icons.keyboard_arrow_right)
            ],
          ),
        )
      ),
    );
  }
}