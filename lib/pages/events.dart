import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../cfg/cfg.dart';
import '../widgets/widgets.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool isLoading = true;
  List _loc = [], _events = [];
  final List<Widget> _children = [];

  Future<void> readJson() async {
    _children.clear();
    final String response = await rootBundle.loadString('assets/json/events.json');
    final data = await json.decode(response);

    setState(() {
      _loc = data['loc'];
      _events = data[_loc[0]];

      for (var i = 0; i < _loc.length; i++) {
        Widget _child = createSelectWidget(
          title: _loc[i],
          ico: Icons.location_on,
        );
        _children.add(const SizedBox(width: 16));
        _children.add(_child);
      }
      _children.add(const SizedBox(width: 16));
    });
  }

  Future<void> _onRefresh(String loc) async {
    setState(() {
      _events = [];
      isLoading = true;
    });

    final String response = await rootBundle.loadString('assets/json/events.json');
    final data = await json.decode(response);

    setState(() {
      _events = data[loc];
      readJson().then((_) => setState(() => isLoading = false));
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _children,
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
}
