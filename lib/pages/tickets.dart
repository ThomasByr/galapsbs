import 'dart:math';

import 'package:flutter/material.dart';
import 'package:galapsbs/helper/splitview.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
                        ' - __Renseigner le menu__ (si vous prenez un biller avec repas) lors de l\'achat dans HelloAsso (vous pouvez le copier depuis la page "menu")\n'
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
  static const List<String> links = [
    'https://www.helloasso.com/associations/gala-telecom-ps-esbs/evenements/entree-gala',
    'https://www.helloasso.com/associations/gala-telecom-ps-esbs/evenements/entree-gala-2-1',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Container(
        width: min(600, MediaQuery.of(context).size.width),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Palette.scaffold,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(child: dynamicButton()),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text.rich(textSpan(
                    [
                      '**prix** 23 € (+2 € si non cotisant)\n'
                          'ticket boisson de 6€ offert',
                      '**prix** 48 € (+2 € si non cotisant)\n'
                          'ticket boisson de 6€\n+ verre apéritif offert',
                    ][widget.current.value ? 1 : 0],
                    style: const TextStyle(
                      color: Palette.black,
                    ),
                  )),
                  Text.rich(textSpan(
                    [
                      '**arrivée** à 23h',
                      '**arrivée** à 19h\n'
                          '**renseigner** le menu\n'
                          '**before** INTERDIT',
                    ][widget.current.value ? 1 : 0],
                    style: const TextStyle(
                      color: Palette.black,
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dynamicButton() {
    return Container(
      width: min(300, MediaQuery.of(context).size.width),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60),
        color: Palette.scaffold,
      ),
      child: ListTile(
        title: Text.rich(textSpan(
          'Acheter un billet sur HelloAsso',
          style: const TextStyle(
            color: Palette.black,
            fontWeight: FontWeight.bold,
          ),
        )),
        onTap: () => launchUrlString(links[widget.current.value ? 1 : 0]),
        trailing: IconButton(
          icon: const Icon(
            Icons.qr_code,
            color: Palette.black,
          ),
          onPressed: () => showDialog(
            context: context,
            builder: (context) {
              return Center(
                child: AlertDialog(
                  title: const Text('QR Code'),
                  content: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Palette.scaffold,
                    ),
                    child: Center(
                      child: QrImage(
                        data: links[widget.current.value ? 1 : 0],
                        version: QrVersions.auto,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
