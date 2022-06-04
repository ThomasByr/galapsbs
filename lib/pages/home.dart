import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../cfg/cfg.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      drawer: const NavigationDrawerWidget(),
      appBar: MyAppBar('🎉 Accueil'),
      body: Builder(
        builder: (context) => Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 48),
              SizedBox(
                height: 400,
                width: min(600, MediaQuery.of(context).size.width * 0.8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Image.asset(
                    'assets/images/avatar.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Container(
                width: min(window.physicalSize.width, 400),
                decoration: const BoxDecoration(
                  color: Palette.bg,
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: OpenNavWidget(
                  icon: Icons.menu,
                  text: 'Voir Plus',
                  onClicked: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
