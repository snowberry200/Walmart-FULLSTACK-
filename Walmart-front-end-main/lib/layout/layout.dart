import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/main_screens/desktop.dart';
import '../screens/main_screens/mobile.dart';
import '../screens/main_screens/tablet.dart';

class Layout extends StatelessWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ Use the existing AuthBloc from parent
    return Scaffold(
      backgroundColor: CupertinoColors.white,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth >= 1200) {
            return const DesktopScreen();
          } else if (constraints.maxWidth > 670 &&
              constraints.maxWidth < 1200) {
            return const TabletScreen();
          } else {
            return const MobileScreen();
          }
        },
      ),
    );
  }
}
