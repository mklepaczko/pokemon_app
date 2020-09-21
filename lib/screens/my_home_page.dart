import 'package:flutter/material.dart';
import 'package:pokemon_app/globals.dart';
import 'package:pokemon_app/widgets/poke_image_widget.dart';

import '../models/pokemon_list_model.dart';
import '../models/pokemon_detail_model.dart';
import '../api/poke_api.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();  
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;
  int _offset = 0;
  List<Pokemon> pokemonList = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _offset = _offset + POKE_PER_PAGE_VALUE;
        downloadPokemonList(_offset);
      }
      if (_scrollController.position.pixels == _scrollController.position.minScrollExtent && _offset > 0) {
        _offset = _offset - POKE_PER_PAGE_VALUE;
        downloadPokemonList(_offset);
      }
    });
    downloadPokemonList();
    super.initState();
  }

  downloadPokemonList([int offset]) async{
    setState(() {
      _isLoading = true;      
    });
    pokemonList = await pokeApi.getPokemonList(offset);
    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) return Scaffold(body: Center(child: CircularProgressIndicator()),);

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,),
      body: GridView.count(
        controller: _scrollController,
        crossAxisCount: 3,
        children: listOfPokemonWidgets(pokemonList),
      ),
      
    );
  }

  List<Widget> listOfPokemonWidgets (List<Pokemon> pokemonList){
    List<Widget> _list = [];
    pokemonList.forEach((element) {
      _list.add(pokeWidget(element));
    });
    return _list;
      
  }

  Widget pokeWidget (Pokemon pokemon) {
    return Center(
      child: Card(
        child: Column(
          children: [
            PokeImage(pokemon),
            Text(pokemon.name),
            SizedBox(width: double.infinity),
          ],
        ),  
      )
    );
  }  
}

