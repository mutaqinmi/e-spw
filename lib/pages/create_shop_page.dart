import 'dart:convert';

import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CreateShopPage extends StatefulWidget{
  const CreateShopPage({super.key});

  @override
  State<CreateShopPage> createState() => _CreateShopPageState();
}

class _CreateShopPageState extends State<CreateShopPage>{
  final _namaTokoKey = GlobalKey<FormFieldState>();
  final _kategoriTokoKey = GlobalKey<FormFieldState>();
  final _deskripsiTokoKey = GlobalKey<FormFieldState>();
  String _namaToko = '';
  String? _kelasValue = 'X DPIB 1';
  String _kategoriToko = '';
  String _deskripsiToko = '';

  void submit(){
    if(_namaTokoKey.currentState!.validate() && _kategoriTokoKey.currentState!.validate()){
      _namaTokoKey.currentState!.save();
      _kategoriTokoKey.currentState!.save();
      _deskripsiTokoKey.currentState!.save();

      context.pushNamed('upload-profile-image', queryParameters: {
        'nama_toko': _namaToko,
        'kelas': _kelasValue,
        'deskripsi_toko': _deskripsiToko,
        'kategori_toko': _kategoriToko
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: kelas(),
        builder: (BuildContext context, AsyncSnapshot response){
          if(response.hasData || response.connectionState == ConnectionState.done){
            final data = json.decode(response.data.body)['data'];
            List<String> listKelas = [];
            for(int i = 0; i < data.length; i++){
              listKelas.add(data[i]['kelas']);
            }

            return SingleChildScrollView(
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
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              key: _namaTokoKey,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                hintText: 'Nama Toko',
                                labelText: 'Nama Toko'
                              ),
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Isi nama toko terlebih dahulu!';
                                }

                                return null;
                              },
                              onSaved: (value){_namaToko = value!;},
                            ),
                          ),
                          const Gap(15),
                          Expanded(
                            flex: 1,
                            child: DropdownButton(
                              hint: const Text('Kelas'),
                              icon: const Icon(Icons.arrow_drop_down),
                              isExpanded: true,
                              value: _kelasValue,
                              onChanged: (selected){
                                setState(() {
                                  _kelasValue = selected!;
                                });
                              },
                              items: listKelas.map((item){
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList()
                            )
                          ),
                        ],
                      ),
                      const Gap(15),
                      TextFormField(
                        key: _kategoriTokoKey,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          hintText: 'Kategori Toko',
                          labelText: 'Kategori Toko',
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Isi kategori toko terlebih dahulu!';
                          }

                          return null;
                        },
                        onSaved: (value){_kategoriToko = value!;},
                      ),
                      const Gap(15),
                      TextFormField(
                        key: _deskripsiTokoKey,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          hintText: 'Deskripsi Toko',
                          labelText: 'Deskripsi Toko'
                        ),
                        onSaved: (value){_deskripsiToko = value!;},
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: () => submit(),
              child: const Text('Selanjutnya'),
            ),
          ),
        ),
      )
    );
  }
}