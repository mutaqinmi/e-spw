import 'dart:convert';
import 'dart:io';
import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class DetailShop extends StatefulWidget{
  const DetailShop({super.key, required this.idToko});
  final String idToko;

  @override
  State<DetailShop> createState() => _DetailShopState();
}

class _DetailShopState extends State<DetailShop>{
  bool _buttonClicked = false;
  final _deskripsiTokoKey = GlobalKey<FormFieldState>();
  String _deskripsiToko = '';

  void _submit(){
    _deskripsiTokoKey.currentState!.save();
    setState(() {
      _buttonClicked = true;
    });
    updateDeskripsiToko(
      context: context,
      deskripsiToko: _deskripsiToko,
      idToko: widget.idToko
    );
  }

  void _getImage(String oldImage) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    File? file = File(image!.path);
    file = await _cropImage(imageFile: file);
    if(!mounted) return;
    return updateFotoProfilToko(
      context: context,
      bannerToko: file!,
      idToko: widget.idToko,
      oldImage: oldImage
    );
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      cropStyle: CropStyle.circle,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Edit',
          lockAspectRatio: true,
          hideBottomControls: true
        )
      ]
    );
    if(croppedImage == null) return null;
    return File(croppedImage.path);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Informasi Toko',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          )
        ),
      ),
      body: FutureBuilder(
        future: getTokoByIdToko(context: context, shopId: widget.idToko),
        builder: (BuildContext context, AsyncSnapshot response){
          if(response.connectionState == ConnectionState.done){
            final toko = json.decode(response.data.body)['data'].first['toko'];
            final kelas = json.decode(response.data.body)['data'].first['kelas'];
            return SingleChildScrollView(
              child: SafeArea(
                minimum: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              'https://$apiBaseUrl/public/${toko['banner_toko']}'
                            ),
                          ),
                          const Gap(5),
                          TextButton(
                            onPressed: () => _getImage(toko['banner_toko']),
                            child: const Text('Ubah Foto Profil'),
                          )
                        ],
                      ),
                    ),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Nama Toko'),
                        const Gap(5),
                        Text(
                          toko['nama_toko'],
                          style: const TextStyle(
                            fontSize: 16
                          ),
                        )
                      ],
                    ),
                    const Gap(20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Kelas'),
                        const Gap(5),
                        Text(
                          kelas['kelas'],
                          style: const TextStyle(
                            fontSize: 16
                          ),
                        )
                      ],
                    ),
                    const Gap(20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Deskripsi Toko'),
                        const Gap(5),
                        TextFormField(
                          initialValue: toko['deskripsi_toko'],
                          key: _deskripsiTokoKey,
                          maxLines: 5,
                          maxLength: 255,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            hintText: 'Deskripsi Toko',
                          ),
                          onSaved: (value) => _deskripsiToko = value!,
                        ),
                      ],
                    )
                  ],
                ),
              )
            );
          }

          return const Center(
            child: CircularProgressIndicator()
          );
        }
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
            child: _buttonClicked ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ) : const Text('Ubah Informasi Toko'),
            onPressed: () => _submit(),
          )
        ),
      )
    );
  }
}