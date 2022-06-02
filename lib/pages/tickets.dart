import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '404.dart';
import '../cfg/cfg.dart';
import '../widgets/widgets.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({Key? key}) : super(key: key);

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      drawer: const NavigationDrawerWidget(),
      appBar: MyAppBar('🎟️ Billets'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: 600,
          child: Center(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ErrorPage(),
                ));
              },
              icon: const Icon(Icons.attach_money),
              iconSize: 64,
              color: Palette.scaffold,
              hoverColor: Palette.greyDark,
              highlightColor: Palette.greyDark,
            ),
          ),
        ),
      ),
    );
  }
}
