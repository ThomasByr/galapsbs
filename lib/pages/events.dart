import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../cfg/cfg.dart';
import '../widgets/widgets.dart';
import '../particle-clock/particle_clock.dart';
import '../helper/customizer.dart';
import '../helper/model.dart';

class LocData {
  List<String> locs;

  LocData({required this.locs});

  factory LocData.fromJson(Map<String, dynamic> data) {
    final List<String> locs = (data['locs'] as List<dynamic>).map((dynamic loc) => loc as String).toList();
    return LocData(locs: locs);
  }
}

class EventData {
  List<Event> events;

  EventData({required this.events});

  factory EventData.fromJson(Map<String, dynamic> data, String? key) {
    final List<Event> events =
        (data[key!] as List<dynamic>).map((dynamic event) => Event.fromJson(event)).toList();
    return EventData(events: events);
  }
}

class Event {
  final String name, date, time0, time1, description, details, image;

  Event({
    required this.name,
    required this.date,
    required this.time0,
    required this.time1,
    required this.description,
    required this.details,
    required this.image,
  });

  factory Event.fromJson(Map<String, dynamic> data) {
    return Event(
      name: data['name'] as String,
      date: data['date'] as String,
      time0: data['time0'] as String,
      time1: data['time1'] as String,
      description: data['description'] as String,
      details: data['details'] as String,
      image: data['image'] as String,
    );
  }
}

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool isLoading = true;
  List<String> _locs = []; // List of locations
  List<List<Event>> _events = []; // List of events for each location
  final List<Widget> _selectChildren = [];
  final List<Widget> _coreChildren = [];

  Future<void> readJson() async {
    _selectChildren.clear();
    _coreChildren.clear();
    final String response = await rootBundle.loadString('assets/json/events.json');
    final data = await json.decode(response);

    setState(() {
      _locs = LocData.fromJson(data).locs;
      for (var i = 0; i < _locs.length; i++) {
        List<Event> e = EventData.fromJson(data, _locs[i]).events;
        _events.add([...e]);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    readJson().then((_) => setState(() => isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClockCustomizer((ClockModel model) => ParticleClock(model)),
        Scaffold(
          backgroundColor: Colors.transparent,
          drawer: NavigationDrawerWidget(bg: Colors.transparent),
          appBar: MyAppBar('🗓️ Événements', bg: Colors.transparent),
        ),
      ],
    );
  }
}
