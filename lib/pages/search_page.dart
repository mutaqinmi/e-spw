import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget{
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKeyField = GlobalKey<FormFieldState>();
  List<Widget> actionChip = [];

  @override
  void dispose() {
    super.dispose();
    _formKeyField.currentState!.dispose();
  }

  @override
  void initState(){
    super.initState();
    _searchingHistory().then((value) => setState(() {
      actionChip = value;
    }));
  }

  Future<List<String>?> _getSearchHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? searchData = prefs.getStringList('searchingHistory');
    searchData ??= [];

    return searchData;
  }

  void _setSearchHistory(String searchData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? searchingHistory = await _getSearchHistory();
    searchingHistory!.add(searchData);

    prefs.setStringList('searchingHistory', searchingHistory);
  }

  void _deleteLastIndexSearchingHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? searchingHistory = prefs.getStringList('searchingHistory');
    searchingHistory!.removeAt(0);

    prefs.setStringList('searchingHistory', searchingHistory);
  }

  void _reorderSearch(searchData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? searchingHistory = prefs.getStringList('searchingHistory');
    searchingHistory!.removeAt(searchingHistory.indexOf(searchData));
    searchingHistory.add(searchData);

    prefs.setStringList('searchingHistory', searchingHistory);
  }

  Future<List<Widget>> _searchingHistory() async {
    List<String>? getSearchHistory = await _getSearchHistory();
    List<String> searchHistory = getSearchHistory!.reversed.toList();
    List<Widget> actionChip = [];
    for(int i = 0; i < searchHistory.length; i++){
      actionChip.add(ActionChip(
        onPressed: (){
          _reorderSearch(searchHistory[i]);
          context.goNamed('searchResult', queryParameters: {'search': searchHistory[i]});
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

  void _deleteSearchingHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Apakah anda yakin ingin menghapus riwayat penelusuran?'),
        actions: [
          TextButton(
            onPressed: (){
              context.pop();
            },
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => setState(() {
              prefs.remove('searchingHistory');
              actionChip = [];
              context.pop();
            }),
            child: const Text('Hapus'),
          ),
        ],
      )
    );
  }

  void _submit(String keywords) async {
    List<String>? getSearchHistory = await _getSearchHistory();
    if(keywords.isNotEmpty){
      if(!getSearchHistory!.contains(keywords)){
        _setSearchHistory(keywords);
        _searchingHistory().then((value) => setState(() {
          actionChip = value;
        }));
        if(getSearchHistory.length > 10){
          _deleteLastIndexSearchingHistory();
        }
      } else {
        _reorderSearch(keywords);
      }
      if(!mounted) return;
      context.goNamed('searchResult', queryParameters: {'search': keywords});
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 40,
          child: Form(
            child: TextFormField(
              key: _formKeyField,
              textInputAction: TextInputAction.search,
              autofocus: true,
              style: const TextStyle(
                fontSize: 14
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                hintText: 'Telusuri produk atau toko ...',
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                suffixIcon: const Icon(Icons.search)
              ),
              onFieldSubmitted: (value) => _submit(value),
            ),
          )
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Riwayat penelusuran",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600
                  ),
                ),
                IconButton(
                  onPressed: () => _deleteSearchingHistory(),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                )
              ],
            ),
            Wrap(
              spacing: 5,
              children: actionChip,
            ),
            Visibility(
              visible: actionChip.isEmpty ? true : false,
              child: Center(
                child: Column(
                  children: [
                    const Gap(20),
                    Image.asset(
                      'assets/image/searching-history.png',
                      width: 250,
                    ),
                    const Text(
                      'Anda belum menelusuri apapun.',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic
                      ),
                    )
                  ],
                )
              ),
            )
          ],
        ),
      )
    );
  }
}