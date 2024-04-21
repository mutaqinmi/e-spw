import 'package:flutter/material.dart';

class UploadProfileImagePage extends StatelessWidget{
  const UploadProfileImagePage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: (){},
              child: const Text(
                'Lewati',
                style: TextStyle(
                  fontSize: 14
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Atur Banner Toko',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600
                  ),
                ),
                Text(
                  'Atur banner toko anda.'
                )
              ],
            ),
            Expanded(
              child: Center(
                child: OutlinedButton(
                  onPressed: (){},
                  child: const Text('Pilih Gambar'),
                ),
              ),
            )
          ],
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
              onPressed: (){},
              child: const Text('Selesai!'),
            ),
          ),
        ),
      ),
    );
  }
}