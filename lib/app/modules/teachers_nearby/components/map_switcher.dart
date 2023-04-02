import 'dart:io';

import 'package:flutter/material.dart';

class MapSwitcher extends StatefulWidget {
  const MapSwitcher({super.key, required this.child});

  final Widget child;

  @override
  State<MapSwitcher> createState() => _MapSwitcherState();
}

class _MapSwitcherState extends State<MapSwitcher> {
  var _isPopped = false;

  @override
  Widget build(BuildContext context) {
    return _determineContainer(
      child: !_isPopped ? widget.child : const SizedBox(),
    );
  }

  Widget _determineContainer({Widget child = const SizedBox()}) {
    if (Platform.isAndroid) {
      return WillPopScope(
        child: child,
        onWillPop: () async {
          setState(() {
            _isPopped = true;
          });
          return true;
        },
      );
    } else {
      return child;
    }
  }
}
