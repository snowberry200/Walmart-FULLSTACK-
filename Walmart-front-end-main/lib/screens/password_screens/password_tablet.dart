import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:walmart/screens/password_screens/password_mobile_form.dart';

class PasswordTablet extends StatefulWidget {
  final String callback;

  const PasswordTablet({Key? key, required this.callback}) : super(key: key);

  @override
  State<PasswordTablet> createState() => _PasswordTabletState();
}

class _PasswordTabletState extends State<PasswordTablet> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: CupertinoColors.white,
        body: Center(
            child: SizedBox(
          width: width / 1.7,
          child: PasswordMobileForm(
            callback: widget.callback,
          ),
        )));
  }
}
