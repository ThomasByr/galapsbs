import 'package:flutter/material.dart';
import 'package:galapsbs/pages/404.dart';
import 'package:string_similarity/string_similarity.dart';

import '../cfg/cfg.dart';
import '../pages/pages.dart';

class NavigationDrawerWidget extends StatefulWidget {
  NavigationDrawerWidget({Key? key, Color? bg}) : super(key: key) {
    _bg = bg ?? const Color.fromARGB(255, 51, 51, 51);
  }

  late Color _bg;

  @override
  NavigationDrawerState createState() => NavigationDrawerState();
}

enum Pages {
  home,
  home_explore,
  home_poster,
  events,
  menu,
  drinks,
  tickets,
  sncf,
  maps,
  team,
  about,
}

class NavigationDrawerState extends State<NavigationDrawerWidget> {
  static const EdgeInsets padding = EdgeInsets.symmetric(horizontal: 20);

  static const String name = 'Gala TPS ESBS';
  static const String date = '11 février 2023';
  static const String avatar = 'assets/images/gala.png';

  static const Map<String, Pages> hints = {
    // en
    'home': Pages.home,
    'explore': Pages.home_explore,
    'posts': Pages.home_explore,
    'sponsors': Pages.home_explore,
    'poster': Pages.home_poster,
    'winner': Pages.home_poster,
    'events': Pages.events,
    'schedule': Pages.events,
    'calendar': Pages.events,
    'food': Pages.menu,
    'menu': Pages.menu,
    'eat': Pages.menu,
    'starter': Pages.menu,
    'main': Pages.menu,
    'dessert': Pages.menu,
    'meal': Pages.menu,
    'bar': Pages.drinks,
    'drink': Pages.drinks,
    'wine': Pages.drinks,
    'beer': Pages.drinks,
    'cocktail': Pages.drinks,
    'liquor': Pages.drinks,
    'buy': Pages.tickets,
    'buy now': Pages.tickets,
    'ticket': Pages.tickets,
    'placement': Pages.sncf,
    'seat': Pages.sncf,
    'table': Pages.sncf,
    'address': Pages.maps,
    'come': Pages.maps,
    'location': Pages.maps,
    'team': Pages.team,
    'tinder': Pages.team,
    'match': Pages.team,
    'contact': Pages.team,
    'about': Pages.about,
    // fr
    'accueil': Pages.home,
    'explorer': Pages.home_explore,
    'affiche': Pages.home_poster,
    'gagnant': Pages.home_poster,
    'événements': Pages.events,
    'horaire': Pages.events,
    'calendrier': Pages.events,
    'nourriture': Pages.menu,
    'manger': Pages.menu,
    'entrée': Pages.menu,
    'plat': Pages.menu,
    'boisson': Pages.drinks,
    'repas': Pages.drinks,
    'boire': Pages.drinks,
    'vin': Pages.drinks,
    'bière': Pages.drinks,
    'liqueur': Pages.drinks,
    'billet': Pages.tickets,
    'billetterie': Pages.tickets,
    'acheter': Pages.tickets,
    'place': Pages.tickets,
    'réservation': Pages.sncf,
    'réservé': Pages.sncf,
    'sncf': Pages.sncf,
    'adresse': Pages.maps,
    'venir': Pages.maps,
    'équipe': Pages.team,
    'propos': Pages.about,
    'à propos': Pages.about,
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
            sub: date,
            onClicked: () => {},
          ),
          buildSearchField(context),
          const SizedBox(height: 24),
          const Divider(thickness: 2),
          buildMenuItem(
            text: 'Accueil',
            icon: Icons.home_rounded,
            onClicked: () => selectedItem(context, Pages.home),
          ),
          buildMenuItem(
            text: 'Événements',
            icon: Icons.event_available_rounded,
            onClicked: () => selectedItem(context, Pages.events),
          ),
          buildMenuItem(
            text: 'Menu',
            icon: Icons.restaurant_menu_rounded,
            onClicked: () => selectedItem(context, Pages.menu),
          ),
          buildMenuItem(
            text: 'Boissons',
            icon: Icons.local_bar_rounded,
            onClicked: () => selectedItem(context, Pages.drinks),
          ),
          buildMenuItem(
            text: 'Billetterie',
            icon: Icons.local_atm_rounded,
            onClicked: () => selectedItem(context, Pages.tickets),
          ),
          buildMenuItem(
            text: 'Plan de table',
            icon: Icons.map_rounded,
            onClicked: () => selectedItem(context, Pages.sncf),
          ),
          const Divider(thickness: 2),
          buildMenuItem(
            text: 'Venir',
            icon: Icons.location_on_rounded,
            onClicked: () => selectedItem(context, Pages.maps),
          ),
          buildMenuItem(
            text: 'L\'équipe',
            icon: Icons.group_rounded,
            onClicked: () => selectedItem(context, Pages.team),
          ),
          buildMenuItem(
            text: 'À propos',
            icon: Icons.info_outline_rounded,
            onClicked: () => selectedItem(context, Pages.about),
          ),
        ],
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String sub,
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
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sub,
                    style: const TextStyle(fontSize: 14),
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
        hintText: 'Chercher',
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
      autofillHints: hints.keys.toList(),
      onSubmitted: (value) => {selectedItem(context, searchFor(value))},
    );
  }

  Pages searchFor(String text) {
    Rating r = text
        .bestMatch(
          hints.entries.map((e) => e.key).toList(),
        )
        .bestMatch;
    String closest = r.target!;

    debugPrint('closest: $closest');
    return r.rating! > 0.5 ? hints[closest]! : Pages.home;
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const textSize = 18.0;

    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      leading: Icon(icon),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: textSize,
        ),
      ),
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, Pages index) {
    Navigator.of(context).pop();

    switch (index) {
      case Pages.home:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));
        break;
      case Pages.home_explore:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomePage(index: 1),
        ));
        break;
      case Pages.home_poster:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomePage(index: 2),
        ));
        break;
      case Pages.events:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const EventsPage(),
        ));
        break;
      case Pages.menu:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const MenuPage(),
        ));
        break;
      case Pages.drinks:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const DrinksPage(),
        ));
        break;
      case Pages.tickets:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const TicketsPage(),
        ));
        break;
      case Pages.sncf:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const SncfPage(),
        ));
        break;
      case Pages.maps:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const MapsPage(),
        ));
        break;
      case Pages.team:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const TeamPage(),
        ));
        break;
      case Pages.about:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const AboutPage(),
        ));
        break;

      default:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ErrorPage(),
        ));
    }
  }
}
