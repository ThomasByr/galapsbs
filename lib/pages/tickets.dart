import 'dart:math';

import 'package:flutter/material.dart';
import 'package:galapsbs/helper/splitview.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../animated/animated.dart';
import '../cfg/cfg.dart';
import '../widgets/widgets.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({Key? key}) : super(key: key);

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  Wrapper<int> current = Wrapper(0);

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
                AnimatedToggleSwitch<int>.dual(
                  current: current.value,
                  height: 48,
                  indicatorSize: const Size(84, 48),
                  first: 0,
                  second: 1,
                  indicatorColor: Colors.transparent,
                  borderColor: Palette.scaffold,
                  onChanged: (i) {
                    setState(() => current.value = i);
                  },
                  iconBuilder: (i) {
                    switch (i) {
                      case 0:
                        return const Icon(Icons.event_available_outlined);
                      case 1:
                        return const Icon(Icons.dinner_dining_rounded);
                      default:
                        return const Icon(Icons.event_available_outlined);
                    }
                  },
                  textBuilder: (i) {
                    switch (i) {
                      case 0:
                        return const Center(child: AnimatedText(text: 'Entrée Seule'));
                      case 1:
                        return const Center(child: AnimatedText(text: 'Entrée + Repas'));
                      default:
                        return const Center(child: AnimatedText(text: 'Entrée Seule'));
                    }
                  },
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
                        ' - __Décocher l\'option__ pour soutenir HelloAsso',
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

class AnimatedText extends StatefulWidget {
  const AnimatedText({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedTextKit(
        repeatForever: true,
        animatedTexts: [
          ColorizeAnimatedText(
            widget.text,
            speed: const Duration(milliseconds: 250),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            colors: const [
              Palette.scaffold,
              Colors.yellow,
              Colors.red,
              Colors.blue,
              Colors.purple,
            ],
          ),
        ],
      ),
    );
  }
}

class TicketHandler extends StatefulWidget {
  const TicketHandler({Key? key, required this.current}) : super(key: key);

  final Wrapper<int> current;

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
                      '__prix__ 30 € (+6/12 € par ticket boisson)\n'
                      '__arrivée__ à partir de 23h',
                  '**Billet Entrée + Repas**\n'
                      '__prix__ 60 € (+6/12 € par ticket boisson)\n'
                      '__arrivée__ à 19h\n'
                      '__renseigner__ le menu sur HelloAsso\n'
                      '__before__ INTERDIT'
                ][widget.current.value],
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
