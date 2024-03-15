import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget{
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: AppBar(
            leading: IconButton(
              onPressed: (){
                context.pop();
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            title: SizedBox(
              width: double.infinity,
              height: 40,
              child: TextField(
                autofocus: true,
                style: const TextStyle(
                  fontSize: 14
                ),
                decoration: InputDecoration(
                  hintText: 'Cari ...',
                  hintStyle: const TextStyle(
                    fontSize: 14
                  ),
                  suffixIcon: IconButton(
                    onPressed: (){},
                    icon: const Icon(Icons.search_rounded),
                  ),
                ),
              ),
            ),
          ),
        )
      ),
    );
  }
}