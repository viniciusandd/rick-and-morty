import 'package:rickandmorty/api/resources/base.dart';
import 'package:rickandmorty/api/responses/character_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CharacterResource {
  final String _endpoint = "api/character";
  final Base _base;

  CharacterResource(this._base);

  Future<List<CharacterResponse>> getCharacters([String? name]) async {
    String parameter = name != null ? "?name=$name" : "";
    http.Response response = await this._base.get("$_endpoint$parameter");
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    List<CharacterResponse> characters = [];
    for (Map<String, dynamic> character in responseBody["results"]) {
      characters.add(CharacterResponse.fromJson(character));
    }
    return characters;
  }
}