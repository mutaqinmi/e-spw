// import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'dart:io';
import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget{
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage>{
  String profilePicture = '';

  Future<List> _getUserData() async {
    List userData = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final nis = prefs.getInt('nis');
    final nama = prefs.getString('nama');
    final kelas = prefs.getString('kelas');
    final telepon = prefs.getString('telepon');
    final fotoProfil = prefs.getString('foto_profil');

    userData.add({
      "nis": nis,
      "nama": nama,
      "kelas": kelas,
      "telepon": telepon,
      "foto_profil": fotoProfil
    });

    return userData;
  }

  @override
  void initState() {
    super.initState();
    _getUserData().then((res) => setState(() {
      profilePicture = res.first['foto_profil'];
    }));
  }

  void _getImage() async {
    context.pop();
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    File? file = File(image!.path);
    file = await _cropImage(imageFile: file);
    if(!mounted) return;
    return updateFotoProfilSiswa(
      context: context,
      profilePicture: file!
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
          'Edit Profil',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
      body: FutureBuilder(
        future: getDataSiswa(context: context),
        builder: (BuildContext context, AsyncSnapshot response){
          if(response.connectionState == ConnectionState.done){
            if(json.decode(response.data.body).isNotEmpty){
              final data = json.decode(response.data.body);
              return SingleChildScrollView(
                child: SafeArea(
                  minimum: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            contentPadding: const EdgeInsets.symmetric(vertical: 20),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: InkWell(
                                    onTap: () => _getImage(),
                                    child: const Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Text('Ubah Foto Profil'),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: InkWell(
                                    onTap: () => hapusFotoProfilSiswa(
                                      context: context
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Text('Hapus Foto Profil'),
                                    ),
                                  ),
                                ),
                              ]
                            ),
                          )
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            data['siswa']['foto_profil'].isEmpty ? 'https://$baseUrl/images/profile.png' : 'https://$apiBaseUrl/public/${data['siswa']['foto_profil']}'
                          ),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withAlpha(100),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(Icons.edit_outlined),
                          ),
                        ),
                      ),
                      const Gap(20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Wrap(
                            spacing: 5,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text('Info Profil'),
                              Icon(Icons.info_outline)
                            ],
                          ),
                          const Gap(10),
                          Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  'Nama',
                                  style: TextStyle(
                                    color: Colors.grey
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  data['siswa']['nama'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              )
                            ],
                          ),
                          const Gap(5),
                          Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  'Kelas',
                                  style: TextStyle(
                                    color: Colors.grey
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  data['kelas']['kelas'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      const Gap(10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Wrap(
                            spacing: 5,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text('Info Pribadi'),
                              Icon(Icons.info_outline)
                            ],
                          ),
                          const Gap(10),
                          Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  'NIS',
                                  style: TextStyle(
                                    color: Colors.grey
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  data['siswa']['nis'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              )
                            ],
                          ),
                          const Gap(5),
                          Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  'No Telepon',
                                  style: TextStyle(
                                    color: Colors.grey
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      data['siswa']['telepon'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => context.pushNamed('change-phone'),
                                      child: Text(
                                        'Ubah',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }
}