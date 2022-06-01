import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../cfg/cfg.dart';
import '../pages/pages.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  NavigationDrawerState createState() => NavigationDrawerState();
}

class NavigationDrawerState extends State<NavigationDrawerWidget> {
  static const padding = EdgeInsets.symmetric(horizontal: 20);

  static const name = 'Gala TPS ESBS';
  static const email = 'email@exampe.com';
  static const avatar = 'assets/images/avatar.png';

  final Uri url = Uri.parse(
    'mailto:$email?subject=request&body='
    'Hi!\nI would like to know more about the Gala.'
    '\n\n[your message here]\n\n'
    'Best Regards,\n[please add your contact info here]\n',
  );

  static const hints = {
    'home': 0,
    'address': 0,
    'drinks': 0,
    'bar': 0,
    'team': 0,
    'accueil': 0,
    'adresse': 0,
    'boisson': 0,
    'equipe': 0,
  };

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Palette.bg,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListView(
        padding: padding,
        children: <Widget>[
          buildHeader(
            urlImage: avatar,
            name: name,
            email: email,
            onClicked: () => launchUrlString(url.toString()),
          ),
          buildSearchField(context),
          const SizedBox(height: 48),
          buildMenuItem(
            text: 'Accueil',
            icon: Icons.home,
            onClicked: () => selectedItem(context, 0),
          ),
          buildMenuItem(
            text: 'Évènements',
            icon: Icons.event,
            onClicked: () => selectedItem(context, 1),
          ),
          buildMenuItem(
            text: 'Menu',
            icon: Icons.restaurant_menu,
            onClicked: () => selectedItem(context, 2),
          ),
          buildMenuItem(
            text: 'Boissons',
            icon: Icons.local_bar,
            onClicked: () => selectedItem(context, 3),
          ),
          buildMenuItem(
            text: 'Tickets',
            icon: Icons.local_atm,
            onClicked: () => selectedItem(context, 4),
          ),
          const Divider(
            color: Palette.scaffold,
            thickness: 3,
          ),
          buildMenuItem(
            text: 'Venir',
            icon: Icons.location_on,
            onClicked: () => selectedItem(context, 5),
          ),
          buildMenuItem(
            text: 'L\'équipe',
            icon: Icons.group,
            onClicked: () => selectedItem(context, 6),
          ),
          buildMenuItem(
            text: 'à propos',
            icon: Icons.info,
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
          padding: padding.add(const EdgeInsets.symmetric(vertical: 48)),
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
                    style:
                        const TextStyle(fontSize: 18, color: Palette.scaffold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style:
                        const TextStyle(fontSize: 14, color: Palette.scaffold),
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
    int index = 0;

    return index;
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
