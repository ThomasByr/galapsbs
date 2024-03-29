import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../cfg/cfg.dart';
import '../widgets/widgets.dart';
import '../helper/splitview.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({Key? key}) : super(key: key);

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController mapController;

  final Map<String, Marker> _markers = {};
  final LatLng _center = const LatLng(48.525653901447846, 7.737739655341951);

  final Uri url1 = Uri.parse(
    'https://www.google.com/maps/dir/?api=1&destination=48.525653901447846,7.737739655341951&travelmode=transit',
  );
  final Uri url2 = Uri.parse(
    'https://www.google.com/maps/dir/?api=1&destination=48.525653901447846,7.737739655341951&travelmode=driving',
  );

  PreferredSizeWidget myAppBar = MyAppBar('🗺️ Venir');

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
    return Splitview(
      left: NavigationDrawerWidget(),
      right: Scaffold(
        drawer: MediaQuery.of(context).size.width < breakpoint ? NavigationDrawerWidget() : null,
        appBar: myAppBar,
        body: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                width: min(600, MediaQuery.of(context).size.width),
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3 -
                    MediaQuery.of(context).padding.top -
                    myAppBar.preferredSize.height,
                width: min(600, MediaQuery.of(context).size.width),
                child: SingleChildScrollView(
                  child: Column(
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
                        text: 'Venir en transports en commun',
                        icon: Icons.directions_bus_filled_rounded,
                        onClicked: () => launchUrl(url1),
                      ),
                      buildMenuItem(
                        text: 'Venir en voiture',
                        icon: Icons.directions_car_filled_rounded,
                        onClicked: () => launchUrl(url2),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ],
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
    const textSize = 16.0;

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
}
