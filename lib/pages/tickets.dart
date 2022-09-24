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
      drawer: NavigationDrawerWidget(),
      appBar: MyAppBar('🎟️ Billets'),
      body: SingleChildScrollView(
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
<<<<<<< HEAD
=======
                color: Palette.scaffold,
                hoverColor: Palette.greyDark,
                highlightColor: Palette.greyDark,
>>>>>>> c11a8bd4dbb1cbfbab1f76ff71f63b1b46cf23fc
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
