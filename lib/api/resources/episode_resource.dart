import 'package:rickandmorty/api/resources/base.dart';
import 'package:rickandmorty/api/responses/episode_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EpisodeResource {
  final String _endpoint = "api/episode";
  final Base _base;

  EpisodeResource(this._base);

  Future<List<EpisodeResponse>> getEpisodes(List ids) async {
    String parameters = ids.join(",");

    http.Response response = await this._base.get(
      "$_endpoint/$parameters"
    );

    List<dynamic> responseBody = ids.length > 1 
        ? jsonDecode(response.body) 
        : [jsonDecode(response.body)];
    
    List<EpisodeResponse> episodes = [];
    for (dynamic episode in responseBody) {
      episodes.add(EpisodeResponse.fromJson(episode));
    }

    return episodes;    
  }
}