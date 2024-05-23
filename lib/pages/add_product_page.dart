import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AddProductPage extends StatefulWidget{
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Tambah Produk',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tambah Produk',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Text(
                    'Isi informasi produk anda.',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  )
                ],
              ),
              const Gap(20),
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nama Produk',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        const Text(
                          'Tips: Jenis Produk + Merek + Keterangan.',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const Gap(5),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            hintText: 'Nama Produk'
                          ),
                        )
                      ],
                    ),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Harga',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        const Text(
                          'Isi sesuai dengan harga pasar produk.',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const Gap(5),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            hintText: 'Harga',
                            prefixText: 'Rp. ',
                          ),
                        )
                      ],
                    ),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Stok',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        const Text(
                          'Isi sesuai dengan jumlah stok yang tersedia.',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const Gap(5),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            hintText: 'Stok',
                          ),
                        )
                      ],
                    ),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Deskripsi Produk',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        const Text(
                          'Tulis deskripsi produk..',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const Gap(5),
                        TextFormField(
                          maxLines: 5,
                          maxLength: 255,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            hintText: 'Deskripsi',
                          ),
                        )
                      ],
                    ),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Detail Produk',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        const Text(
                          'Contoh: Bahan yang digunakan ...',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const Gap(5),
                        TextFormField(
                          maxLines: 5,
                          maxLength: 255,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            hintText: 'Detail Produk',
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  )
                ),
              ),
              child: const Text(
                'Selanjutnya',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: (){},
            ),
          ),
        )
      ),
    );
  }
}