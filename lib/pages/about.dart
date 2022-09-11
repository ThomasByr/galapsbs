import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../cfg/cfg.dart';
import '../widgets/widgets.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final Uri url1 = Uri.parse('https://github.com/ThomasByr');
  final Uri url2 = Uri.parse('https://github.com/LosKeeper');
  final Uri url3 = Uri.parse('https://github.com/ThomasByr/galapsbs/blob/master/LICENSE');

  bool isLoading = true;

  late PackageInfo packageInfo;

  late String appName;
  late String version;
  late String buildNumber;

  @override
  void initState() {
    super.initState();
    loadPackageInfo();
  }

  Future<void> loadPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appName = packageInfo.appName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      drawer: NavigationDrawerWidget(),
      appBar: MyAppBar('ℹ À propos'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            children: <Widget>[
              // const SizedBox(height: 48),
              const SizedBox(
                height: 150,
                // child: Image.asset(
                //   'assets/images/logo.png',
                //   fit: BoxFit.cover,
                // ),
                child: AnimatedLogo(),
              ),
              SizedBox(
                height: 48,
                child: isLoading
                    ? Center(
                        child: SizedBox(
                          width: min(600, MediaQuery.of(context).size.width * 0.9),
                          child: const LinearProgressIndicator(
                            backgroundColor: Palette.bg,
                            color: Palette.scaffold,
                            valueColor: AlwaysStoppedAnimation<Color>(Palette.scaffold),
                            minHeight: 2,
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          '$appName - v$version ($buildNumber)',
                          style: const TextStyle(
                            color: Palette.scaffold,
                          ),
                        ),
                      ),
              ),
              Container(
                width: min(600, MediaQuery.of(context).size.width * .9),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Palette.scaffold,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'Qu\'est-ce que c\'est ?',
                        style: TextStyle(
                          color: Palette.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Cette application vous permet d\'avoir un accès direct aux informations importantes du Gala 2023.'
                        'Vous y trouverez notamment une billetterie en ligne, le menu du soir, ainsi qu\'un sous ensemble d\'événements prévus pendant la soirée.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Container(
                width: min(600, MediaQuery.of(context).size.width * .9),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Palette.scaffold,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Auteurs',
                        style: TextStyle(
                          color: Palette.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      buildMenuItem(
                        text: 'Thomas Byr - Développeur',
                        imgPath: 'assets/images/tbyr.jpg',
                        onClicked: () {
                          launchUrlString(url1.toString());
                        },
                      ),
                      buildMenuItem(
                        text: 'Thomas D - Développeur, Graphiste',
                        imgPath: 'assets/images/tdmd.jpg',
                        onClicked: () {
                          launchUrlString(url2.toString());
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Container(
                width: min(600, MediaQuery.of(context).size.width * .9),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Palette.scaffold,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Mentions légales',
                        style: TextStyle(
                          color: Palette.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'La totalité des ressources, textes, icônes et images de cette application sont la propriété des auteurs, des développeurs, des graphistes et des personnes concernées par leur utilisation.'
                        'Toute reproduction, représentation, modification, adaptation, traduction, publication, adaptation de tout ou partie des documents précédents est interdite sans l\'autorisation préalable du développeur.\n\n'
                        'Cette application est distribuée sous la license GNU GPL v3.\n',
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Copyright (c) 2022, ThomasByr.\n'
                        'All rights reserved.\n\n'
                        'Redistribution and use in source and binary forms, with or without '
                        'modification, are permitted provided that the following conditions are met:\n'
                        '- Redistributions of source code must retain the above copyright notice,'
                        ' this list of conditions and the following disclaimer.\n'
                        '- Redistributions in binary form must reproduce the above copyright notice,'
                        ' this list of conditions and the following disclaimer in the documentation'
                        ' and/or other materials provided with the distribution.\n'
                        '- Neither the name of this Web App authors nor the names of its'
                        ' contributors may be used to endorse or promote products derived from'
                        ' this software without specific prior written permission.\n\n'
                        'THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" '
                        'AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE '
                        'IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE '
                        'ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE '
                        'LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR '
                        'CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF '
                        'SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS ; OR BUSINESS '
                        'INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN '
                        'CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) '
                        'ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE '
                        'POSSIBILITY OF SUCH DAMAGE.',
                      ),
                      buildMenuItemIcon(
                        text: 'LICENSE logiciel GPLv3',
                        icon: Icons.balance_rounded,
                        onClicked: () {
                          launchUrlString(url3.toString());
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),
              const Text(
                'Développé avec ❤',
                style: TextStyle(
                  color: Palette.scaffold,
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required String imgPath,
    VoidCallback? onClicked,
  }) {
    const color = Palette.black;
    const hoverColor = Palette.greyDark;
    const textSize = 14.0;

    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      leading: CircleAvatar(
        backgroundColor: Palette.scaffold,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(imgPath),
        ),
      ),
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

  Widget buildMenuItemIcon({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = Palette.black;
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
