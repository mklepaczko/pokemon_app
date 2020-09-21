import 'package:flutter/material.dart';
import 'package:pokemon_app/globals.dart';

import '../api/poke_api.dart';
import '../models/pokemon_list_model.dart';

class PokeImage extends StatefulWidget {
    final Pokemon _pokemon;

    PokeImage(this._pokemon);

    @override
    _PokeImageState createState() => _PokeImageState();
  }
  
  class _PokeImageState extends State<PokeImage> {
    bool _isLoading = false;
    String imageUrl;
    

    @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    getImage(widget._pokemon);
    super.initState();
  }

  getImage(Pokemon pokemon) async{
    imageUrl = await pokeApi.getPokemonImage(widget._pokemon);
    if (mounted) setState(() {
      _isLoading = false;
    });
  }

    @override
    Widget build(BuildContext context) {
      return CircleAvatar(
        radius: 40,
        backgroundColor: Colors.white,
        backgroundImage: (_isLoading)
          ? AssetImage(ASSETS_SOWA_IMAGE)
          : NetworkImage(imageUrl),
      );
    }
  }