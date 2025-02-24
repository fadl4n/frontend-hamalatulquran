import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_hamalatulquran/pages/home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nipController = TextEditingController();
  final _nisnController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _loginType = 'Pengajar';

  @override
  void dispose() {
    _nipController.dispose();
    _nisnController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 83, 172, 86),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                SizedBox(height: 80.h),
                _logoSection(),
                SizedBox(height: 50.h),
                _formSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/logo.png',
          height: 100.h,
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
    return SizedBox(
      // Ganti Expanded jadi SizedBox
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.8,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.r),
            topRight: Radius.circular(50.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Biar ukuran minimal, tidak terlalu besar
              children: [
                _titleText(),
                SizedBox(height: 15.h),
                _buildLoginTypeSwitcher(),
                SizedBox(height: 20.h),
                _loginType == 'Pengajar'
                    ? _buildTextField(Icons.person, 'NIP',
                        controller: _nipController)
                    : _buildTextField(Icons.person, 'NISN',
                        controller: _nisnController),
                SizedBox(height: 15.h),
                _buildTextField(Icons.lock, 'Password',
                    controller: _passwordController, obscureText: true),
                SizedBox(height: 5.h),
                _forgotPasswordButton(),
                SizedBox(height: 30.h),
                _loginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleText() {
    return Text.rich(
      TextSpan(
        text: 'Log ',
        style: GoogleFonts.poppins(
          color: Colors.green,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: 'in',
            style: GoogleFonts.poppins(
              color: Colors.green,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: ' to your account.',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLoginTypeSwitcher() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRadioOption('Pengajar'),
        SizedBox(width: 15.w),
        _buildRadioOption('Wali Santri'),
      ],
    );
  }

  Widget _buildRadioOption(String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: _loginType,
          onChanged: (String? newValue) {
            setState(() {
              _loginType = newValue!;
              _nipController.clear();
              _nisnController.clear();
              _passwordController.clear();
            });
          },
          activeColor: Colors.green,
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            color: Colors.green.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(IconData icon, String label,
      {bool obscureText = false, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.green.shade800,
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        ),
        SizedBox(height: 5.h),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: (value) => value == null || value.isEmpty
              ? 'Please enter your $label'
              : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.green.shade50,
            prefixIcon: Icon(icon, color: Colors.grey.shade600),
            hintText: "Masukkan $label",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _forgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: Text(
          "Forgot Password?",
          style: GoogleFonts.poppins(
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return SizedBox(
      width: 0.5.sw,
      height: 50.h,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  print("Login sebagai: $_loginType"); // Tambahkan debugging
                  print(
                      "isPengajar dikirim ke HomePage: ${_loginType == 'Pengajar'}");
                  return HomePage(isPengajar: _loginType == 'Pengajar');
                },
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Text('Login',
            style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );
  }
}
