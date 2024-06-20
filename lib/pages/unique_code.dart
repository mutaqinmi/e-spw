import 'dart:convert';
import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UniqueCode extends StatelessWidget{
  const UniqueCode({super.key, required this.idToko});
  final String idToko;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kode Unik',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600
              ),
            ),
            const Text(
              'Kode unik toko'
            ),
            Center(
              child: FutureBuilder(
                future: getTokoByIdToko(context: context, shopId: idToko),
                builder: (BuildContext context, AsyncSnapshot response){
                  if(response.hasData){
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: GestureDetector(
                        onLongPress: () => Clipboard.setData(ClipboardData(text: json.decode(response.data.body)['data'].first['toko']['kode_unik'])),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.withAlpha(50),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text(
                            json.decode(response.data.body)['data'].first['toko']['kode_unik'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              letterSpacing: 20
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return const SizedBox(
                    height: 85,
                  );
                },
              ),
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey
                  ),
                ),
                Text(
                  '1. Minta teman anda untuk membuka aplikasi eSPW.',
                  style: TextStyle(
                    color: Colors.grey
                  ),
                ),
                Text(
                  '2. Masuk ke menu Profil > Toko, kemudian klik "Gabung ke Toko"',
                  style: TextStyle(
                    color: Colors.grey
                  ),
                ),
                Text(
                  '3. Isi field dengan kode unik toko di atas',
                  style: TextStyle(
                    color: Colors.grey
                  ),
                ),
                Text(
                  '4. Klik "Gabung"',
                  style: TextStyle(
                    color: Colors.grey
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}