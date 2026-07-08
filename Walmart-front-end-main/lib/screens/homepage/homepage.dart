import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'homepage_desktop.dart';
import 'homepage_mobile.dart';
import 'homepage_tablet.dart';

class HomePageLayout extends StatelessWidget {
  final User? user;
  const HomePageLayout({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: const Text(
            'HOMEPAGE',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth > 1200) {
              return const DesktopHomepage();
            } else if (constraints.maxWidth > 670 &&
                constraints.maxWidth < 1200) {
              return const HomepageTablet();
            } else {
              return const HomepageMobile();
            }
          },
        ));
  }
}
