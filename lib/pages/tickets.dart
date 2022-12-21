import 'dart:math';

import 'package:flutter/material.dart';
import 'package:galapsbs/helper/splitview.dart';
import 'package:sliding_switch/sliding_switch.dart';

import '../cfg/cfg.dart';
import '../widgets/widgets.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({Key? key}) : super(key: key);

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  Wrapper<bool> current = Wrapper(false);

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
                SlidingSwitch(
                  width: 300.0,
                  height: 50.0,
                  value: current.value,
                  onChanged: ((value) => setState(() => current.value = value)),
                  onTap: () {},
                  onDoubleTap: () {},
                  onSwipe: () {},
                  textOff: 'Entrée Seule',
                  textOn: 'Entrée + Repas',
                ),
                const SizedBox(height: 48),
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
                      child: Text.rich(textSpan(
                        'Les billets sont disponibles en vente sur place au fouaille du <> au <>. Ils sont également disponibles en prévente sur l\'application HelloAsso en ligne.\n\n'
                        'Si vous prenez des **billets en ligne**, pensez à :\n'
                        ' - __Renseigner le menu__ lors de l\'achat dans HelloAsso (vous pouvez le copier depuis la page "menu")\n'
                        ' - __Décocher l\'option__ pour soutenir HelloAsso\n'
                        'Une confirmation par mail vous sera envoyée une fois la vérification de votre paiement effectuée.',
                        style: const TextStyle(
                          color: Palette.black,
                        ),
                      )),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                TicketHandler(current: current),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TicketHandler extends StatefulWidget {
  const TicketHandler({Key? key, required this.current}) : super(key: key);

  final Wrapper<bool> current;

  @override
  State<TicketHandler> createState() => _TicketHandlerState();
}

class _TicketHandlerState extends State<TicketHandler> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
              child: Text.rich(textSpan(
                [
                  '**Billet Entrée Seule**\n'
                      '__prix__ 20 € (+6/12 € par ticket boisson)\n'
                      '__arrivée__ à partir de 23h',
                  '**Billet Entrée + Repas**\n'
                      '__prix__ 50 € (+6/12 € par ticket boisson)\n'
                      '__arrivée__ à 19h\n'
                      '__renseigner__ le menu sur HelloAsso\n'
                      '__before__ INTERDIT'
                ][widget.current.value ? 1 : 0],
                style: const TextStyle(
                  color: Palette.black,
                ),
              )),
            ),
          ),
        ),
      ],
    );
  }
}
