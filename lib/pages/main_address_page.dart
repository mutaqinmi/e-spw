import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MainAddressPage extends StatefulWidget{
  const MainAddressPage({super.key});

  @override
  State<MainAddressPage> createState() => _MainAddressPageState();
}

class _MainAddressPageState extends State<MainAddressPage>{
  final _addressKey = GlobalKey<FormFieldState>();
  String _address = '';

  void _submit(){
    if(_addressKey.currentState!.validate()){
      _addressKey.currentState!.save();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const AlertDialog(
          backgroundColor: Colors.transparent,
          content: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                strokeWidth: 6,
              ),
            ]
          ),
        )
      );
      addAlamat(
        context: context,
        address: _address
      );
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
                hintText: 'e.g. Lab. RPL, Lt. 2, Gedung Teknologi Informasi (TKJ), SMK Negeri 2 Tasikmalaya',
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
              child: const Text(
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