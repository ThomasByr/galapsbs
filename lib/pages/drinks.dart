import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:card_swiper/card_swiper.dart';

import '../cfg/cfg.dart';
import '../widgets/widgets.dart';

class DrinkPage extends StatefulWidget {
  const DrinkPage({Key? key}) : super(key: key);

  @override
  State<DrinkPage> createState() => _DrinkPageState();
}

class _DrinkPageState extends State<DrinkPage> {
  List _drinks = [];

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/json/drinks.json');
    final data = await json.decode(response);

    setState(() {
      _drinks = data['drinks'];
    });
  }

  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      drawer: const NavigationDrawerWidget(),
      appBar: MyAppBar('🍹 Boissons'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 64),
            SizedBox(
              height: 400,
              child: Swiper(
                autoplay: true,
                autoplayDelay: 5000,
                autoplayDisableOnInteraction: true,
                duration: 1000,
                controller: SwiperController(),
                physics: const ClampingScrollPhysics(),
                itemCount: _drinks.length,
                viewportFraction: window.physicalSize.width <= window.physicalSize.height ? 0.8 : 0.4,
                scale: 0.7,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.only(right: 20, left: 20, top: 30),
                    decoration: const BoxDecoration(
                        color: Palette.scaffold, borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      children: [
                        Text(
                          _drinks[index]['name'],
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Palette.black,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          _drinks[index]['sub_name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Palette.greyDark,
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          child: Image.asset(_drinks[index]['image']),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.euro_rounded),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              _drinks[index]['price'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Palette.black,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.liquor_rounded),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              _drinks[index]['degree'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Palette.black,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 48),
            Column(
              children: <Widget>[
                const Text(
                  '🍿 Snacks disponibles aux bars\n',
                  softWrap: false,
                  style: TextStyle(
                    color: Palette.scaffold,
                    fontSize: 20.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 250,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        'Petits fours\n'
                        'Quiche\n'
                        'Gâteaux salés\n'
                        'Gâteaux sucrés\n',
                        softWrap: false,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Palette.scaffold,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        '0 €\n'
                        '0 €\n'
                        '0 €\n'
                        '0 €\n',
                        softWrap: false,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Palette.scaffold,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
