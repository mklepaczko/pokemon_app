import 'package:flutter/material.dart';

import '../models/pokemon_detail_model.dart';
import '../globals.dart';

class PokeDetailPage extends StatelessWidget {
  final PokemonDetails pokeDetails;

  PokeDetailPage(this.pokeDetails);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          pokeDetails.name, 
          style: TextStyle(color: Theme.of(context).primaryColor)),
        backgroundColor: Theme.of(context).accentColor,
        ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: MediaQuery.of(context).size.width),
          CircleAvatar(
            radius: 150,
            backgroundColor: Theme.of(context).primaryColor,
            backgroundImage: (pokeDetails.sprites.frontDefault == null)
              ? AssetImage(ASSETS_DEFAULT_IMAGE)
              : NetworkImage(pokeDetails.sprites.frontDefault),
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.yellow[700],
            ),
            width: 300,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:[
                      detailTexts(context, 'Height', '${pokeDetails.height.toString()} ft'),
                      detailTexts(context, 'Weight', '${pokeDetails.weight.toString()} lbs'),
                    ]
                  ),
                ],),
            )
          )
        ]
      ),
      
    );
  }
  Widget detailTexts (BuildContext context, String title, String text)  {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 14,
            fontStyle: FontStyle.italic,            
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          )
        )
      ]
    );
  }
}