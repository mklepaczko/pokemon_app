import 'package:flutter/material.dart';

import '../globals.dart';
import '../models/pokemon_detail_model.dart';
import '../screens/poke_details.dart';
import '../api/poke_api.dart';
import '../models/pokemon_list_model.dart';

class PokeImage extends StatefulWidget {
    final Pokemon pokemon;

    PokeImage(
      this.pokemon,
      Key key
      ) : super(key: key);

    @override
    _PokeImageState createState() => _PokeImageState();
  }
  
  class _PokeImageState extends State<PokeImage> {
    bool _isLoading = false;
    PokemonDetails pokeDetails;
    String imageUrl;
    

    @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    getPokeDetails(widget.pokemon);
    super.initState();
  }

  // Generates all the API calls to fetch image url. To be checked if not a common url pattern to avoid calls

  getPokeDetails(Pokemon pokemon) async{
    pokeDetails = await pokeApi.getPokemon(widget.pokemon);
    imageUrl = pokeDetails?.sprites?.frontDefault;
    if (mounted) setState(() {
      _isLoading = false;
    });
  }

    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PokeDetailPage(pokeDetails)));
        },
        child: CircleAvatar(
          radius: 40,
          backgroundColor: Theme.of(context).primaryColor,
          backgroundImage: (_isLoading || imageUrl == null)
            ? AssetImage(ASSETS_DEFAULT_IMAGE)
            : NetworkImage(imageUrl),
        ),
      );
    }
  }