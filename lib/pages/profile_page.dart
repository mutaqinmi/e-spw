import 'dart:convert';
import 'package:espw/app/controllers.dart';
import 'package:espw/widgets/authenticator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget{
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1)).asyncMap((i) => getDataSiswa(context: context)),
            builder: (BuildContext context, AsyncSnapshot response){
              if(response.hasData){
                final siswa = json.decode(response.data.body)['siswa'];
                final kelas = json.decode(response.data.body)['kelas'];
                return SliverAppBar(
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    systemNavigationBarIconBrightness: Brightness.light,
                    statusBarIconBrightness: Brightness.light
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  expandedHeight: 300,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(20),
                    child: Container(
                      width: double.infinity,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                      ),
                    )
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Card(
                      color: Colors.transparent,
                      elevation: 0,
                      child: SafeArea(
                        minimum: const EdgeInsets.only(top: 60, left: 16, right: 16),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => context.pushNamed('edit-profile'),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                  siswa['foto_profil'].isEmpty ? 'https://$baseUrl/images/profile.png' : 'https://$apiBaseUrl/public/${siswa['foto_profil']}'
                                ),
                              ),
                            ),
                            const Gap(20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  siswa['nama'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white
                                  ),
                                ),
                                Text(
                                  '${siswa['nis'].toString()} | ${kelas['kelas']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white
                                  ),
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
                                            color: Colors.white
                                          ),
                                          Text(
                                            'Profil',
                                            style: TextStyle(
                                              color: Colors.white
                                            ),
                                          )
                                        ],
                                      )
                                    ),
                                  ),
                                  const VerticalDivider(
                                    thickness: .5,
                                    indent: 10,
                                    endIndent: 10,
                                    color: Colors.white
                                  ),
                                  Expanded(
                                    child: FilledButton(
                                      style: const ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(Colors.transparent)
                                      ),
                                      onPressed: () => context.goNamed('login-shop'),
                                      child: const Wrap(
                                        spacing: 5,
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.storefront_outlined,
                                            color: Colors.white
                                          ),
                                          Text(
                                            'Toko',
                                            style: TextStyle(
                                              color: Colors.white
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
                  ),
                );
              }

              return SliverAppBar(
                systemOverlayStyle: const SystemUiOverlayStyle(
                  systemNavigationBarIconBrightness: Brightness.light,
                  statusBarIconBrightness: Brightness.light
                ),
                expandedHeight: 300,
                backgroundColor: Theme.of(context).primaryColor,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(20),
                  child: Container(
                    width: double.infinity,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                    ),
                  )
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Card(
                    color: Colors.transparent,
                    elevation: 0,
                    child: SafeArea(
                      minimum: const EdgeInsets.only(top: 60),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.white.withAlpha(100),
                            ),
                          ),
                          const Gap(20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 200,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white.withAlpha(100),
                                ),
                              ),
                              const Gap(5),
                              Container(
                                width: 75,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white.withAlpha(100),
                                ),
                              ),
                            ],
                          ),
                          const Gap(15),
                          Container(
                            width: 250,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white.withAlpha(100),
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                ),
              );
            },
          ),
          SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              minimum: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 0,
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
                                    onPressed: () => context.pushNamed('order', queryParameters: {'initial_index': '0'}),
                                    child: Column(
                                      children: [
                                        StreamBuilder(
                                          stream: Stream.periodic(const Duration(seconds: 1)).asyncMap((t) => getAllDataPesanan(context: context)),
                                          builder: (BuildContext context, AsyncSnapshot response){
                                            if(response.hasData){
                                              final order = json.decode(response.data.body)['data'];
                                              final orderList = [];
                                              for(int i = 0; i < order.length; i++){
                                                if(order[i]['transaksi']['status'] != 'Selesai'){
                                                  orderList.add(order[i]);
                                                }
                                              }

                                              return Badge(
                                                isLabelVisible: orderList.isNotEmpty ? true : false,
                                                label: Text(orderList.length.toString()),
                                                child: Icon(
                                                  Icons.history,
                                                  color: Theme.of(context).primaryColor,
                                                  size: 35,
                                                ),
                                              );
                                            }

                                            return Badge(
                                              isLabelVisible: false,
                                              child: Icon(
                                                Icons.history,
                                                color: Theme.of(context).primaryColor,
                                                size: 35,
                                              ),
                                            );
                                          },
                                        ),
                                        const Gap(10),
                                        const Text(
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
                                    onPressed: () => context.pushNamed('order', queryParameters: {'initial_index': '1'}),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.check_circle_outline,
                                          color: Theme.of(context).primaryColor,
                                          size: 35,
                                        ),
                                        const Gap(10),
                                        const Text(
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
                  const Gap(10),
                  const Padding(
                    padding: EdgeInsets.only(left: 10, top: 15, bottom: 5),
                    child: Text('Aktivitas Anda'),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => context.pushNamed('rate'),
                      child: Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Wrap(
                                spacing: 10,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(
                                    Icons.stars_outlined,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const Text('Penilaian Saya')
                                ],
                              ),
                              const Icon(Icons.keyboard_arrow_right)
                            ],
                          ),
                        ),
                      ),
                    )
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => context.pushNamed('favorite'),
                      child: Card(
                        elevation: 0,
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Wrap(
                                spacing: 10,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(
                                    Icons.favorite_outline,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const Text('Toko yang disukai')
                                ],
                              ),
                              const Icon(Icons.keyboard_arrow_right)
                            ],
                          ),
                        ),
                      ),
                    )
                  ),
                  const Gap(10),
                  const Padding(
                    padding: EdgeInsets.only(left: 10, top: 15, bottom: 5),
                    child: Text('Pengaturan Akun'),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => authenticator(context: context).then((res) {
                        if(res!){
                          context.goNamed('change-password');
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => const AlertDialog(
                              content: Text('Password salah!'),
                            )
                          );
                        }
                      }),
                      child: Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Wrap(
                                spacing: 10,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(
                                    Icons.password,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const Text('Ubah Kata Sandi')
                                ],
                              ),
                              const Icon(Icons.keyboard_arrow_right)
                            ],
                          ),
                        ),
                      ),
                    )
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => context.pushNamed('address'),
                      child: Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Wrap(
                                spacing: 10,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const Text('Alamat Utama')
                                ],
                              ),
                              const Icon(Icons.keyboard_arrow_right)
                            ],
                          ),
                        ),
                      ),
                    )
                  ),
                  const Gap(10),
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
                                onPressed: () => signout(context: context),
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
          ),
        ],
      ),
    );
  }
  // @override
  // Widget build(BuildContext context){
  //   return Scaffold(
  //     body: StreamBuilder(
  //       stream: Stream.periodic(const Duration(seconds: 1)).asyncMap((i) => getDataSiswa(context: context)),
  //       builder: (BuildContext context, AsyncSnapshot response){
  //         if(response.hasData){
  //           final siswa = json.decode(response.data.body)['siswa'];
  //           final kelas = json.decode(response.data.body)['kelas'];
  //           return SingleChildScrollView(
  //             child: Column(
  //               children: [
  //                 const Gap(50),
  //                 Card(
  //                   margin: const EdgeInsets.symmetric(horizontal: 16),
  //                   elevation: 0,
  //                   child: Padding(
  //                     padding: const EdgeInsets.only(top: 10),
  //                     child: Column(
  //                       children: [
  //                         GestureDetector(
  //                           onTap: () => context.pushNamed('edit-profile'),
  //                           child: CircleAvatar(
  //                             radius: 40,
  //                             backgroundImage: NetworkImage(
  //                               siswa['foto_profil'].isEmpty ? 'https://$baseUrl/images/profile.png' : 'https://$apiBaseUrl/public/${siswa['foto_profil']}'
  //                             ),
  //                           ),
  //                         ),
  //                         const Gap(20),
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: [
  //                             Text(
  //                               siswa['nama'],
  //                               style: const TextStyle(
  //                                 fontSize: 18,
  //                                 fontWeight: FontWeight.w600
  //                               ),
  //                             ),
  //                             Text(
  //                               '${siswa['nis'].toString()} | ${kelas['kelas']}',
  //                               style: const TextStyle(
  //                                 fontSize: 12
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                         const Gap(10),
  //                         IntrinsicHeight(
  //                           child: Row(
  //                             children: [
  //                               Expanded(
  //                                 child: FilledButton(
  //                                   style: const ButtonStyle(
  //                                     backgroundColor: WidgetStatePropertyAll(Colors.transparent)
  //                                   ),
  //                                   onPressed: () => context.pushNamed('edit-profile'),
  //                                   child: const Wrap(
  //                                     spacing: 5,
  //                                     crossAxisAlignment: WrapCrossAlignment.center,
  //                                     children: [
  //                                       Icon(
  //                                         Icons.person_outlined,
  //                                         color: Colors.black,
  //                                       ),
  //                                       Text(
  //                                         'Profil',
  //                                         style: TextStyle(
  //                                           color: Colors.black
  //                                         ),
  //                                       )
  //                                     ],
  //                                   )
  //                                 ),
  //                               ),
  //                               const VerticalDivider(
  //                                 thickness: .25,
  //                                 indent: 10,
  //                                 endIndent: 10,
  //                               ),
  //                               Expanded(
  //                                 child: FilledButton(
  //                                   style: const ButtonStyle(
  //                                     backgroundColor: WidgetStatePropertyAll(Colors.transparent)
  //                                   ),
  //                                   onPressed: () => context.goNamed('login-shop'),
  //                                   child: const Wrap(
  //                                     spacing: 5,
  //                                     crossAxisAlignment: WrapCrossAlignment.center,
  //                                     children: [
  //                                       Icon(
  //                                         Icons.storefront_outlined,
  //                                         color: Colors.black,
  //                                       ),
  //                                       Text(
  //                                         'Toko',
  //                                         style: TextStyle(
  //                                           color: Colors.black
  //                                         ),
  //                                       )
  //                                     ],
  //                                   )
  //                                 ),
  //                               )
  //                             ],
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   )
  //                 ),
  //                 SafeArea(
  //                   minimum: const EdgeInsets.symmetric(horizontal: 16),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       SizedBox(
  //                         width: double.infinity,
  //                         child: Card(
  //                           elevation: 0,
  //                           child: Padding(
  //                             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //                             child: Column(
  //                               children: [
  //                                 const Row(
  //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                   children: [
  //                                     Text(
  //                                       'Pesanan',
  //                                     ),
  //                                     Icon(Icons.keyboard_arrow_right)
  //                                   ],
  //                                 ),
  //                                 const Gap(10),
  //                                 Row(
  //                                   children: [
  //                                     Expanded(
  //                                       child: TextButton(
  //                                         style: const ButtonStyle(
  //                                           foregroundColor: WidgetStatePropertyAll(Colors.black),
  //                                           overlayColor: WidgetStatePropertyAll(Colors.transparent),
  //                                           shape: WidgetStatePropertyAll(RoundedRectangleBorder(
  //                                             borderRadius: BorderRadius.zero
  //                                           ))
  //                                         ),
  //                                         onPressed: () => context.pushNamed('order', queryParameters: {'initial_index': '0'}),
  //                                         child: Column(
  //                                           children: [
  //                                             Icon(
  //                                               Icons.history,
  //                                               color: Theme.of(context).primaryColor,
  //                                               size: 35,
  //                                             ),
  //                                             const Gap(10),
  //                                             const Text(
  //                                               'Diproses'
  //                                             )
  //                                           ],
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Expanded(
  //                                       child: TextButton(
  //                                         style: const ButtonStyle(
  //                                           foregroundColor: WidgetStatePropertyAll(Colors.black),
  //                                           overlayColor: WidgetStatePropertyAll(Colors.transparent),
  //                                           shape: WidgetStatePropertyAll(RoundedRectangleBorder(
  //                                             borderRadius: BorderRadius.zero
  //                                           ))
  //                                         ),
  //                                         onPressed: () => context.pushNamed('order', queryParameters: {'initial_index': '1'}),
  //                                         child: Column(
  //                                           children: [
  //                                             Icon(
  //                                               Icons.check_circle_outline,
  //                                               color: Theme.of(context).primaryColor,
  //                                               size: 35,
  //                                             ),
  //                                             const Gap(10),
  //                                             const Text(
  //                                               'Selesai'
  //                                             )
  //                                           ],
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 )
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       const Gap(10),
  //                       const Padding(
  //                         padding: EdgeInsets.only(left: 10, top: 15, bottom: 5),
  //                         child: Text('Aktivitas Anda'),
  //                       ),
  //                       SizedBox(
  //                         width: double.infinity,
  //                         child: InkWell(
  //                           borderRadius: BorderRadius.circular(10),
  //                           onTap: () => context.pushNamed('rate'),
  //                           child: Card(
  //                             color: Colors.transparent,
  //                             elevation: 0,
  //                             child: Padding(
  //                               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   Wrap(
  //                                     spacing: 10,
  //                                     crossAxisAlignment: WrapCrossAlignment.center,
  //                                     children: [
  //                                       Icon(
  //                                         Icons.stars_outlined,
  //                                         color: Theme.of(context).primaryColor,
  //                                       ),
  //                                       const Text('Penilaian Saya')
  //                                     ],
  //                                   ),
  //                                   const Icon(Icons.keyboard_arrow_right)
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         )
  //                       ),
  //                       SizedBox(
  //                         width: double.infinity,
  //                         child: InkWell(
  //                           borderRadius: BorderRadius.circular(10),
  //                           onTap: () => context.pushNamed('favorite'),
  //                           child: Card(
  //                             elevation: 0,
  //                             color: Colors.transparent,
  //                             child: Padding(
  //                               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   Wrap(
  //                                     spacing: 10,
  //                                     crossAxisAlignment: WrapCrossAlignment.center,
  //                                     children: [
  //                                       Icon(
  //                                         Icons.favorite_outline,
  //                                         color: Theme.of(context).primaryColor,
  //                                       ),
  //                                       const Text('Toko yang disukai')
  //                                     ],
  //                                   ),
  //                                   const Icon(Icons.keyboard_arrow_right)
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         )
  //                       ),
  //                       const Gap(10),
  //                       const Padding(
  //                         padding: EdgeInsets.only(left: 10, top: 15, bottom: 5),
  //                         child: Text('Pengaturan Akun'),
  //                       ),
  //                       SizedBox(
  //                         width: double.infinity,
  //                         child: InkWell(
  //                           borderRadius: BorderRadius.circular(10),
  //                           onTap: () => authenticator(context: context).then((res) {
  //                             if(res!){
  //                               context.goNamed('change-password');
  //                             } else {
  //                               showDialog(
  //                                 context: context,
  //                                 builder: (BuildContext context) => const AlertDialog(
  //                                   content: Text('Password salah!'),
  //                                 )
  //                               );
  //                             }
  //                           }),
  //                           child: Card(
  //                             color: Colors.transparent,
  //                             elevation: 0,
  //                             child: Padding(
  //                               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   Wrap(
  //                                     spacing: 10,
  //                                     crossAxisAlignment: WrapCrossAlignment.center,
  //                                     children: [
  //                                       Icon(
  //                                         Icons.password,
  //                                         color: Theme.of(context).primaryColor,
  //                                       ),
  //                                       const Text('Ubah Kata Sandi')
  //                                     ],
  //                                   ),
  //                                   const Icon(Icons.keyboard_arrow_right)
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         )
  //                       ),
  //                       SizedBox(
  //                         width: double.infinity,
  //                         child: InkWell(
  //                           borderRadius: BorderRadius.circular(10),
  //                           onTap: () => context.pushNamed('address'),
  //                           child: Card(
  //                             color: Colors.transparent,
  //                             elevation: 0,
  //                             child: Padding(
  //                               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   Wrap(
  //                                     spacing: 10,
  //                                     crossAxisAlignment: WrapCrossAlignment.center,
  //                                     children: [
  //                                       Icon(
  //                                         Icons.location_on_outlined,
  //                                         color: Theme.of(context).primaryColor,
  //                                       ),
  //                                       const Text('Alamat Utama')
  //                                     ],
  //                                   ),
  //                                   const Icon(Icons.keyboard_arrow_right)
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         )
  //                       ),
  //                       const Gap(10),
  //                       SizedBox(
  //                         width: double.infinity,
  //                         child: GestureDetector(
  //                           onTap: () => showDialog(
  //                             context: context,
  //                             builder: (BuildContext context) => AlertDialog(
  //                               content: const Text('Apakah anda yakin ingin keluar?'),
  //                               actions: [
  //                                 TextButton(
  //                                   onPressed: () => context.pop(),
  //                                   child: const Text('Batal'),
  //                                 ),
  //                                 FilledButton(
  //                                   onPressed: () => signout(context: context),
  //                                   child: const Text('Keluar'),
  //                                 )
  //                               ],
  //                             )
  //                           ),
  //                           child: Card(
  //                             color: Theme.of(context).primaryColor,
  //                             child: const Padding(
  //                               padding: EdgeInsets.all(10),
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   Text('Keluar', style: TextStyle(color: Colors.white)),
  //                                   Icon(Icons.logout, color: Colors.white)
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         )
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //                 const Gap(20),
  //               ],
  //             ),
  //           );
  //         }
  //
  //         return const Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       }
  //     )
  //   );
  // }
}