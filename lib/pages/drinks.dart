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
  bool isLoading = true;
  List _drinks = [], _snacks = [];
  List<Widget> _children = [];

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/json/drinks.json');
    final data = await json.decode(response);

    setState(() {
      _drinks = data['drinks'];
      _snacks = data['snacks'];

      for (var i = 0; i < _snacks.length; i++) {
        _children.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '${_snacks[i]['name']}',
              style: const TextStyle(
                fontSize: 16,
                color: Palette.scaffold,
              ),
              textAlign: TextAlign.left,
            ),
            Text(
              '${_snacks[i]['price']}€',
              style: const TextStyle(
                fontSize: 16,
                color: Palette.scaffold,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    readJson().then((_) => setState(() => isLoading = false));
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
                  width: 200,
                  child: Column(
                    children: [
                      isLoading
                          ? const Center(
                              child: SizedBox(
                                height: 48,
                                width: 48,
                                child: CircularProgressIndicator(
                                  color: Palette.scaffold,
                                ),
                              ),
                            )
                          : Column(
                              children: _children,
                            ),
                      const SizedBox(height: 24),
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
