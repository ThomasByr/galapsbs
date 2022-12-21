import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:tuple/tuple.dart';

import '../cfg/cfg.dart';
import '../widgets/widgets.dart';
import '../helper/splitview.dart';

class RawData {
  final List<Train> tables;

  RawData({required this.tables});

  factory RawData.fromJson(Map<String, dynamic> json) {
    var list = json['sncf'] as List;
    List<Train> tables = list.map((i) => Train.fromJson(i)).toList();

    return RawData(tables: tables);
  }
}

class Train {
  final int id;
  final List<Seat> seats;

  Train({required this.id, required this.seats});

  factory Train.fromJson(Map<String, dynamic> json) {
    var list = json['seats'] as List;
    List<Seat> seats = list.map((i) => Seat.fromJson(i)).toList();

    return Train(id: json['id'] as int, seats: seats);
  }
}

class Seat {
  final String name;
  final Menu menu;

  Seat({required this.name, required this.menu});

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      name: json['name'] as String,
      menu: Menu.fromJson(json['menu']),
    );
  }
}

class Menu {
  final String starter;
  final String main;
  final String dessert;

  Menu({required this.starter, required this.main, required this.dessert});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      starter: json['starter'] as String,
      main: json['main'] as String,
      dessert: json['dessert'] as String,
    );
  }
}

class SncfPage extends StatefulWidget {
  const SncfPage({Key? key}) : super(key: key);
  @override
  _SncfPageState createState() => _SncfPageState();
}

class _SncfPageState extends State<SncfPage> {
  bool isLoading = true;
  late Future<RawData> trainData;
  late Map<String, Tuple2<int, Menu>> allNames = {};

  Future<void> readJson() async {
    final String response = await DefaultAssetBundle.of(context).loadString('assets/json/sncf.json');
    final data = await json.decode(response);
    setState(() {
      trainData = Future.value(RawData.fromJson(data));
    });
  }

  @override
  void initState() {
    super.initState();
    readJson().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Splitview(
      left: NavigationDrawerWidget(),
      right: Scaffold(
        drawer: MediaQuery.of(context).size.width < breakpoint ? NavigationDrawerWidget() : null,
        appBar: MyAppBar('🪑 Plan de table'),
        body: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 24),
              SizedBox(
                width: min(600, MediaQuery.of(context).size.width),
                child: buildSearchField(context),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SizedBox(
                  width: min(600, MediaQuery.of(context).size.width),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: <Widget>[
                        if (isLoading)
                          const Center(
                            child: CircularProgressIndicator(),
                          )
                        else
                          FutureBuilder<RawData>(
                            future: trainData,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount: snapshot.data!.tables.length,
                                  itemBuilder: (context, index) {
                                    allNames.addAll(
                                      {
                                        for (var e in snapshot.data!.tables[index].seats)
                                          e.name: Tuple2(snapshot.data!.tables[index].id, e.menu)
                                      },
                                    );
                                    return ExpansionTileCard(
                                      title: Text('table ${snapshot.data!.tables[index].id}'),
                                      subtitle: Text(
                                          snapshot.data!.tables[index].seats.map((e) => e.name).join(', ')),
                                      animateTrailing: true,
                                      trailing: const Icon(Icons.play_circle_outline_sharp),
                                      initialPadding: const EdgeInsets.all(0),
                                      finalPadding: const EdgeInsets.all(20),
                                      contentPadding: const EdgeInsets.all(0),
                                      paddingCurve: Curves.easeInOut,
                                      leading: const CircleAvatar(
                                        backgroundColor: Palette.scaffold,
                                        child: Icon(Icons.train_rounded),
                                      ),
                                      isThreeLine: true,
                                      children: <Widget>[
                                        for (var seat in snapshot.data!.tables[index].seats)
                                          individualSeat(seat),
                                      ],
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget individualSeat(Seat seat) {
    return ListTile(
      title: Text(seat.name),
      subtitle: Text('${seat.menu.starter} - ${seat.menu.main} - ${seat.menu.dessert}'),
      trailing: IconButton(
        icon: const Icon(Icons.person_rounded),
        onPressed: () {
          lookupName(seat.name);
        },
      ),
    );
  }

  void lookupName(String name) {
    trainData.then((value) {
      Rating r = name.bestMatch(allNames.keys.toList()).bestMatch;
      if (r.rating! > 0.5) {
        String closest = r.target!;
        Menu menu = allNames[closest]!.item2;

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              icon: const Icon(Icons.person_rounded),
              title: Text(closest),
              content: Text(
                'table ${allNames[closest]!.item1}\n${menu.starter} - ${menu.main} - ${menu.dessert}',
                textAlign: TextAlign.left,
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Fermer'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  Widget buildSearchField(BuildContext context) {
    const color = Palette.scaffold;

    return TextField(
      style: const TextStyle(color: color),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        hintText: 'Chercher un nom',
        hintStyle: const TextStyle(color: color),
        prefixIcon: const Icon(Icons.search_rounded, color: color),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
      ),
      autofillHints: allNames.keys.toList(),
      onSubmitted: (value) => {
        setState(() {
          lookupName(value);
        })
      },
    );
  }
}
