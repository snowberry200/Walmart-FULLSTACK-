import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walmart/screens/password_screens/password_mobile_form.dart';

class PasswordDesktop extends StatefulWidget {
  final String callback;

  const PasswordDesktop({Key? key, required this.callback}) : super(key: key);

  @override
  State<PasswordDesktop> createState() => _PasswordDesktopState();
}

class _PasswordDesktopState extends State<PasswordDesktop> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: CupertinoColors.white,
        body: Center(
            child: SizedBox(
          width: width / 3,
          child: PasswordMobileForm(
            callback: widget.callback,
          ),
        )));
  }

  Future<void> launchLink() async {
    const url = 'https://www.walmart.com/account/login?vid=oaoh';
    if (await canLaunchUrl(url as Uri)) {
      await launchUrl(url as Uri);
    } else {
      throw 'Couldn\'t launch url';
    }
  }
}
