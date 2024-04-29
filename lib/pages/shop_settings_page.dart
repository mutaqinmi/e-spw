import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.storefront_outlined,
                  color: Theme.of(context).primaryColor,
                ),
                const Gap(10),
                const Text(
                  'Tentang Toko'
                )
              ],
            ),
            const Gap(10),
            const ItemButton(
              itemTitle: 'Informasi',
            ),
            const ItemButton(
              itemTitle: 'Banner',
            ),
            const ItemButton(
              itemTitle: 'Jadwal Operasional',
            ),
            const ItemButton(
              itemTitle: 'Poster Promosi Toko',
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