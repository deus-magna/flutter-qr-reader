import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/screens/home_screen.dart';
import 'package:qrreaderapp/src/screens/map_screen.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      routes: {
        'home' : (BuildContext context) => HomeScreen(),
        'map' : (BuildContext context) => MapScreen(),
      },
      theme: ThemeData(
        primaryColor: Colors.deepPurple
      ),
    );
  }
}