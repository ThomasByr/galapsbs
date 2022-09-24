import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:card_swiper/card_swiper.dart';

import '../cfg/cfg.dart';
import '../widgets/widgets.dart';

class DrinkData {
  List<Drink> drinks;

  DrinkData({required this.drinks});

  factory DrinkData.fromJson(Map<String, dynamic> data) {
    final List<Drink> drinks =
        (data['drinks'] as List<dynamic>).map((dynamic drink) => Drink.fromJson(drink)).toList();
    return DrinkData(drinks: drinks);
  }
}

class Drink {
  final String name, subName, price, degree, location, image;

  Drink({
    required this.name,
    required this.subName,
    required this.price,
    required this.degree,
    required this.location,
    required this.image,
  });

  factory Drink.fromJson(Map<String, dynamic> data) {
    return Drink(
      name: data['name'] as String,
      subName: data['sub_name'] as String,
      price: data['price'] as String,
      degree: data['degree'] as String,
      location: data['location'] as String,
      image: data['image'] as String,
    );
  }
}

class SnackData {
  List<Snack> snacks;

  SnackData({required this.snacks});

  factory SnackData.fromJson(Map<String, dynamic> data) {
    final List<Snack> snacks =
        (data['snacks'] as List<dynamic>).map((dynamic snack) => Snack.fromJson(snack)).toList();
    return SnackData(snacks: snacks);
  }
}

class Snack {
  final String name, price;

  Snack({required this.name, required this.price});

  factory Snack.fromJson(Map<String, dynamic> data) {
    return Snack(name: data['name'] as String, price: data['price'] as String);
  }
}

class DrinkPage extends StatefulWidget {
  const DrinkPage({Key? key}) : super(key: key);

  @override
  State<DrinkPage> createState() => _DrinkPageState();
}

class _DrinkPageState extends State<DrinkPage> {
  bool isLoading = true;
  List<Drink> _drinks = [];
  List<Snack> _snacks = [];
  final List<Widget> _children = [];

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/json/drinks.json');
    final data = await json.decode(response);

    setState(() {
      _drinks = DrinkData.fromJson(data).drinks;
      _snacks = SnackData.fromJson(data).snacks;

      for (var i = 0; i < _snacks.length; i++) {
        _children.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              _snacks[i].name,
              style: const TextStyle(
                fontSize: 16,
                color: Palette.scaffold,
              ),
              textAlign: TextAlign.left,
            ),
            Text(
              '${_snacks[i].price}€',
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
      drawer: NavigationDrawerWidget(),
      appBar: MyAppBar('🍹 Boissons'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
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
                viewportFraction: MediaQuery.of(context).orientation == Orientation.portrait ? 0.8 : 0.5,
                scale: 0.7,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.only(right: 20, left: 20, top: 30),
                    decoration: const BoxDecoration(
                      color: Palette.scaffold,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _drinks[index].name,
                          textAlign: TextAlign.center,
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
                          _drinks[index].subName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Palette.greyDark,
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          child: Image.asset(_drinks[index].image),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.euro_sharp, color: Palette.black),
                                      const SizedBox(width: 12),
                                      Text(
                                        _drinks[index].price,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Palette.black,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(Icons.liquor_rounded, color: Palette.black),
                                      const SizedBox(width: 12),
                                      Text(
                                        _drinks[index].degree,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Palette.black,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_sharp, color: Palette.black),
                                  const SizedBox(width: 12),
                                  Text(
                                    _drinks[index].location,
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
            ),
          ],
        ),
      ),
    );
  }
}
