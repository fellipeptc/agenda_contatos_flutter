import 'package:agenda_contato/ui/home_page.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        hintColor: Colors.redAccent,
        inputDecorationTheme: InputDecorationTheme(
          //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          //focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
          hintStyle: TextStyle(color: Colors.white),
        )),
  ));
}
