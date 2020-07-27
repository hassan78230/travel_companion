import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:travel_companion/model/Place.dart';
import 'package:travel_companion/model/Trip.dart';

import 'date_view.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class NewTripLocationView extends StatefulWidget {
  final Trip trip;

  NewTripLocationView({Key key, @required this.trip}) : super(key: key);

  @override
  _NewTripLocationViewState createState() => _NewTripLocationViewState();
}

class _NewTripLocationViewState extends State<NewTripLocationView> {
  TextEditingController _searchController = TextEditingController();
  Timer _thottle;
  String _heading;
  List<Place> _placesList;
  final List<Place> _suggestedList = [
    Place("Coignieres", 320),
    Place("paris", 320),
    Place("marseille", 320),
    Place("menuires", 320),
    Place("Cergy", 320),
  ];

  @override
  void initState() {
    super.initState();
    _heading = 'Suggestions';
    _placesList = _suggestedList;
    _searchController.addListener(_onSearchChanged);
  }


  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged(){
    if(_thottle?.isActive??false) _thottle.cancel();
    _thottle = Timer(const Duration(milliseconds: 300), (){
      getLocationResults(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {

    /*_titleController.text = widget.trip.title;*/
    return Scaffold(
      appBar: AppBar(
        title: Text('Create trip location'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                ),

              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: DividerWithText(
                dividerText: _heading,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _placesList.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildPlaceCard(context, index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPlaceCard(BuildContext context, int index) {
    return Hero(
      tag: "SelectedTrip-${_placesList[index].name}",
      transitionOnUserGestures: true,

      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8,
            right: 8,
          ),
          child: Card(
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: AutoSizeText(
                                  _placesList[index].name,
                                  maxLines: 3,
                                  style: TextStyle(fontSize: 25.0),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "Average budget \$${_placesList[index].averageBudget.toStringAsFixed(1)}",

                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Placeholder(
                        fallbackHeight: 80,
                        fallbackWidth: 80,
                      )
                    ],
                  ),
                ],
              ),
              onTap: (){widget.trip.title = _placesList[index].name;
                Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => NewTripDateView(trip: widget.trip)),
                );}
            ),
          ),
        ),
      ),
    );
  }

  void getLocationResults(String input) async{
    if(input.isEmpty){
      setState(() {
        _heading="Suggestions";
      });
      return;
    }
    String baseURL = "https://geo.api.gouv.fr/communes?fields=nom&format=json&&boost=population&geometry=centre&limit=5";
    String request = "$baseURL&nom=$input";
    Response response = await Dio().get(request);
    final predicions = response.data;
    List<Place> _displaysResult = [];

    for(var i=0;i<predicions.length;i++){
      String name = predicions[i]['nom'];
      double averageBudget = 200.0;
      _displaysResult.add(Place(name, averageBudget));
    }

    print(predicions);
    setState(() {
      _heading = "Results";
      _placesList = _displaysResult;
    });
  }
}

class DividerWithText extends StatelessWidget {
  final String dividerText;
  const DividerWithText({
    Key key,
    this.dividerText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Divider(),
        )),
        Text(dividerText),
        Divider(),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Divider(),
        )),
      ],
    );
  }
}
