import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget {

  final String title;

  CustomAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 50, 30, 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 12,),
            onPressed: () {
              Navigator.pop(context);
            }
          ),
          Text(
            this.title,
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              )
            )
          ),                
          Container(width: 32.0, height: 0.0),
        ],
      ),
    );
  }
}