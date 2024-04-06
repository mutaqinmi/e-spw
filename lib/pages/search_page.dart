import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget{
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKeyField = GlobalKey<FormFieldState>();
  String _search = '';

  void _submit(){
    _formKeyField.currentState!.save();
    context.pushNamed('searchResult', queryParameters: {'search': _search});
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            foregroundColor: Theme.of(context).primaryColor,
            pinned: true,
            title: SizedBox(
              height: 40,
              child: Form(
                child: TextFormField(
                  key: _formKeyField,
                  autofocus: true,
                  style: const TextStyle(
                    fontSize: 14
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    hintText: 'Telusuri produk ...',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    suffixIcon: const Icon(Icons.search)
                  ),
                  onSaved: (value){_search = value!;},
                  onEditingComplete: (){_submit();},
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}