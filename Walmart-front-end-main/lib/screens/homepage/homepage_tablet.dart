import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomepageTablet extends StatelessWidget {
  final User? user;

  const HomepageTablet({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [Text('Homepage')],
    );
  }
}
