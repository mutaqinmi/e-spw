// import 'package:cached_network_image/cached_network_image.dart';
import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget{
  const ProfilePage({super.key, this.userID});
  final String? userID;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{
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
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    const Hero(
                      tag: 'profile',
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          'https://$baseUrl/assets/images/profile.png'
                        ),
                      ),
                    ),
                    const Gap(20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FutureBuilder(
                          future: _getUserData(),
                          builder: (BuildContext context, AsyncSnapshot response){
                            if(response.hasData){
                              return Text(
                                response.data.first['nama'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600
                                ),
                              );
                            }

                            return const Text(
                              "Nama Siswa",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600
                              ),
                            );
                          },
                        ),
                        FutureBuilder(
                          future: _getUserData(),
                          builder: (BuildContext context, AsyncSnapshot response){
                            if(response.hasData){
                              return Text(
                                '${response.data.first['nis'].toString()} | ${response.data.first['kelas']}',
                                style: const TextStyle(
                                  fontSize: 12
                                ),
                              );
                            }

                            return const Text(
                              "NIS",
                              style: TextStyle(
                                fontSize: 12
                              ),
                            );
                          },
                        )
                      ],
                    ),
                    const Gap(10),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              style: const ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(Colors.transparent)
                              ),
                              onPressed: () => context.pushNamed('edit-profile'),
                              child: const Wrap(
                                spacing: 5,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person_outlined,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    'Profil',
                                    style: TextStyle(
                                      color: Colors.black
                                    ),
                                  )
                                ],
                              )
                            ),
                          ),
                          const VerticalDivider(
                            thickness: .25,
                            indent: 10,
                            endIndent: 10,
                          ),
                          Expanded(
                            child: FilledButton(
                              style: const ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(Colors.transparent)
                              ),
                              onPressed: () => context.pushNamed('login-shop'),
                              child: const Wrap(
                                spacing: 5,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(
                                    Icons.storefront_outlined,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    'Toko',
                                    style: TextStyle(
                                      color: Colors.black
                                    ),
                                  )
                                ],
                              )
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ),
            const Gap(20),
            SafeArea(
              minimum: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        side: BorderSide(
                          width: .5
                        )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Pesanan',
                                ),
                                Icon(Icons.keyboard_arrow_right)
                              ],
                            ),
                            const Gap(10),
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    style: const ButtonStyle(
                                      foregroundColor: WidgetStatePropertyAll(Colors.black),
                                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero
                                      ))
                                    ),
                                    onPressed: () => context.goNamed('order', queryParameters: {'initial_index': '0'}),
                                    child: const Column(
                                      children: [
                                        Icon(Icons.history),
                                        Gap(10),
                                        Text(
                                          'Diproses'
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextButton(
                                    style: const ButtonStyle(
                                      foregroundColor: WidgetStatePropertyAll(Colors.black),
                                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero
                                      ))
                                    ),
                                    onPressed: () => context.goNamed('order', queryParameters: {'initial_index': '1'}),
                                    child: const Column(
                                      children: [
                                        Icon(Icons.check_circle_outline),
                                        Gap(10),
                                        Text(
                                          'Selesai'
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () => {},
                      child: const Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          side: BorderSide(
                            width: .5
                          )
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Wrap(
                                spacing: 10,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(Icons.stars_outlined),
                                  Text('Penilaian Saya')
                                ],
                              ),
                              Icon(Icons.keyboard_arrow_right)
                            ],
                          ),
                        ),
                      ),
                    )
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () => context.pushNamed('favorite'),
                      child: const Card(
                        elevation: 0,
                        surfaceTintColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          side: BorderSide(
                            width: .5
                          )
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Wrap(
                                spacing: 10,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(Icons.favorite_outline),
                                  Text('Toko yang disukai')
                                ],
                              ),
                              Icon(Icons.keyboard_arrow_right)
                            ],
                          ),
                        ),
                      ),
                    )
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10, top: 15, bottom: 5),
                    child: Text('Pengaturan Akun'),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        side: BorderSide(
                          width: .5
                        )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MenuButton(
                            icon: Icons.password,
                            label: 'Ubah Kata Sandi',
                            onPressed: () => context.pushNamed('verify-password'),
                          ),
                          const MenuButton(
                            icon: Icons.location_on_outlined,
                            label: 'Alamat Utama',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          content: const Text('Apakah anda yakin ingin keluar?'),
                          actions: [
                            TextButton(
                              onPressed: () => context.pop(),
                              child: const Text('Batal'),
                            ),
                            FilledButton(
                              onPressed: () => logout(context),
                              child: const Text('Keluar'),
                            )
                          ],
                        )
                      ),
                      child: Card(
                        color: Theme.of(context).primaryColor,
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Keluar', style: TextStyle(color: Colors.white)),
                              Icon(Icons.logout, color: Colors.white)
                            ],
                          ),
                        ),
                      ),
                    )
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}

class MenuButton extends StatelessWidget{
  const MenuButton({super.key, required this.icon, required this.label, this.onPressed});
  final IconData icon;
  final String label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: const ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(Colors.black),
          overlayColor: WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.zero
          ))
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              spacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(icon),
                Text(label)
              ],
            ),
            const Icon(Icons.keyboard_arrow_right)
          ],
        ),
      ),
    );
  }
}