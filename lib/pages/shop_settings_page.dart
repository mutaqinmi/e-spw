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
              itemTitle: Text('Informasi'),
            ),
            ItemButton(
              itemTitle: Text('Jadwal Operasional'),
            ),
            ItemButton(
              itemTitle: Text('Lokasi'),
            ),
            Divider(
              thickness: 0.25,
            ),
            ItemButton(
              itemTitle: Text('Keluar Toko'),
            ),
            ItemButton(
              itemTitle: Text(
                'Hapus Toko',
                style: TextStyle(
                  color: Colors.red
                ),
              ),
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
                itemTitle,
                const Icon(Icons.keyboard_arrow_right)
              ],
            ),
          )
        ),
      )
    );
  }
}