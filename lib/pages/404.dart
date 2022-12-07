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
                  'assets/images/gala.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 48),
              const Text(
                '🙊 Oups !',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'La page que vous recherchez n\'existe pas.',
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
