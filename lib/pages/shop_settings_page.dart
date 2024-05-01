import 'package:flutter/material.dart';

class ShopSettingsPage extends StatelessWidget{
  const ShopSettingsPage({super.key});

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
      body: const SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            ItemButton(
              itemTitle: 'Informasi',
            ),
            ItemButton(
              itemTitle: 'Banner',
            ),
            ItemButton(
              itemTitle: 'Jadwal Operasional',
            ),
            ItemButton(
              itemTitle: 'Poster Promosi Toko',
            ),
            Divider(
              thickness: 0.25,
            ),
            ItemButton(
              itemTitle: 'Tambah dan Ubah Lokasi',
            ),
            ItemButton(
              itemTitle: 'Atur Notifikasi Penjual',
            ),
            Divider(
              thickness: 0.25,
            ),
            ItemButton(
              itemTitle: 'Hapus Toko',
            ),
            ItemButton(
              itemTitle: 'Keluar Toko',
            ),
          ],
        ),
      ),
    );
  }
}

class ItemButton extends StatelessWidget{
  const ItemButton({super.key, required this.itemTitle, this.onPressed});
  final String itemTitle;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: onPressed,
        child: Card(
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(itemTitle),
                const Icon(Icons.keyboard_arrow_right)
              ],
            ),
          )
        ),
      )
    );
  }
}