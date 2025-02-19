import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_hamalatulquran/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nipController =
      TextEditingController(); // Controller untuk NIP Pengajar
  final _nisnController =
      TextEditingController(); // Controller untuk NISN Wali Santri
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _loginType = 'Pengajar'; // Default ke Pengajar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 83, 172, 86),
      body: Column(
        children: [
          const SizedBox(height: 80),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                height: 120,
              ),
              const SizedBox(width: 10),
              Text(
                "PONDOK PESANTREN\nHAMALATUL QUR'AN",
                textAlign: TextAlign.center,
                style: GoogleFonts.ptSerif(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'Log ',
                          style: GoogleFonts.poppins(
                            color: Colors.green,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: 'in',
                              style: GoogleFonts.poppins(
                                color: Colors.green,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: ' to your account.',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      // Pilihan untuk memilih jenis login dengan radio button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildRadioOption('Pengajar'),
                          const SizedBox(width: 20),
                          _buildRadioOption('Wali Santri'),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Tampilkan form input sesuai dengan tipe login
                      _loginType == 'Pengajar'
                          ? _buildTextField(Icons.person, 'NIP',
                              controller: _nipController)
                          : _buildTextField(Icons.person, 'NISN',
                              controller: _nisnController),
                      const SizedBox(height: 15),
                      _buildTextField(Icons.lock, 'Password',
                          controller: _passwordController, obscureText: true),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot Password?",
                              style: GoogleFonts.poppins(
                                color: Colors.green,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Implementasi login sesuai dengan jenis login
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(
                                        isPengajar: _loginType == 'Pengajar'),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Login',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
            });
          },
          activeColor: Colors.green,
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.green.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(IconData icon, String label,
      {bool obscureText = false, required TextEditingController controller}) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.green.shade800,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: controller,
              obscureText: obscureText,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your $label';
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.green.shade50,
                prefixIcon: Icon(icon, color: Colors.grey.shade600),
                hintText: "Masukkan $label",
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
