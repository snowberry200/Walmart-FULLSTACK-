import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walmart/bloc/auth_bloc.dart';
import 'package:walmart/bloc/auth_state.dart';
import 'package:walmart/form/form_widget.dart';
import 'package:walmart/widget/walmart_logo_tablet.dart';
import '../../widget/others.dart';
import '../../layout/password_layout.dart';

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Text text = const Text(
      'Sign in to your Walmart account',
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'BogleWeb'),
    );

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Handle auth state messages
        state.errorMessage;
        // Handle navigation
        if (state.emailContinue) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PasswordLayout(email: state.email),
            ),
          );
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            // Main Content - Takes most space
            Expanded(
              flex: 14,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    WalmartLogo(width: width / 2),
                    const SizedBox(height: 20),
                    text,
                    const SizedBox(height: 10),
                    Center(
                      child: SizedBox(
                        width: width / 4,
                        child: FormWidget(),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            // Bottom Bar - Flexible height
            Flexible(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: OthersInfos(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
