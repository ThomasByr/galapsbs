import 'dart:math';

import 'package:flutter/material.dart';
import 'package:galapsbs/helper/splitview.dart';

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
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Container(
                    width: min(600, MediaQuery.of(context).size.width),
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
                                  text: 'Si vous prenez des billets en ligne',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: ', pensez à :\n',
                                ),
                                TextSpan(
                                  text: ' - ',
                                ),
                                TextSpan(
                                  text: 'Renseigner le menu',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(
                                  text: ' (vous pouvez le copier depuis la page "menu")\n',
                                ),
                                TextSpan(
                                  text: ' - ',
                                ),
                                TextSpan(
                                  text: 'Décocher l\'option',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(
                                  text: ' pour soutenir HelloAsso',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
