import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../cfg/cfg.dart';

class Splitview extends StatefulWidget {
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
  State<Splitview> createState() => _SplitviewState();
}

class _SplitviewState extends State<Splitview> {
  @override
  Widget build(BuildContext context) {
    // if page is in portrait mode, use left widget as a drawer
    // else use left widget as a left side of the split view
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          return CupertinoPageScaffold(
            backgroundColor: widget.bg ?? Theme.of(context).scaffoldBackgroundColor,
            child: widget.right,
          );
        } else {
          return CupertinoPageScaffold(
            backgroundColor: widget.bg ?? Theme.of(context).scaffoldBackgroundColor,
            child: Row(
              children: [
                widget.left,
                Expanded(
                  child: widget.right,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
