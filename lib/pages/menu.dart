import 'dart:convert';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galapsbs/helper/splitview.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../cfg/cfg.dart';
import '../widgets/widgets.dart';

class MiamData {
  List<Miam> miams;

  MiamData({required this.miams});

  factory MiamData.fromJson(Map<String, dynamic> data, String? course) {
    final List<Miam> miams =
        (data[course!] as List<dynamic>).map((dynamic miam) => Miam.fromJson(miam)).toList();
    return MiamData(miams: miams);
  }
}

class StarterData extends MiamData {
  List<Miam> starters;

  StarterData({required this.starters}) : super(miams: starters);

  @override
  factory StarterData.fromJson(Map<String, dynamic> data) {
    final List<Miam> miams =
        (data['starters'] as List<dynamic>).map((dynamic starters) => Miam.fromJson(starters)).toList();
    return StarterData(starters: miams);
  }
}

class MainData extends MiamData {
  List<Miam> mains;

  MainData({required this.mains}) : super(miams: mains);

  @override
  factory MainData.fromJson(Map<String, dynamic> data) {
    final List<Miam> miams =
        (data['mains'] as List<dynamic>).map((dynamic mains) => Miam.fromJson(mains)).toList();
    return MainData(mains: miams);
  }
}

class DessertData extends MiamData {
  List<Miam> desserts;

  DessertData({required this.desserts}) : super(miams: desserts);

  @override
  factory DessertData.fromJson(Map<String, dynamic> data) {
    final List<Miam> miams =
        (data['desserts'] as List<dynamic>).map((dynamic desert) => Miam.fromJson(desert)).toList();
    return DessertData(desserts: miams);
  }
}

class Miam {
  final String name, image, description;
  final bool is_vegan;

  Miam({required this.name, required this.image, required this.is_vegan, required this.description});

  factory Miam.fromJson(Map<String, dynamic> data) {
    return Miam(
      name: data['name'] as String,
      image: data['image'] as String,
      is_vegan: data['is_vegan'] as bool,
      description: data['description'] as String,
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool isLoading = true;
  List<Miam> _starters = [], _mains = [], _desserts = [];
  final Wrapper<int> _starterIndex = Wrapper<int>(0),
      _mainIndex = Wrapper<int>(0),
      _dessertIndex = Wrapper<int>(0);

  late PackageInfo packageInfo;

  late String appName;
  late String version;
  late String buildNumber;

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/json/meals.json');
    final data = await json.decode(response);

    setState(() {
      _starters = StarterData.fromJson(data).starters;
      _mains = MainData.fromJson(data).mains;
      _desserts = DessertData.fromJson(data).desserts;
    });
  }

  Future<void> loadPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appName = packageInfo.appName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  void initState() {
    super.initState();
    readJson();
    loadPackageInfo().then((_) => setState(() => isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Splitview(
      left: NavigationDrawerWidget(),
      right: Scaffold(
        drawer: MediaQuery.of(context).size.width < breakpoint ? NavigationDrawerWidget() : null,
        appBar: MyAppBar('🍽️ Menu'),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveCurrentMenu,
          child: const Icon(
            Icons.save_rounded,
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 24),
              const Text(
                'Entrées',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Palette.scaffold,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: createCustomMealSwiper(
                  items: _starters,
                  index: _starterIndex,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Plats',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Palette.scaffold,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: createCustomMealSwiper(
                  items: _mains,
                  index: _mainIndex,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Desserts',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Palette.scaffold,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: createCustomMealSwiper(
                  items: _desserts,
                  index: _dessertIndex,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _saveCurrentMenu() async {
    if (isLoading) {
      _showSnackBar('Loading...');
      return;
    }

    final String export = '$appName - v$version ($buildNumber)\n'
        'Entrée : '
        '${_starters[_starterIndex.value].name}\n'
        'Plat : '
        '${_mains[_mainIndex.value].name}\n'
        'Dessert : '
        '${_desserts[_dessertIndex.value].name}\n';

    await Clipboard.setData(ClipboardData(text: export))
        .then((_) => _showSnackBar('Menu copié dans le presse-papier'));
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Palette.scaffold,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Text(
          text,
          textAlign: TextAlign.center,
          // style: TextStyle(color: Palette.scaffold),
        )));
  }

  Widget createCustomMealSwiper({required List<Miam> items, required Wrapper<int> index}) {
    return Swiper(
      onIndexChanged: (int i) => setState(() => index.value = i),
      autoplay: false,
      autoplayDelay: 5000,
      autoplayDisableOnInteraction: true,
      duration: 1000,
      controller: SwiperController(),
      physics: const ClampingScrollPhysics(),
      itemCount: items.length,
      viewportFraction: MediaQuery.of(context).orientation == Orientation.portrait ? 0.8 : 0.5,
      scale: 0.7,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.only(right: 20, left: 20, top: 30),
          decoration: const BoxDecoration(
              color: Palette.scaffold, borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            children: <Widget>[
              Text(
                items[index].name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Palette.black,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  SizedBox(
                    height: 100,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: Image.asset(items[index].image).image,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          ImageIcon(
                            items[index].is_vegan
                                ? const AssetImage('assets/icons/vegan.png')
                                : const AssetImage('assets/icons/non_vegan.png'),
                            size: 20,
                            color: items[index].is_vegan ? Palette.green : Palette.red,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            items[index].is_vegan ? 'végétarien' : 'non végé',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Palette.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        items[index].description,
                        softWrap: false,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Palette.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
