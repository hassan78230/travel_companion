import 'package:flutter/material.dart';
import 'file:///C:/Users/HASSAN/AndroidStudioProjects/travel_companion/lib/views/first_view.dart';

import 'home_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Companion',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FirstView(),
      routes: <String,WidgetBuilder>{
        '/signUp': (BuildContext context) => Home(),
        '/home': (BuildContext context) => Home(),
      },
    );
  }
}
