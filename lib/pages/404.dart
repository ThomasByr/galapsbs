import 'package:flutter/material.dart';

import '../cfg/cfg.dart';
import '../widgets/widgets.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      // drawer: const NavigationDrawerWidget(),
      appBar: MyAppBar('🔍 404'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 48),
              SizedBox(
                height: 200,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 48),
              const Text(
                '🙊 Oups !',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Palette.scaffold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'La page que vous recherchez n\'existe pas.',
                style: TextStyle(
                  fontSize: 16,
                  color: Palette.scaffold,
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
