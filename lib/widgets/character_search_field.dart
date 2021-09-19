import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CharacterSearchField extends StatelessWidget {

  final Function(String) onChanged;

  const CharacterSearchField({
    Key? key,
    required this.onChanged
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: TextField(
        cursorColor: Colors.black,
        decoration: InputDecoration(
          hintText: "Search characters",
          hintStyle: GoogleFonts.montserrat(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.grey)
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.grey)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.grey)
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            color: Colors.grey,
            onPressed: () {},
          )
        ),
        onChanged: (text) => onChanged(text),
      ),
    );
  }
}