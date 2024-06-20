import 'dart:io';
import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class UploadProfileImagePage extends StatefulWidget{
  const UploadProfileImagePage({super.key, required this.namaToko, required this.kelas, required this.deskripsiToko});
  final String? namaToko;
  final String? kelas;
  final String? deskripsiToko;

  @override
  State<UploadProfileImagePage> createState() => _UploadProfileImagePageState();
}

class _UploadProfileImagePageState extends State<UploadProfileImagePage>{
  File? filePath;

  void _submit(){
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
    addToko(
      context: context,
      namaToko: widget.namaToko!,
      kelas: widget.kelas!,
      deskripsiToko: widget.deskripsiToko!,
      bannerToko: filePath
    );
  }

  Future<File> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    File? file = File(image!.path);
    file = await _cropImage(imageFile: file);
    setState(() {
      filePath = file;
    });
    return file!;
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
  
  Widget checkMedia(){
    if(filePath == null){
      return OutlinedButton(
        onPressed: () => getImage(),
        child: const Text('Pilih Gambar'),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(125),
      child: Image.file(
        filePath!,
        width: 250,
      ),
    );
  }

  Widget confirm(){
    if(filePath == null){
      return const Row();
    }

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              style: ButtonStyle(
                backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
                foregroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                side: WidgetStatePropertyAll(BorderSide(
                  width: 1,
                  color: Theme.of(context).primaryColor
                ))
              ),
              onPressed: () => getImage(),
              child: const Text('Pilih Gambar'),
            ),
          ),
        ),
        const Gap(5),
        Expanded(
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: () => _submit(),
              child: const Text('Selanjutnya'),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor
                        ),
                        child: const Center(
                          child: Text(
                            '1',
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 75,
                        child: Divider(
                          thickness: 3,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor
                        ),
                        child: const Center(
                          child: Text(
                            '2',
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 75,
                        child: Divider(
                        thickness: 3,
                        color: Colors.grey,
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey
                        ),
                        child: const Center(
                          child: Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 75,
                        child: Divider(
                          thickness: 3,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey
                        ),
                        child: const Center(
                          child: Text(
                            '4',
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: Center(
                          child: Text(
                            'Buat Toko',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 45,
                        child: Divider(
                          thickness: 0,
                          color: Colors.transparent,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: Center(
                          child: Text(
                            'Foto Profil',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 45,
                        child: Divider(
                          thickness: 0,
                          color: Colors.transparent,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: Center(
                          child: Text(
                            'Tambah Produk',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 45,
                        child: Divider(
                          thickness: 0,
                          color: Colors.transparent,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: Center(
                          child: Text(
                            'Foto Produk',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
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
                child: checkMedia()
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: confirm()
        ),
      ),
    );
  }
}