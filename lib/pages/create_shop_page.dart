import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CreateShopPage extends StatefulWidget{
  const CreateShopPage({super.key});

  @override
  State<CreateShopPage> createState() => _CreateShopPageState();
}

class _CreateShopPageState extends State<CreateShopPage>{
  String? kelasValue = 'XI PPLG';
  String? jurusanValue = 'Pengembangan Perangkat Lunak dan Gim';

  List<String> kelas = [
    'XI PPLG',
    'XI TJKT 1',
    'XI TJKT 2'
  ];

  List<String> jurusan = [
    'Pengembangan Perangkat Lunak dan Gim',
    'Teknik Jaringan Komputer dan Telekomunikasi',
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Buat Toko',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    Text(
                      'Personalisasikan toko anda.'
                    )
                  ],
                ),
                const Gap(20),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: 'Nama Toko',
                    labelText: 'Nama Toko'
                  ),
                ),
                const Gap(15),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: DropdownButton(
                        icon: const Icon(Icons.arrow_drop_down),
                        isExpanded: true,
                        value: kelasValue,
                        onChanged: (selected){
                          setState(() {
                            kelasValue = selected!;
                          });
                        },
                        items: kelas.map((item){
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList()
                      )
                    ),
                    const Gap(15),
                    Expanded(
                      flex: 2,
                      child: DropdownButton(
                          icon: const Icon(Icons.arrow_drop_down),
                          isExpanded: true,
                          value: jurusanValue,
                          onChanged: (selected){
                            setState(() {
                              jurusanValue = selected!;
                            });
                          },
                          items: jurusan.map((item){
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item, overflow: TextOverflow.ellipsis),
                            );
                          }).toList()
                      )
                    )
                  ],
                ),
                const Gap(15),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: 'Kategori Toko',
                    labelText: 'Kategori Toko'
                  ),
                ),
                const Gap(15),
                TextFormField(
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    hintText: 'Deskripsi Toko',
                    labelText: 'Deskripsi Toko'
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: (){
                context.pushNamed('upload-profile-image');
              },
              child: const Text('Selanjutnya'),
            ),
          ),
        ),
      )
    );
  }
}