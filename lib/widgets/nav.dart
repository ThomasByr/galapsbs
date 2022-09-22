import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:string_similarity/string_similarity.dart';

import '../cfg/cfg.dart';
import '../pages/pages.dart';

class NavigationDrawerWidget extends StatefulWidget {
  NavigationDrawerWidget({Key? key, Color? bg}) : super(key: key) {
    _bg = bg ?? Palette.bg;
  }

  late Color _bg;

  @override
  NavigationDrawerState createState() => NavigationDrawerState();
}

class NavigationDrawerState extends State<NavigationDrawerWidget> {
  static const EdgeInsets padding = EdgeInsets.symmetric(horizontal: 20);

  static const String name = 'Gala TPS ESBS';
  static const String email = '11 février 2023';
  static const String avatar = 'assets/images/logo.png';

  final Uri url = Uri.parse(
    'mailto:$email?subject=request&body='
    'Hi!\nI would like to know more about the Gala.'
    '\n\n[your message here]\n\n'
    'Best Regards,\n[please add your contact info here]\n',
  );

  static const Map<String, int> hints = {
    // en
    'home': 0,
    'food': 2,
    'menu': 2,
    'eat': 2,
    'starter': 2,
    'main': 2,
    'dessert': 2,
    'meal': 2,
    'bar': 3,
    'drink': 3,
    'wine': 3,
    'beer': 3,
    'cocktail': 3,
    'liquor': 3,
    'buy': 4,
    'buy now': 4,
    'ticket': 4,
    'address': 5,
    'come': 5,
    'team': 6,
    'tinder': 6,
    'match': 6,
    'contact': 6,
    'about': 7,
    // fr
    'accueil': 0,
    'nourriture': 2,
    'manger': 2,
    'entrée': 2,
    'plat': 2,
    'boisson': 3,
    'repas': 3,
    'boire': 3,
    'vin': 3,
    'bière': 3,
    'liqueur': 3,
    'adresse': 5,
    'venir': 5,
    'équipe': 6,
    'propos': 7,
    'à propos': 7,
  };

  Color get bg => widget._bg;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: bg,
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: ListView(
        padding: padding,
        children: <Widget>[
          buildHeader(
            urlImage: avatar,
            name: name,
            email: email,
            onClicked: () => {/* launchUrlString(url.toString()) */},
          ),
          buildSearchField(context),
          const SizedBox(height: 48),
          buildMenuItem(
            text: 'Accueil',
            icon: Icons.home_rounded,
            onClicked: () => selectedItem(context, 0),
          ),
          buildMenuItem(
            text: 'Événements',
            icon: Icons.event_available_rounded,
            onClicked: () => selectedItem(context, 1),
          ),
          buildMenuItem(
            text: 'Menu',
            icon: Icons.restaurant_menu_rounded,
            onClicked: () => selectedItem(context, 2),
          ),
          buildMenuItem(
            text: 'Boissons',
            icon: Icons.local_bar_rounded,
            onClicked: () => selectedItem(context, 3),
          ),
          buildMenuItem(
            text: 'Billets',
            icon: Icons.local_atm_rounded,
            onClicked: () => selectedItem(context, 4),
          ),
          const Divider(
            color: Palette.scaffold,
            thickness: 2,
          ),
          buildMenuItem(
            text: 'Venir',
            icon: Icons.location_on_rounded,
            onClicked: () => selectedItem(context, 5),
          ),
          buildMenuItem(
            text: 'L\'équipe',
            icon: Icons.group_rounded,
            onClicked: () => selectedItem(context, 6),
          ),
          buildMenuItem(
            text: 'À propos',
            icon: Icons.info_outline_rounded,
            onClicked: () => selectedItem(context, 7),
          ),
        ],
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(const EdgeInsets.symmetric(vertical: 20)),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: Image.asset(urlImage).image,
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 18, color: Palette.scaffold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 14, color: Palette.scaffold),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget buildSearchField(BuildContext context) {
    const color = Palette.scaffold;

    return TextField(
      style: const TextStyle(color: color),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        hintText: 'Search',
        hintStyle: const TextStyle(color: color),
        prefixIcon: const Icon(Icons.search, color: color),
        filled: true,
        fillColor: Palette.greyDark,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
      ),
      autofillHints: hints.entries.map((e) => e.key).toList(),
      onSubmitted: (value) => {selectedItem(context, searchFor(value))},
    );
  }

  int searchFor(String text) {
    String closest = text
        .bestMatch(
          hints.entries.map((e) => e.key).toList(),
        )
        .bestMatch
        .target!;

    debugPrint('closest: $closest');
    return hints[closest] ?? 0;
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = Palette.scaffold;
    const hoverColor = Palette.greyDark;
    const textSize = 18.0;

    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: const TextStyle(
          color: color,
          fontSize: textSize,
        ),
      ),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const EventPage(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const MealPage(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const DrinkPage(),
        ));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const TicketPage(),
        ));
        break;
      case 5:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const MapPage(),
        ));
        break;
      case 6:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const TeamPage(),
        ));
        break;
      case 7:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const AboutPage(),
        ));
        break;
    }
  }
}
