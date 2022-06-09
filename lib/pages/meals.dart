import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class MealPage extends StatefulWidget {
  const MealPage({Key? key}) : super(key: key);

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  bool isLoading = true;
  List<Miam> _starters = [], _mains = [], _desserts = [];
  final Wrapper<int> _starterIndex = Wrapper<int>(0),
      _mainIndex = Wrapper<int>(0),
      _dessertIndex = Wrapper<int>(0);

  late PackageInfo packageInfo;

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
    return Scaffold(
      backgroundColor: Palette.bg,
      drawer: const NavigationDrawerWidget(),
      appBar: MyAppBar('🍽 Menu'),
      floatingActionButton: FloatingActionButton(
        splashColor: Palette.grey,
        backgroundColor: Palette.greyDark,
        foregroundColor: Palette.scaffold,
        child: const Icon(
          Icons.copy_rounded,
          color: Palette.scaffold,
        ),
        onPressed: _saveCurrentMenu,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 48),
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
              child: CustomMealSwiper(
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
              child: CustomMealSwiper(
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
              child: CustomMealSwiper(
                items: _desserts,
                index: _dessertIndex,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _saveCurrentMenu() {
    String export = '';
    const int s = 1, m = 7, d = 17;

    if (!isLoading) {
      final int deadBeef = '💩'.hashCode; // shit is happening
      final String build = 'v$version($buildNumber)';
      final int str = _starterIndex.value << s | _mainIndex.value << m | _dessertIndex.value << d;

      export = '${build.hashCode ^ deadBeef}$str'.padRight(16, '0');
      print(export);
    }

    Clipboard.setData(ClipboardData(text: export)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Palette.greyDark,
          content: Text(
            isLoading ? 'App hash loading please try again' : 'Current menu exported to clipboard',
            softWrap: true,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Palette.scaffold),
          )));
    });
  }
}
