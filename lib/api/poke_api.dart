import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/pokemon_list_model.dart';
import '../globals.dart';
import '../models/pokemon_detail_model.dart';

const bool _debug = true;

class PokeApi{

  Future<List<Pokemon>> getPokemonList([int offset]) async {
    final String listUrl = POKE_API_BASE_URL + POKE_API_POKEMON_PATH;
    final int pokePerPage = POKE_PER_PAGE_VALUE;
    var response;

    try{
      response = await http.get('$listUrl?limit=$pokePerPage&offset=$offset');
    }catch(error){
    if (_debug) print(error);
    }
    final decodedList = jsonDecode(response.body);
    if (_debug) print(decodedList);
  return List.from(decodedList['results'].map((item) => Pokemon.fromJson(item)));

  }

  Future<String> getPokemonImage(Pokemon pokemon) async{
    var response;
    try{
      response = await http.get(pokemon.url);
    }catch(error){
      if (_debug) print(error);
    }
    final decodedResponse = jsonDecode(response.body);
    return PokemonDetails.fromJson(decodedResponse).sprites.frontDefault;
  }
}

final pokeApi = PokeApi();