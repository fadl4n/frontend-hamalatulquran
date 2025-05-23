import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nipController;
  final TextEditingController nisnController;
  final TextEditingController passwordController;
  final String loginType;
  final bool isLoading;
  final VoidCallback onLogin;
  final ValueChanged<String?> onLoginTypeChange;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.nipController,
    required this.nisnController,
    required this.passwordController,
    required this.loginType,
    required this.isLoading,
    required this.onLogin,
    required this.onLoginTypeChange,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _titleText(),
                SizedBox(height: 30.h),
                _buildLoginTypeSwitcher(),
                SizedBox(height: 10.h),
                loginType == 'Pengajar'
                    ? _buildTextField(Icons.person, 'NIP',
                        controller: nipController)
                    : _buildTextField(Icons.person, 'NISN',
                        controller: nisnController),
                SizedBox(height: 15.h),
                _buildTextField(Icons.lock, 'Password',
                    controller: passwordController, obscureText: true),
                _forgotPasswordButton(),
                SizedBox(height: 30.h),
                _loginButton(context),
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
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: 'in',
            style: GoogleFonts.poppins(
              color: Colors.green,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: ' to your account.',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 20.sp,
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
          groupValue: loginType,
          onChanged: onLoginTypeChange,
          activeColor: Colors.green,
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
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
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: () {},
        child: Text(
          "Forgot Password?",
          style: GoogleFonts.poppins(color: Colors.green),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return SizedBox(
      width: 0.5.sw,
      height: 50.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 14.h),
        ),
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.h,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text('Login',
                style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
      ),
    );
  }
}
