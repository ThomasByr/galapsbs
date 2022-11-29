import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../cfg/cfg.dart';

class Splitview extends StatelessWidget {
  const Splitview({
    Key? key,
    Color? this.bg,
    required this.left,
    required this.right,
  }) : super(key: key);

  final Color? bg;
  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    // if page is in portrait mode, use left widget as a drawer
    // else use left widget as a left side of the split view
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          return CupertinoPageScaffold(
            backgroundColor: bg ?? Theme.of(context).scaffoldBackgroundColor,
            child: right,
          );
        } else {
          return CupertinoPageScaffold(
            backgroundColor: bg ?? Theme.of(context).scaffoldBackgroundColor,
            child: Row(
              children: [
                left,
                Expanded(
                  child: right,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
