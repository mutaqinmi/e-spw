// import 'package:cached_network_image/cached_network_image.dart';
import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatelessWidget{
  const EditProfilePage({super.key});

  Future<List> getUserData() async {
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
      body: SingleChildScrollView(
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://$baseUrl/assets/images/profile.png'
                    ),
                  ),
                  TextButton(
                    onPressed: (){},
                    child: const Text('Ubah Foto Profil'),
                  )
                ],
              ),
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
                      FutureBuilder(
                        future: getUserData(),
                        builder: (BuildContext context, AsyncSnapshot response){
                          if(response.hasData){
                            return Expanded(
                              flex: 2,
                              child: Text(
                                response.data.first['nama'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            );
                          }

                          return const Expanded(
                            flex: 2,
                            child: Text(
                              'Nama siswa',
                              style: TextStyle(
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          );
                        },
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
                      FutureBuilder(
                        future: getUserData(),
                        builder: (BuildContext context, AsyncSnapshot response){
                          if(response.hasData){
                            return Expanded(
                              flex: 2,
                              child: Text(
                                response.data.first['kelas'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            );
                          }

                          return const Expanded(
                            flex: 2,
                            child: Text(
                              'Kelas',
                              style: TextStyle(
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          );
                        }
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
                      FutureBuilder(
                        future: getUserData(),
                        builder: (BuildContext context, AsyncSnapshot response){
                          if(response.hasData){
                            return Expanded(
                              flex: 2,
                              child: Text(
                                response.data.first['nis'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            );
                          }

                          return const Expanded(
                            flex: 2,
                            child: Text(
                              'NIS',
                              style: TextStyle(
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          );
                        },
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
                      FutureBuilder(
                        future: getUserData(),
                        builder: (BuildContext context, AsyncSnapshot response){
                          if(response.hasData){
                            return Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    response.data.first['telepon'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){},
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
                            );
                          }

                          return Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Telepon'),
                                GestureDetector(
                                  onTap: (){},
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
                          );
                        }
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}