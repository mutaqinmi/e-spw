import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShopSettingsPage extends StatelessWidget{
  const ShopSettingsPage({super.key, required this.idToko});
  final String idToko;

  @override
  Widget build(BuildContext context){
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
              onPressed: () => context.pushNamed('search'),
            ),
            ItemButton(
              itemTitle: const Text(
                'Hapus Toko',
                style: TextStyle(
                  color: Colors.red
                ),
              ),
              onPressed: () => context.pushNamed('search'),
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