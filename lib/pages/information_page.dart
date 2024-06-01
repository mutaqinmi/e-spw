import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InformationPage extends StatelessWidget{
  const InformationPage({super.key, required this.idToko});
  final String idToko;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Informasi Toko',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            ItemButton(
              itemTitle: const Text('Ubah Informasi Toko'),
              onPressed: () => context.pushNamed('detail-shop', queryParameters: {'id_toko': idToko}),
            ),
            ItemButton(
              itemTitle: const Text('Kode Unik'),
              onPressed: () => context.pushNamed('unique-code', queryParameters: {'id_toko': idToko}),
            ),
            ItemButton(
              itemTitle: const Text('Anggota'),
              onPressed: () => context.pushNamed('member', queryParameters: {'id_toko': idToko}),
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