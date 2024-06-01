import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:espw/app/controllers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MemberPage extends StatefulWidget{
  const MemberPage({super.key, required this.idToko});
  final String idToko;

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(),
          const SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              minimum: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Anggota',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Text(
                    'Daftar anggota di toko ini.'
                  )
                ],
              ),
            )
          ),
          FutureBuilder(
            future: getAllDataKelompok(widget.idToko),
            builder: (BuildContext context, AsyncSnapshot response){
              if(response.connectionState == ConnectionState.done){
                final kelompok = json.decode(response.data.body)['data'];
                return SliverList.builder(
                  itemCount: kelompok.length,
                  itemBuilder: (BuildContext context, int index){
                    final kelompok = json.decode(response.data.body)['data'][index];
                    return SafeArea(
                      minimum: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: CachedNetworkImageProvider(
                              'https://$baseUrl/assets/${kelompok['siswa']['foto_profil'].isEmpty ? 'images/profile.png' : 'public/${kelompok['siswa']['foto_profil']}'}'
                            ),
                          ),
                          const Gap(10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  kelompok['siswa']['nama'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                                Text(
                                  kelompok['siswa']['nis'].toString()
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }

              return const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}