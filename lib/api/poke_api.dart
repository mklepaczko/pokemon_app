import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/pokemon_list_model.dart';
import '../globals.dart';
import '../models/pokemon_detail_model.dart';

const bool _debug = true;
const String decodeResult = 'results';

class PokeApi{

  Future<List<Pokemon>> getPokemonList() async {
    final String listUrl = POKE_API_BASE_URL + POKE_API_POKEMON_PATH;
    var response;

      // If limit is not set API returns 20 records. There is no call to return all pokemons
      // so limit should be above total number of pokes
      // As an enhancement we could check if total pokomons == limit and change limit accordingly

    try{
      response = await http.get('$listUrl?limit=$TOTAL_POKES_IN_API');
    }catch(error){
    if (_debug) print(error);
    }
    if (response == null) return null;

    final Map decodedList = jsonDecode(response.body);
    if (_debug) print('There are ${decodedList[decodeResult].length} pokemons in the API');
  return List.from(decodedList[decodeResult].map((item) => Pokemon.fromJson(item)));

  }

  Future<PokemonDetails> getPokemon(Pokemon pokemon) async{
    var response;
    try{
      response = await http.get(pokemon.url);
    }catch(error){
      if (_debug) print(error);
    }
    if (response == null) return null;

    final Map decodedResponse = jsonDecode(response.body);    
    return PokemonDetails.fromJson(decodedResponse);
  }
}

final pokeApi = PokeApi();