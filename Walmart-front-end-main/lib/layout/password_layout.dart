import 'package:flutter/cupertino.dart';

import '../screens/password_screens/password_desktop.dart';
import '../screens/password_screens/password_mobile_form.dart';
import '../screens/password_screens/password_tablet.dart';

class PasswordLayout extends StatelessWidget {
  // ✅ StatelessWidget
  final String email;

  const PasswordLayout({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ Use existing AuthBloc - don't create a new BlocProvider
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return constraints.maxWidth > 1200
            ? PasswordDesktop(callback: email)
            : constraints.maxWidth > 670 && constraints.maxWidth < 1200
                ? PasswordTablet(callback: email)
                : PasswordMobileForm(callback: email);
      },
    );
  }
}
