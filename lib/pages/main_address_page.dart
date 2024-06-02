import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MainAddressPage extends StatefulWidget{
  const MainAddressPage({super.key});

  @override
  State<MainAddressPage> createState() => _MainAddressPageState();
}

class _MainAddressPageState extends State<MainAddressPage>{
  bool _buttonClick = false;
  final _addressKey = GlobalKey<FormFieldState>();
  String _address = '';

  void _submit(){
    if(_addressKey.currentState!.validate()){
      _addressKey.currentState!.save();
      setState(() {
        _buttonClick = true;
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        top: false,
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alamat Utama',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600
                  ),
                ),
                Text('Isi alamat utama untuk memudahkan penjual menemukan anda.')
              ],
            ),
            const Gap(20),
            TextFormField(
              key: _addressKey,
              maxLength: 255,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                hintText: 'Masukkan Alamat Utama',
                label: Text('Masukkan Alamat Utama'),
              ),
              validator: (value){
                if(value!.isEmpty){
                  return 'Masukkan alamat terlebih dahulu!';
                }

                return null;
              },
              onSaved: (value) => _address = value!,
            ),
          ],
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
              child: _buttonClick ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ) : const Text(
                'Simpan Alamat',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () => _submit(),
            ),
          ),
        )
      ),
    );
  }
}