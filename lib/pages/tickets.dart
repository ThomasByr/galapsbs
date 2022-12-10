import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galapsbs/helper/splitview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
    return Splitview(
      left: NavigationDrawerWidget(),
      right: Scaffold(
        drawer: MediaQuery.of(context).size.width < breakpoint ? NavigationDrawerWidget() : null,
        appBar: MyAppBar('🎟️ Billets'),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 16),
                Container(
                  width: min(600, MediaQuery.of(context).size.width * .9),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Palette.scaffold,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        Text(
                          'Informations Générales',
                          style: TextStyle(
                            color: Palette.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text.rich(
                          TextSpan(
                            text:
                                'Les billets sont disponibles en vente sur place au fouaille du <> au <>. Ils sont également disponibles en prévente sur l\'application HelloAsso en ligne.\n\n',
                            style: TextStyle(
                              color: Palette.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Si vous prenez des billets en ligne, pensez à :\n'
                                    ' - Renseigner le ',
                              ),
                              TextSpan(
                                text: 'menu',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(
                                text: ' (vous pouvez l\'exporter depuis la page "menu")\n'
                                    ' - Décocher l\'option pour ',
                              ),
                              TextSpan(
                                text: 'soutenir',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(text: ' HelloAsso\n'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
