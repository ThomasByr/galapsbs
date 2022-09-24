//! Gala TPS ESBS - Gala Web App 2023
//!
//! Copyright (c) 2022, ThomasByr.
//! All rights reserved.
//!
//! Redistribution and use in source and binary forms, with or without
//! modification, are permitted provided that the following conditions are met:
//!
//! - Redistributions of source code must retain the above copyright notice,
//!   this list of conditions and the following disclaimer.
//!
//! - Redistributions in binary form must reproduce the above copyright notice,
//!   this list of conditions and the following disclaimer in the documentation
//!   and/or other materials provided with the distribution.
//!
//! - Neither the name of this Web App authors nor the names of its
//!   contributors may be used to endorse or promote products derived from
//!   this software without specific prior written permission.
//!
//! THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//! AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//! IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//! ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//! LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//! CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//! SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//! INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//! CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//! ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//! POSSIBILITY OF SUCH DAMAGE.

import 'package:flutter/material.dart';
import 'package:galapsbs/pages/404.dart';

import 'pages/pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (BuildContext context) => const ErrorPage(),
        );
      },
      debugShowCheckedModeBanner: true,
      title: 'Gala TPS ESBS',
      theme: ThemeData(
<<<<<<< HEAD
        brightness: Brightness.light,
        visualDensity: VisualDensity.standard,
        primaryColorBrightness: Brightness.dark,
        primarySwatch: Colors.amber,
        primaryColor: Color(0xfff0f2f5),
        primaryColorLight: Color(0xff515151),
        primaryColorDark: Color(0xff515151),
        accentColor: Colors.amberAccent,
        canvasColor: Color(0xff515151),
        shadowColor: Color(0xff000000),
        scaffoldBackgroundColor: Color(0xff515151),
        bottomAppBarColor: Color(0xff515151),
        cardColor: Color(0xff515151),
        dividerColor: Color(0xfff0f2f5),
        textTheme: TextTheme(
          headline1: TextStyle(
            color: Color(0xfff0f2f5),
          ),
          headline2: TextStyle(
            color: Color(0xfff0f2f5),
          ),
          headline3: TextStyle(
            color: Color(0xfff0f2f5),
          ),
          headline4: TextStyle(
            color: Color(0xfff0f2f5),
          ),
          headline5: TextStyle(
            color: Color(0xfff0f2f5),
          ),
          headline6: TextStyle(
            color: Color(0xfff0f2f5),
          ),
          overline: TextStyle(
            color: Color(0xff000000),
          ),
          subtitle1: TextStyle(
            color: Color(0xfff0f2f5),
          ),
          subtitle2: TextStyle(
            color: Color(0xfff0f2f5),
          ),
          bodyText1: TextStyle(
            color: Color(0xfff0f2f5),
          ),
          bodyText2: TextStyle(
            color: Color(0xfff0f2f5),
          ),
          button: TextStyle(
            color: Color(0xfff0f2f5),
          ),
          caption: TextStyle(
            color: Color(0xfff0f2f5),
          ),
=======
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 12.0),
>>>>>>> c11a8bd4dbb1cbfbab1f76ff71f63b1b46cf23fc
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.standard,
        primaryColorBrightness: Brightness.dark,
        primarySwatch: Colors.amber,
        primaryColor: Color(0xfff0f2f5),
        primaryColorLight: Color(0xff515151),
        primaryColorDark: Color(0xff515151),
        accentColor: Colors.amberAccent,
        canvasColor: Color(0xff515151),
        shadowColor: Color(0xff000000),
        scaffoldBackgroundColor: Color(0xff515151),
        bottomAppBarColor: Color(0xff515151),
        cardColor: Color(0xff515151),
        dividerColor: Color(0xfff0f2f5),
        textTheme: TextTheme(
          headline1: TextStyle(
            color: Color(0xfff0f2f5),
          ),
          headline2: TextStyle(
            color: Color(0xfff0f2f5),
          ),
          headline3: TextStyle(
            color: Color(0xfff0f2f5),
          ),
          headline4: TextStyle(
            color: Color(0xfff0f2f5),
          ),
          headline5: TextStyle(
            color: Color(0xfff0f2f5),
          ),
          headline6: TextStyle(
            color: Color(0xfff0f2f5),
          ),
          overline: TextStyle(
            color: Color(0xff000000),
          ),
          subtitle1: TextStyle(
            color: Color(0xfff0f2f5),
          ),
          subtitle2: TextStyle(
            color: Color(0xfff0f2f5),
          ),
          bodyText1: TextStyle(
            color: Color(0xfff0f2f5),
          ),
          bodyText2: TextStyle(
            color: Color(0xfff0f2f5),
          ),
          button: TextStyle(
            color: Color(0xfff0f2f5),
          ),
          caption: TextStyle(
            color: Color(0xfff0f2f5),
          ),
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}
