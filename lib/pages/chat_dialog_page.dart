import 'package:cached_network_image/cached_network_image.dart';
import 'package:espw/app/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class Chat extends StatefulWidget{
  const Chat({super.key, this.chatID});
  final String? chatID;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat>{
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
        foregroundColor: Theme.of(context).primaryColor,
        title: Wrap(
          spacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            CircleAvatar(
              radius: 15,
              backgroundImage: CachedNetworkImageProvider(
                shopList[0]['profile_picture']
              ),
            ),
            Text(
              shopList[0]['name'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
            )
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              context.pushNamed('shop');
            },
            icon: Icon(Icons.storefront_outlined, color: Theme.of(context).primaryColor),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.grey.withAlpha(50)
              )
            ]
          ),
          child: Row(
            children: [
              const Expanded(
                child: TextField(
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    hintText: 'Ketik pesan ...'
                  ),
                ),
              ),
              const Gap(10),
              IconButton(
                onPressed: (){},
                icon: const Icon(Icons.send),
                iconSize: 18,
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
                  foregroundColor: const MaterialStatePropertyAll(Colors.white)
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}