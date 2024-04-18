import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget{
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // List<String> history = ['Ayam goreng', 'Seblak', 'Pecel lele', 'Es teh manis', 'Roti goreng'];
  final _formKeyField = GlobalKey<FormFieldState>();
  String _search = '';
  List<Widget> actionChip = [];

  @override
  void initState() {
    super.initState();
    _searchingHistory().then((value) => setState(() {
      actionChip = value;
    }));
  }

  void _setSearchHistory(String searchData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? searchingHistory = prefs.getStringList('searchingHistory');
    searchingHistory!.add(searchData);

    prefs.setStringList('searchingHistory', searchingHistory);
  }

  void _deleteLastIndexSearchingHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? searchingHistory = prefs.getStringList('searchingHistory');
    searchingHistory!.removeAt(0);

    prefs.setStringList('searchingHistory', searchingHistory);
  }

  Future<List<String>?> _getSearchHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? searchData = prefs.getStringList('searchingHistory');
    searchData ??= [];

    return searchData;
  }

  void _submit(BuildContext context) async {
    _formKeyField.currentState!.save();
    List<String>? getSearchHistory = await _getSearchHistory();
    if(!getSearchHistory!.contains(_search)){
      setState(() {
        _setSearchHistory(_search);
        if(getSearchHistory.length > 10){
          _deleteLastIndexSearchingHistory();
        }
      });
    }
    if(!context.mounted) return;
    context.goNamed('searchResult', queryParameters: {'search': _search});
  }

  Future<List<Widget>> _searchingHistory() async {
    List<String>? getSearchHistory = await _getSearchHistory();
    List<String> searchHistory = getSearchHistory!.reversed.toList();
    List<Widget> actionChip = [];
    for(int i = 0; i < searchHistory.length; i++){
      actionChip.add(ActionChip(
        onPressed: (){
          context.pushNamed('searchResult', queryParameters: {'search': searchHistory[i]});
        },
        label: Text(
          searchHistory[i]
        ),
        labelStyle: const TextStyle(
            color: Colors.white
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide.none,
        backgroundColor: const Color.fromARGB(255, 253, 143, 24),
      ));
    }

    return actionChip;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).primaryColor,
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
              onEditingComplete: (){_submit(context);},
            ),
          )
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Riwayat penelusuran",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
            ),
            const Gap(5),
            Wrap(
              spacing: 5,
              children: actionChip,
            )
          ],
        ),
      )
    );
  }
}