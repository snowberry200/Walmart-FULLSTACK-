import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:walmart/layout/layout.dart';
import '../../widget/auth.dart';

class DesktopHomepage extends StatelessWidget {
  final User? user;

  const DesktopHomepage({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authClient = AuthenticationClient();
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Homepage'),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color.fromARGB(255, 37, 98, 228),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              minimumSize: const Size.fromHeight(50),
              fixedSize: const Size(150, 30),
            ),
            onPressed: () async {
              await authClient.logOut();
              (BuildContext context) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const Layout(),
                    ),
                    (route) => false);
              };
            },
            child: const Text('Sign out'),
          )
        ]);
  }
}
