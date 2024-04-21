import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';

class JoinShopPage extends StatelessWidget{
  const JoinShopPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).primaryColor,
      ),
      body: const SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Gabung ke Toko',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600
                ),
              ),
              Text(
                'Masukkan kode toko untuk bergabung'
              ),
              Gap(20),
              Form(
                child: Pinput(
                  length: 4,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                ),
              )
            ],
          ),
        )
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
              child: const Text('Gabung'),
            ),
          ),
        ),
      ),
    );
  }
}