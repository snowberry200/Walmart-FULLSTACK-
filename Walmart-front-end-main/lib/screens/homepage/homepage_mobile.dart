import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomepageMobile extends StatelessWidget {
  final User? user;

  const HomepageMobile({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [Text('Homepage')],
    );
  }
}
