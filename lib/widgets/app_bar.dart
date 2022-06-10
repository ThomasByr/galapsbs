import 'package:flutter/material.dart';

import '../cfg/cfg.dart';

class MyAppBar extends AppBar {
  MyAppBar(String title, {Key? key, Color? bg})
      : super(
          key: key,
          title: Text(
            title,
            style: const TextStyle(color: Palette.scaffold, fontSize: 30),
          ),
          backgroundColor: bg ?? Palette.bg,
          elevation: 1,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        );
}
