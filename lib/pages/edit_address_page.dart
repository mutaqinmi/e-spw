import 'dart:convert';
import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EditAddressPage extends StatefulWidget{
  const EditAddressPage({super.key, required this.idAlamat});
  final String idAlamat;

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage>{
  final _addressKey = GlobalKey<FormFieldState>();
  String _address = '';

  List address = [];
  @override
  void initState() {
    super.initState();
    getAlamatById(context: context, idAlamat: int.parse(widget.idAlamat)).then((res) => setState(() {
      address = json.decode(res!.body)['data'];
    }));
  }

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
      editAlamat(
        context: context,
        idAlamat: int.parse(widget.idAlamat),
        alamat: _address
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Alamat',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            FutureBuilder(
              future: getAlamatById(context: context, idAlamat: int.parse(widget.idAlamat)),
              builder: (BuildContext context, AsyncSnapshot response){
                if(response.hasData){
                  return TextFormField(
                    key: _addressKey,
                    maxLength: 255,
                    maxLines: 5,
                    initialValue: json.decode(response.data.body)['data'].first['alamat'],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      hintText: 'contoh : Lab. RPL, Lt. 2, Gedung Teknologi Informasi (TKJ), SMK Negeri 2 Tasikmalaya',
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Masukkan alamat terlebih dahulu!';
                      }

                      return null;
                    },
                    onSaved: (value) => _address = value!,
                  );
                }

                return const SizedBox();
              }
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