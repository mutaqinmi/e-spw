import 'package:cached_network_image/cached_network_image.dart';
import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget{
  const ProfilePage({super.key, this.userID});
  final String? userID;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Hero(
                  tag: 'profile',
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: CachedNetworkImageProvider(
                      'https://images.unsplash.com/photo-1531891437562-4301cf35b7e4?q=80&w=1364&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
                    ),
                  ),
                ),
                const Gap(15),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Muhammad Ilham Mutaqin',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      Text(
                        'XI PPLG',
                        style: TextStyle(
                            fontSize: 12
                        ),
                      )
                    ],
                  ),
                ),
                IconButton(
                  onPressed: (){},
                  icon: const Icon(Icons.edit_outlined),
                )
              ],
            ),
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
                    surfaceTintColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      side: BorderSide(
                        color: Colors.grey,
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
                                    foregroundColor: MaterialStatePropertyAll(Colors.black),
                                    overlayColor: MaterialStatePropertyAll(Colors.transparent),
                                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero
                                    ))
                                  ),
                                  onPressed: (){
                                    context.goNamed('order', queryParameters: {'initial_index': '0'});
                                  },
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
                                    foregroundColor: MaterialStatePropertyAll(Colors.black),
                                    overlayColor: MaterialStatePropertyAll(Colors.transparent),
                                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero
                                    ))
                                  ),
                                  onPressed: (){
                                    context.goNamed('order', queryParameters: {'initial_index': '1'});
                                  },
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
                              Expanded(
                                child: TextButton(
                                  style: const ButtonStyle(
                                    foregroundColor: MaterialStatePropertyAll(Colors.black),
                                    overlayColor: MaterialStatePropertyAll(Colors.transparent),
                                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero
                                    ))
                                  ),
                                  onPressed: (){},
                                  child: const Column(
                                    children: [
                                      Icon(Icons.star_outline),
                                      Gap(10),
                                      Text(
                                        'Penilaian'
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
                    onTap: (){
                      context.pushNamed('login-shop');
                    },
                    child: const Card(
                      surfaceTintColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        side: BorderSide(
                          color: Colors.grey,
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
                                Icon(Icons.storefront_outlined),
                                Text('Toko')
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
                    onTap: (){
                      context.pushNamed('favorite');
                    },
                    child: const Card(
                      surfaceTintColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        side: BorderSide(
                          color: Colors.grey,
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
                                Text('Favorit Saya')
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
                    surfaceTintColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      side: BorderSide(
                        color: Colors.grey,
                      )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MenuButton(
                          icon: Icons.password,
                          label: 'Ubah Kata Sandi',
                          onPressed: (){
                            context.pushNamed('change-password');
                          },
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
                    onTap: (){
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context){
                          return SizedBox(
                            width: double.infinity,
                            height: 80,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: FilledButton(
                                onPressed: (){
                                  logout(context);
                                },
                                child: const Text('Keluar'),
                              ),
                            ),
                          );
                        }
                      );
                    },
                    child: const Card(
                      color: Colors.red,
                      child: Padding(
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
          foregroundColor: MaterialStatePropertyAll(Colors.black),
          overlayColor: MaterialStatePropertyAll(Colors.transparent),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
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