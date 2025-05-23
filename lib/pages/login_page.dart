import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:frontend_hamalatulquran/widgets/login/login_form.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_hamalatulquran/pages/home_page.dart';

import '../services/auth/auth_service.dart';
import '../services/utils/snackbar_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _nisnController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _loginType = 'Pengajar';
  bool _isLoading = false;

  @override
  void dispose() {
    _nipController.dispose();
    _nisnController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String identifier =
        _loginType == 'Pengajar' ? _nipController.text : _nisnController.text;
    String password = _passwordController.text;

    try {
      String role = await AuthService().loginAndSave(identifier, password);
      bool isPengajar = role == "pengajar"; // Cek Role dari API

      debugPrint("🔀 Navigasi ke HomePage (isPengajar: $isPengajar)");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(isPengajar: isPengajar),
        ),
      );
    } catch (e) {
      SnackbarHelper.showError(context, e.toString());
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 83, 172, 86),
      body: SafeArea(
        child: KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  SizedBox(height: isKeyboardVisible ? 20.h : 50.h),
                  if (!isKeyboardVisible) _logoSection(),
                  SizedBox(height: isKeyboardVisible ? 20.h : 50.h),
                  _formSection()
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _logoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/logo.png',
          height: 90.h,
        ),
        SizedBox(width: 10.w),
        Text(
          "PONDOK PESANTREN\nHAMALATUL QUR'AN",
          textAlign: TextAlign.center,
          style: GoogleFonts.ptSerif(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _formSection() {
    return LoginForm(
      formKey: _formKey,
      nipController: _nipController,
      nisnController: _nisnController,
      passwordController: _passwordController,
      loginType: _loginType,
      isLoading: _isLoading,
      onLogin: handleLogin,
      onLoginTypeChange: (newValue) {
        setState(() {
          _loginType = newValue!;
          _nipController.clear();
          _nisnController.clear();
          _passwordController.clear();
        });
      },
    );
  }
}
