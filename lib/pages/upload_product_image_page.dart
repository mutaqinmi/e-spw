import 'dart:io';
import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class UploadProductImagePage extends StatefulWidget{
  const UploadProductImagePage({super.key, required this.namaProduk, required this.harga, required this.stok, this.deskripsiProduk, required this.detailProduk, required this.idToko});
  final String? namaProduk;
  final String? harga;
  final String? stok;
  final String? deskripsiProduk;
  final String? detailProduk;
  final String? idToko;

  @override
  State<UploadProductImagePage> createState() => _UploadProductImagePageState();
}

class _UploadProductImagePageState extends State<UploadProductImagePage>{
  File? filePath;

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
      borderRadius: BorderRadius.circular(20),
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
              onPressed: () => addProduct(
                context: context,
                namaProduk: widget.namaProduk!,
                harga: widget.harga!,
                stok: widget.stok!,
                deskripsiProduk: widget.deskripsiProduk!,
                detailProduk: widget.detailProduk!,
                fotoProduk: filePath!,
                idToko: widget.idToko!,
                isCreate: false,
              ),
              child: const Text('Selesai!'),
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
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Atur Foto Produk',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600
                  ),
                ),
                Text(
                  'Atur foto produk anda.'
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