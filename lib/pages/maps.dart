import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../cfg/cfg.dart';
import '../widgets/widgets.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  final Map<String, Marker> _markers = {};
  final LatLng _center = const LatLng(48.525653901447846, 7.737739655341951);

  final Uri url1 = Uri.parse(
    'https://www.google.com/maps/dir/?api=1&destination=48.525653901447846,7.737739655341951&travelmode=transit',
  );
  final Uri url2 = Uri.parse(
    'https://www.google.com/maps/dir/?api=1&destination=48.525653901447846,7.737739655341951&travelmode=driving',
  );

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    setState(() {
      _markers.clear();
      _markers['Paris'] = Marker(
        markerId: const MarkerId('Paris'),
        position: _center,
        infoWindow: const InfoWindow(
          title: 'Télécom Physique Strasbourg',
          snippet: 'un seul amour, et pour toujours',
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      drawer: const NavigationDrawerWidget(),
      appBar: MyAppBar('🗺️ Venir'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: SizedBox(
            width: min(600, MediaQuery.of(context).size.width),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 16.0,
                      ),
                      markers: _markers.values.toSet(),
                    ),
                  ),
                ),
                ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    buildMenuItem(
                      text: 'Recentrer la carte',
                      icon: Icons.refresh,
                      onClicked: () => mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: _center,
                            zoom: 16.0,
                          ),
                        ),
                      ),
                    ),
                    buildMenuItem(
                      text: 'Venir en tram',
                      icon: Icons.directions_bus,
                      onClicked: () => launchUrlString(url1.toString()),
                    ),
                    buildMenuItem(
                      text: 'Venir en voiture',
                      icon: Icons.directions_car,
                      onClicked: () => launchUrlString(url2.toString()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
}
