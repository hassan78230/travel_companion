import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_companion/model/Trip.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

import 'budget_view.dart';

class NewTripDateView extends StatefulWidget {
  final Trip trip;

  NewTripDateView({Key key, @required this.trip}) : super(key: key);

  @override
  _NewTripDateViewState createState() => _NewTripDateViewState();
}

class _NewTripDateViewState extends State<NewTripDateView> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 7));

  Future displayDateRangePicker(BuildContext context) async {
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: _startDate,
        initialLastDate: _endDate,
        firstDate: new DateTime(DateTime.now().year - 50),
        lastDate: new DateTime(DateTime.now().year + 50));
    if (picked != null && picked.length == 2) {
      setState(() {
        _startDate = picked[0];
        _endDate = picked[1];
      });
    }
  }

  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create trip Date'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Location ${widget.trip.title}'),
            RaisedButton(
              onPressed: () async {
                displayDateRangePicker(context);
              },
              child: Text('Select Dates'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Start date: ${DateFormat('dd/MM/yyyy').format(_startDate).toString()}'),
                Text('End date: ${DateFormat('dd/MM/yyyy').format(_endDate).toString()}'),
              ],
            ),
            RaisedButton(
                child: Text('Continue'),
                onPressed: () {
                  widget.trip.startDate = _startDate;
                  widget.trip.endDate = _endDate;
                  Navigator.push(
                    //TODO save to firebase
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NewTripBudgetView(trip: widget.trip)),
                  );
                })
          ],
        ),
      ),
    );
  }
}
