import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../cfg/cfg.dart';
import '../widgets/widgets.dart';

class MealPage extends StatefulWidget {
  const MealPage({Key? key}) : super(key: key);

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  List _starters = [], _main = [], _desserts = [];

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/json/meals.json');
    final data = await json.decode(response);

    setState(() {
      _starters = data['starters'];
      _main = data['main'];
      _desserts = data['desserts'];
    });
  }

  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      drawer: const NavigationDrawerWidget(),
      appBar: MyAppBar('🍽 Menu'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 48),
            const Text(
              'Entrées',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Palette.scaffold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: CustomMealSwiper(
                items: _starters,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Plats',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Palette.scaffold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: CustomMealSwiper(
                items: _main,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Desserts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Palette.scaffold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: CustomMealSwiper(
                items: _desserts,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
