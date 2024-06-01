import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ChangePhone extends StatefulWidget{
  const ChangePhone({super.key});

  @override
  State<ChangePhone> createState() => _ChangePhoneState();
}

class _ChangePhoneState extends State<ChangePhone>{
  Widget _buttonChild = const Text(
    'Ubah Nomor Telepon',
    style: TextStyle(
      fontWeight: FontWeight.w600,
    ),
  );
  final _phoneKey = GlobalKey<FormFieldState>();
  String _phone = '';

  void _submit(){
    if(_phoneKey.currentState!.validate()){
      _phoneKey.currentState!.save();
      setState(() {
        _buttonChild = const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      });
      updateTelepon(
        context: context,
        telepon: _phone,
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ubah Nomor Telepon',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Text(
                    'Ubah nomor telepon anda agar penjual lebih mudah menghubungi anda.'
                  )
                ],
              ),
              const Gap(10),
              TextFormField(
                key: _phoneKey,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  hintText: 'Masukkan Nomor Telepon',
                  label: Text('Masukkan Nomor Telepon'),
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Masukkan nomor terlebih dahulu!';
                  }

                  return null;
                },
                onSaved: (value) => _phone = value!,
              ),
            ],
          ),
        )
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
              child: _buttonChild,
              onPressed: () => _submit(),
            ),
          ),
        )
      ),
    );
  }
}