import 'package:cached_network_image/cached_network_image.dart';
import 'package:espw/app/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ChatPage extends StatefulWidget{
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>{
  late List<Map> shopList;
  @override
  void initState() {
    super.initState();
    shopList = shop;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index){
          return SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: GestureDetector(
              onTap: (){
                context.pushNamed('chat');
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent
                ),
                width: double.infinity,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        shopList[0]['profile_picture'],
                      ),
                      radius: 25,
                    ),
                    const Gap(15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                shopList[0]['name'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                              const Text(
                                '18.20',
                                style: TextStyle(
                                  fontSize: 12
                                ),
                              )
                            ],
                          ),
                          const Gap(5),
                          const Wrap(
                            spacing: 5,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Icon(Icons.check, color: Colors.grey, size: 14),
                              Text(
                                'Halo Kak, apakah barangnya ready?',
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          );
        },
      ),
    );
  }
}