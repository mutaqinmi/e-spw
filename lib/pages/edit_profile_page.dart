import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EditProfilePage extends StatelessWidget{
  const EditProfilePage({super.key});

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
                    backgroundImage: CachedNetworkImageProvider(
                      'https://images.unsplash.com/photo-1531891437562-4301cf35b7e4?q=80&w=1364&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
                    ),
                  ),
                  TextButton(
                    onPressed: (){},
                    child: const Text('Ubah Foto Profil'),
                  )
                ],
              ),
              const Divider(
                thickness: 0.25,
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text('Info Profil'),
                      Icon(Icons.info_outline)
                    ],
                  ),
                  Gap(10),
                  Row(
                    children: [
                      Expanded(
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
                          'Muhammad Ilham Mutaqin',
                          style: TextStyle(
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
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
                          'XI PPLG',
                          style: TextStyle(
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(
                thickness: 0.25,
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text('Info Pribadi'),
                      Icon(Icons.info_outline)
                    ],
                  ),
                  Gap(10),
                  Row(
                    children: [
                      Expanded(
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
                          '12225173',
                          style: TextStyle(
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
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
                            Text('Tuliskan Nomor'),
                            Icon(Icons.keyboard_arrow_right)
                          ],
                        ),
                      ),
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