import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rickandmorty/widgets/custom_app_bar.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: "About"),
          Column(
            children: [          
              _buildText("Template inspired by:"),
              _buildText("@hicadesign"),
              _buildText("@tanahairstudio"),
              _buildText("@realvjy"),
              Divider(color: Colors.transparent),
              Divider(color: Colors.transparent),
              _buildText("Developed by:"),
              _buildText("@viniciusandd"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildText(String text) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontSize: 20
      ),
    );
  }
}