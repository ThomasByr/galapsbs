import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../cfg/cfg.dart';
import '../widgets/widgets.dart';

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

  Event(
      {required this.name,
      required this.date,
      required this.time0,
      required this.time1,
      required this.description,
      required this.details,
      required this.image});

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
  List<String> _locs = [];
  List<Event> _events = [];
  final List<Widget> _selectChildren = [];
  final List<Widget> _coreChildren = [];

  Future<void> readJson() async {
    _selectChildren.clear();
    _coreChildren.clear();
    final String response = await rootBundle.loadString('assets/json/events.json');
    final data = await json.decode(response);

    setState(() {
      _locs = LocData.fromJson(data).locs;
      _events = EventData.fromJson(data, _locs[0]).events;

      for (var i = 0; i < _locs.length; i++) {
        Widget _child = createSelectWidget(
          title: _locs[i],
          ico: Icons.location_on,
        );
        _selectChildren.add(const SizedBox(width: 16));
        _selectChildren.add(_child);
      }
      _selectChildren.add(const SizedBox(width: 16));

      // todo: add events
    });
  }

  Future<void> _onRefresh(String loc) async {
    setState(() {
      isLoading = true;
      _events = [];
    });

    final String response = await rootBundle.loadString('assets/json/events.json');
    final data = await json.decode(response);

    setState(() {
      _events = EventData.fromJson(data, loc).events;
      // todo: add events

      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    readJson().then((_) => setState(() => isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      drawer: const NavigationDrawerWidget(),
      appBar: MyAppBar('🗓️ Événements'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 48),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: isLoading
                  ? createLoadingWidget()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _selectChildren,
                    ),
            ),
            const SizedBox(height: 48),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: isLoading
                  ? createLoadingWidget()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: _coreChildren,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createSelectWidget({required String title, required IconData ico}) {
    return InkWell(
      onTap: () {
        _onRefresh(title);
      },
      child: Container(
        width: 200,
        height: 35,
        decoration: BoxDecoration(
          color: Palette.greyDark,
          backgroundBlendMode: BlendMode.softLight,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Palette.black.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Palette.scaffold.withOpacity(0.5),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Palette.scaffold,
              ),
            ),
            Icon(
              ico,
              color: Palette.scaffold,
            ),
          ],
        ),
      ),
    );
  }

  Widget createCoreWidget({required Event event}) {
    return const SizedBox();
  }

  Widget createLoadingWidget() {
    return const Center(
      child: SizedBox(
        height: 48,
        width: 48,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Palette.scaffold),
          color: Palette.scaffold,
        ),
      ),
    );
  }
}
