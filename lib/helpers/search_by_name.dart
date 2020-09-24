import 'package:flutter/material.dart';

import '../models/pokemon_list_model.dart';


class SearchByName extends StatefulWidget {
  final List<Pokemon> pokemonList;

  final Function(String) onSubmited;

  SearchByName({
    @required this.pokemonList,
    @required this.onSubmited,
  });

  @override
  _SearchByNameState createState() => _SearchByNameState();
}

class _SearchByNameState extends State<SearchByName> {
  final _form = GlobalKey<FormState>();
  String name;

  void _saveForm() async{
    final _isValid = _form.currentState.validate();
    if (!_isValid) {
      return;
    }
    _form.currentState.save();    
    widget.onSubmited(name);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
            key: _form,
            child: TextFormField(
              style: TextStyle(color: Theme.of(context).primaryColor),
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: 'Search by name',
                hintStyle: TextStyle(color: Theme.of(context).primaryColor)),
              onSaved: (value) {
                name = value;
              },
              onFieldSubmitted: (_) {
                _saveForm();
              },
            ))

    );
  }
}