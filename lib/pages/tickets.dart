import 'dart:math';

import 'package:flutter/material.dart';
import 'package:galapsbs/helper/splitview.dart';

import '../cfg/cfg.dart';
import '../widgets/widgets.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({Key? key}) : super(key: key);

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  @override
  Widget build(BuildContext context) {
    return Splitview(
      left: NavigationDrawerWidget(),
      right: Scaffold(
        drawer: MediaQuery.of(context).size.width < breakpoint ? NavigationDrawerWidget() : null,
        appBar: MyAppBar('🎟️ Billetterie'),
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
                        children: <Widget>[
                          const Text(
                            'Informations Générales',
                            style: TextStyle(
                              color: Palette.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text.rich(textSpan(
                            'Les billets sont disponibles en vente sur place au fouaille du <> au <>. Ils sont également disponibles en prévente sur l\'application HelloAsso en ligne.\n\n'
                            'Si vous prenez des **billets en ligne**, pensez à :\n'
                            ' - __Renseigner le menu__ lors de l\'achat dans HelloAsso (vous pouvez le copier depuis la page "menu")\n'
                            ' - __Décocher l\'option__ pour soutenir HelloAsso\n\n',
                            style: const TextStyle(
                              color: Palette.black,
                            ),
                          )),
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
