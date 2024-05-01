import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductPage extends StatefulWidget{
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            foregroundColor: Theme.of(context).primaryColor,
            title: const Text(
              'Produk',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
            ),
            actions: [
              IconButton(
                onPressed: (){
                  context.pushNamed('add-product');
                },
                icon: const Icon(Icons.add),
              )
            ],
          ),
          SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  hintText: 'Telusuri Produk ...',
                  suffixIcon: Icon(Icons.search)
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Wrap(
                spacing: 5,
                children: [
                  ChoiceChip(
                    label: const Text('Semua'),
                    selected: true,
                    onSelected: (bool selected){},
                  )
                ],
              )
            ),
          )
        ],
      ),
    );
  }
}