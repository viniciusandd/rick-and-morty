import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rickandmorty/pages/about_page.dart';
import 'package:rickandmorty/pages/characters_page.dart';
import 'package:rickandmorty/pages/episodes_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 50),
              child: _buildText("Home", 24),
            ),
            _buildTextButtonWithPadding(context, "Characters", CharactersPage()),
            _buildTextButtonWithPadding(context, "Episodes", EpisodesPage()),
            _buildTextButtonWithPadding(context, "About", AboutPage()),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildText("r&m", 21),
                    _buildText("1.0", 21),
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }

  Text _buildText(String title, int fontSize) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: GoogleFonts.montserrat(
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 24
      ),
    );
  }

  Padding _buildTextButtonWithPadding(
    BuildContext context, 
    String title,
    Widget page
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextButton(
        child: Text(
          title,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 44
          ),
        ),
        style: ButtonStyle(
          overlayColor: MaterialStateColor.resolveWith((states) => Colors.orange),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page)
          );
        },
      ),
    );
  }
}