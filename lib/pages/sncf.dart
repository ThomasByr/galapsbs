import 'package:flutter/material.dart';

import '../cfg/cfg.dart';
import '../widgets/widgets.dart';
import '../helper/splitview.dart';

class SncfPage extends StatefulWidget {
  const SncfPage({Key? key}) : super(key: key);
  @override
  _SncfPageState createState() => _SncfPageState();
}

class _SncfPageState extends State<SncfPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MediaQuery.of(context).size.width < breakpoint ? NavigationDrawerWidget() : null,
      appBar: MyAppBar('🚂 SNCF'),
      body: Splitview(
        left: NavigationDrawerWidget(),
        right: Container(),
      ),
    );
  }
}
