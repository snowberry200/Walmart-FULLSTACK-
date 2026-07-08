import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walmart/bloc/auth_bloc.dart';
import 'package:walmart/bloc/auth_state.dart';
import 'package:walmart/form/form_widget.dart';
import 'package:walmart/layout/layout.dart';
import 'package:walmart/layout/password_layout.dart';
import 'package:walmart/widget/image_container.dart';
import 'package:walmart/widget/welcome_screen.dart';
import '../../widget/others.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  final TextEditingController email = TextEditingController();
  ScrollController scrollcontroller = ScrollController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        print('MobileScreen Listener:');
        print('  isSignedIn: ${state.isSignedIn}');
        print('  status: ${state.status}');
        print('  isLoading: ${state.isLoading}');
        print('  errorMessage: ${state.errorMessage}');
        print('  message: ${state.message}');
        print('  emailContinue: ${state.emailContinue}');
        print('  registrationCompleted: ${state.registrationCompleted}');

        // ==========================================
        // 1. HANDLE ERRORS FIRST - HIGHEST PRIORITY
        // ==========================================
        if (state.errorMessage != null &&
            state.errorMessage!.isNotEmpty &&
            !state.isSignUp) {
          _showErrorSnackBar(state.errorMessage!);
          return;
        }

        // ==========================================
        // 2. HANDLE LOADING STATE
        // ==========================================
        if (state.isLoading) {
          CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              const Color.fromARGB(255, 37, 98, 228),
            ),
          );
          return;
        }

        // ==========================================
        // 3. HANDLE SUCCESSFUL SIGN IN
        // ==========================================
        if (state.isSignedIn == true &&
            state.welcome &&
            state.status == 'ACTIVE') {
          print(' User signed in successfully!');
          final userName = state.userData?['name'] ?? '';
          _showSuccessSnackBar(
              'Login successful! Welcome${userName.isNotEmpty ? ' $userName' : ''}');

          // Navigate to welcome screen
          Future.delayed(const Duration(milliseconds: 500), () {
            if (context.mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => WelcomeScreen(
                    userName: userName,
                    email: state.email,
                  ),
                ),
              );
            }
          });
          return; // ✅ STOP HERE
        }

        // ==========================================
        // 4. HANDLE EMAIL CONTINUE (Password screen)
        // ==========================================
        if (state.emailContinue == true) {
          print(' NAVIGATING TO PASSWORD SCREEN');
          print('  email: ${state.email}');

          // Show success message ONLY if there's a meaningful message
          if (state.message != null &&
              state.message!.isNotEmpty &&
              !state.message!.contains('error') &&
              !state.message!.contains('failed')) {
            _showSuccessSnackBar(state.message!);
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PasswordLayout(email: state.email),
            ),
          );
          return; // ✅ STOP HERE
        }

        // ==========================================
        // 5. HANDLE REGISTRATION COMPLETED
        // ==========================================
        if (state.registrationCompleted == true) {
          print('✅ Registration completed');
          _showSuccessSnackBar(
              state.message ?? 'Account created successfully! Please sign in.');

          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Layout(),
                ),
              );
            }
          });
          return;
        }

        // ==========================================
        // 5. HANDLE AUTHENTICATION FAILURE
        // ==========================================
        if (state.status == 'AUTH_FAILED') {
          print('❌ Authentication failed');
          _showErrorSnackBar(state.message ?? 'Invalid email or password');
          return;
        }

        // ==========================================
        // 6. HANDLE INACTIVE USER
        // ==========================================
        if (state.status == 'NOT_ACTIVE' || state.status == 'INACTIVE') {
          print('⚠️ User account is inactive');
          _showErrorSnackBar(state.message ?? 'Your account is inactive');
          return;
        }
      },
      builder: (context, state) {
        // Show loading overlay if isLoading is true
        if (state.isLoading == true) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 37, 98, 228)
                          .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_cart,
                      color: Color.fromARGB(255, 37, 98, 228),
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const CircularProgressIndicator(
                    strokeCap: StrokeCap.round,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(255, 37, 98, 228),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Validating your credentials...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please wait a moment',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Normal UI
        return Scaffold(
          backgroundColor: CupertinoColors.white,
          body: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30,
                    bottom: 40,
                  ),
                  child: ImageContainer(),
                ),
                const Text(
                  'Sign in to your Walmart account',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'BogleWeb',
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 0.0,
                      horizontal: 50,
                    ),
                    child: FormWidget(),
                  ),
                ),
                const SizedBox(height: 60),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.2,
                ),
                SizedBox(
                  height: 220,
                  child: BottomAppBar(
                    color: Colors.transparent,
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 0.0,
                        left: 20,
                        top: 0.0,
                        right: 20,
                      ),
                      child: const OthersInfos(),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
