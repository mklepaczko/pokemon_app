import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_app/globals.dart';
import 'package:pokemon_app/helpers/search_by_name.dart';
import 'package:pokemon_app/widgets/poke_image_widget.dart';

import '../models/pokemon_list_model.dart';
import '../api/poke_api.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();  
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;
  bool _isUpdating = false;
  int _items = POKE_PER_PAGE_VALUE;
  List<Pokemon> pokemonFullList = [];
  List<Pokemon> pokemonPartialList = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent
          && pokemonPartialList.length < pokemonFullList.length) {
        updateList();
      }

    });
    downloadPokemonList();
    
    super.initState();
  }

  downloadPokemonList() async{
    setState(() {
      _isLoading = true;
    });

    // The API does not have a search method so we need to fetch all and search then
    // if search was not needed we could only fetch a partial list    

    pokemonFullList = await pokeApi.getPokemonList();   
    pokemonPartialList = [...pokemonFullList.take(_items)];
    setState(() {                                       
      _isLoading = false;
    });
  }
  updateList(){
    setState(() {
      _isUpdating = true;
    });
    _items = _items + POKE_PER_PAGE_VALUE;
    pokemonPartialList = [...pokemonFullList.take(_items)];
    Timer(Duration(seconds: 1), () {
      setState(() {
      _isUpdating = false;
    });
    }); 
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) return Scaffold(body: Center(child: CircularProgressIndicator()),);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.search, color: Theme.of(context).primaryColor),
              Container(
                width: MediaQuery.of(context).size.width -150,
                child: SearchByName(
                  pokemonList: pokemonFullList, 
                  onSubmited: (String name) {
                    setState(() {
                      print(name);
                      pokemonPartialList = [pokemonFullList.firstWhere(
                        (element) => element?.name == name,
                        orElse: () => null)];
                    });
                  }),
              ),
              IconButton(
                icon: Icon(Icons.cancel, color: Theme.of(context).primaryColor), 
                onPressed: () {
                  setState(() {
                    pokemonPartialList = [...pokemonFullList.take(_items)];
                  });
                })
            ],
          ),
        ),
      body: pokemonGridList(),
      bottomNavigationBar: bottomBar(),
    );
  }

  Widget pokemonGridList(){
    if (pokemonPartialList[0] == null)
      return Center(child: Text('No pokemons'));
    
    return GridView.count(
      controller: _scrollController,
      crossAxisCount: 3,
      children: listOfPokemonWidgets(pokemonPartialList),
        
    );
  }

  Widget bottomBar() {
    if (pokemonPartialList.length < pokemonFullList.length && _isUpdating) 
      return Container(
        height: 70,
        child: Center(child: CircularProgressIndicator(),
        ),
      );
    if (_isUpdating)
      return Padding(
        padding:  EdgeInsets.symmetric(vertical: 32.0),
        child: Text('No more data')
      );
    return SizedBox();
      
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
      key: ValueKey(pokemon.name),
      child: Card(
        child: Column(
          children: [
            PokeImage(pokemon, ValueKey(pokemon.name)),
            Text(pokemon.name),
            SizedBox(width: double.infinity),
          ],
        ),  
      )
    );
  }  
}

