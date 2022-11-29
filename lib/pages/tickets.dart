import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galapsbs/helper/splitview.dart';

import '404.dart';
import '../cfg/cfg.dart';
import '../widgets/widgets.dart';
import '../helper/customizer.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({Key? key}) : super(key: key);

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MediaQuery.of(context).size.width < breakpoint ? NavigationDrawerWidget() : null,
      appBar: MyAppBar('🎟️ Billets'),
      body: Splitview(
        left: NavigationDrawerWidget(),
        right: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 16),
              Center(
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ErrorPage(),
                    ));
                  },
                  icon: const Icon(Icons.attach_money),
                  iconSize: 64,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
