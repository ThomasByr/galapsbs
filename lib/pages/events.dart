import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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

  PreferredSizeWidget myAppBar = MyAppBar('🗓️ Événements', bg: Colors.transparent);

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

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(
      initialPage: 0,
      keepPage: false,
      viewportFraction: MediaQuery.of(context).orientation == Orientation.portrait ? 0.8 : 0.5,
    );

    final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);
    return Stack(
      children: <Widget>[
        ClockCustomizer((ClockModel model) => ParticleClock(model)),
        Scaffold(
          backgroundColor: Colors.transparent,
          drawer: NavigationDrawerWidget(bg: Colors.transparent),
          appBar: myAppBar,
          body: Column(
            children: <Widget>[
              SizedBox(
                height: 48,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _locs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ValueListenableBuilder(
                            builder: (BuildContext context, int value, Widget? child) {
                              return TextButton(
                                onPressed: () {
                                  _selectedIndex.value = index;
                                  controller.animateToPage(index,
                                      duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                                },
                                child: Text(
                                  _locs[index],
                                  style: TextStyle(
                                    color: _selectedIndex.value == index
                                        ? Theme.of(context).accentColor
                                        : Theme.of(context).textTheme.bodyText1!.color,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            },
                            valueListenable: _selectedIndex,
                          );
                        },
                      ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height -
                    48 -
                    MediaQuery.of(context).padding.top -
                    myAppBar.preferredSize.height,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : PageView(
                        controller: controller,
                        scrollDirection: Axis.horizontal,
                        dragStartBehavior: DragStartBehavior.start,
                        onPageChanged: (int index) {
                          debugPrint('Page changed to $index');
                          _selectedIndex.value = index;
                        },
                        children: List<Widget>.generate(
                            _locs.length, (int index) => _buildPage(index, _events[index])),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPage(int index, List<Event> events) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Card(
            color: Colors.black.withAlpha(100),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(events[index].name),
                  subtitle: Text(events[index].date),
                ),
                Image.asset(events[index].image),
                ListTile(
                  title: Text(events[index].description),
                  subtitle: Text(events[index].details),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
