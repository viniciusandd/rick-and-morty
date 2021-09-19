import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:rickandmorty/api/custom_exceptions.dart';
import 'package:rickandmorty/api/resources/base.dart';
import 'package:rickandmorty/api/resources/character_resource.dart';
import 'package:rickandmorty/api/responses/character_response.dart';
import 'package:rickandmorty/models/character_model.dart';
import 'package:rickandmorty/widgets/custom_app_bar.dart';
import 'package:rickandmorty/widgets/character_search_field.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({Key? key}) : super(key: key);

  @override
  _CharactersPageState createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  Future<List<CharacterModel>>? _characters;


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
          episode: c.episode,
        ));
      }    
      return characters;
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomAppBar(title: "Characters"),
          CharacterSearchField(onChanged: searchCharacterByName),
          FutureBuilder<List<CharacterModel>>(
            future: _characters,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                default:
                  if (snapshot.hasData) {        
                    return Expanded(child: _buildListView(snapshot));
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
            },
          ),
        ],
      ),
    );
  }

  ListView _buildListView(AsyncSnapshot<List<CharacterModel>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        CharacterModel characterModel = snapshot.data![index];
        return ListTile(
          title: Text(
            characterModel.name,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),
          subtitle: Text(
            characterModel.status,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.normal
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(characterModel.image),
            backgroundColor: Colors.transparent,
            radius: 25,
          ),
          trailing: Text(
            characterModel.gender,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.normal
            ),
          ),
        );
      }
    );
  }
}
