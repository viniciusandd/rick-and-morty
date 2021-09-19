import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:rickandmorty/api/custom_exceptions.dart';
import 'package:rickandmorty/api/resources/base.dart';
import 'package:rickandmorty/api/resources/character_resource.dart';
import 'package:rickandmorty/api/resources/episode_resource.dart';
import 'package:rickandmorty/api/responses/character_response.dart';
import 'package:rickandmorty/api/responses/episode_response.dart';
import 'package:rickandmorty/models/character_model.dart';
import 'package:rickandmorty/models/episode_model.dart';
import 'package:rickandmorty/widgets/character_search_field.dart';
import 'package:rickandmorty/widgets/custom_app_bar.dart';

class EpisodesPage extends StatefulWidget {
  
  const EpisodesPage({ Key? key }) : super(key: key);

  @override
  _EpisodesPageState createState() => _EpisodesPageState();
}

class _EpisodesPageState extends State<EpisodesPage> {

  Future<List<CharacterModel>>? _characters;
  Future<List<EpisodeModel>>? _episodes;

  void _getCharacters([String? name]) {
    CharacterResource characterResource = CharacterResource(Base(http.Client()));
    _characters = characterResource.getCharacters(name).then((response) {
      List<CharacterModel> characters = [];
      for (CharacterResponse c in response) {
        characters.add(CharacterModel(
          image: c.image,
          name: c.name,
          status: c.status,
          gender: c.gender,
          episode: c.episode
        ));
      }    
      return characters;
    });
  }

  void _getEpisodes(List<String> ids) {
    EpisodeResource episodeResource = EpisodeResource(Base(http.Client()));
    _episodes = episodeResource.getEpisodes(ids).then((response) {
    List<EpisodeModel> episodes = [];
      for (EpisodeResponse e in response) {
        episodes.add(EpisodeModel(
          episode: e.episode, 
          name: e.name, 
          airDate: e.airDate
        ));
      }    
      return episodes;
    });    
  }

  @override
  void initState() {
    super.initState();
    _getCharacters();
  }

  void searchCharacterByName(String name) {
    setState(() {
      _getCharacters(name);
    });
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomAppBar(title: "Episodes"),
          CharacterSearchField(onChanged: searchCharacterByName),
          _buildCharactersFutureBuilder(),          
        ],
      ),
    );
  }

  FutureBuilder<List<CharacterModel>> _buildCharactersFutureBuilder() {
    return FutureBuilder<List<CharacterModel>>(
      future: _characters,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (snapshot.hasData) {
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          CharacterModel characterModel = snapshot.data![index];
                          return GestureDetector(
                            child: Tooltip(
                              message: characterModel.name,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 30,
                                  child: ClipOval(
                                    child: Image.network(
                                      characterModel.image,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {        
                              setState(() {
                                List<String> ids = [];
                                for (String e in characterModel.episode) {
                                  ids.add(e.substring(40));
                                }                                  
                                _getEpisodes(ids);
                              });
                            },
                          );
                        },
                      ),
                    ),
                    _buildEpisodesFutureBuilder(),
                  ],
                ),
              );
            } else {
              late List<Widget> children;
              if (snapshot.error is NoConnectionException) {
                children = [
                  SvgPicture.asset("assets/images/no_connection.svg"),
                  Text(
                    "No connection was detected :(",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 18
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _getCharacters();
                      });
                    }, 
                    child: Text(
                      "Retry",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  )
                ];
              } else if (snapshot.error is NoInternetException) {
                children = [
                  SvgPicture.asset("assets/images/no_internet.svg"),
                  Text(
                    "No internet connection :(",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 18
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _getCharacters();
                      });
                    }, 
                    child: Text(
                      "Retry",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  )
                ];
              } else if (snapshot.error is NotFoundException) {
                children = [
                  SvgPicture.asset("assets/images/notfounderror.svg"),
                  Text(
                    "No characters found :(",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 18
                    ),
                  ),
                ];
              } else {
                children = [
                  SvgPicture.asset("assets/images/unexpectederror.svg"),
                  Text(
                    "An unexpected error occurred :O",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 18
                    ),
                  ),
                ];                      
              }
              return Expanded(
                child: ListView(children: children),
              );
            }
        }
      }
    );
  }

  FutureBuilder<List<EpisodeModel>> _buildEpisodesFutureBuilder() {
    return FutureBuilder<List<EpisodeModel>>(
      future: _episodes,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case ConnectionState.none:
            return Expanded(
              child: Center(
                child: Text(
                  "Select a character :)",
                  style: GoogleFonts.montserrat(
                    fontSize: 20
                  ),
                ),
              ),
            );
          default:
            if (snapshot.hasData) {
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].episode),
                      subtitle: Text(snapshot.data![index].name),
                      trailing: Text(snapshot.data![index].airDate),
                    );
                  }
                ),
              );
            } else {
              return Expanded(
                child: Center(
                  child: Text(
                    "An unexpected error occurred :O",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 18
                    ),
                  ),
                ),
              );
            }
        }
      }
    );
  }  
}