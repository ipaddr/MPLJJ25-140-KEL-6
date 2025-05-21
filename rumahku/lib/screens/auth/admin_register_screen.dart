import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rumahku/providers/auth_provider.dart';
import 'package:rumahku/screens/admin/admin_main_screen.dart';
import 'package:rumahku/screens/auth/admin_login_screen.dart';
import 'package:rumahku/utils/app_theme.dart';
import 'package:rumahku/widgets/custom_button.dart';
import 'package:rumahku/widgets/custom_text_field.dart';
import 'package:rumahku/widgets/loading_indicator.dart';

class AdminRegisterScreen extends StatefulWidget {
  const AdminRegisterScreen({super.key});

  @override
  State<AdminRegisterScreen> createState() => _AdminRegisterScreenState();
}

class _AdminRegisterScreenState extends State<AdminRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nipController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _employmentStatusController = TextEditingController();
  final _appointmentYearController = TextEditingController();
  final _placementAreaController = TextEditingController();
  final _rankController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nipController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _employmentStatusController.dispose();
    _appointmentYearController.dispose();
    _placementAreaController.dispose();
    _rankController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.registerAdmin(
      nip: _nipController.text.trim(),
      fullName: _fullNameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      employmentStatus: _employmentStatusController.text.trim(),
      appointmentYear: _appointmentYearController.text.trim(),
      placementArea: _placementAreaController.text.trim(),
      rank: _rankController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AdminMainScreen()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration failed. Please try again.'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: AppTheme.primaryColor,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Register Header
                  Text(
                    'Sign Up.',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Register Form
                  Card(
                    elevation: 4,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // NIP Field
                            CustomTextField(
                              controller: _nipController,
                              label: 'NIP',
                              keyboardType: TextInputType.number,
                              hintText: 'Masukkan NIP',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your NIP';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            // Full Name Field
                            CustomTextField(
                              controller: _fullNameController,
                              label: 'Nama Lengkap Sesuai NIP',
                              hintText: 'Masukkan nama lengkap',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            // Phone Number Field
                            CustomTextField(
                              controller: _phoneController,
                              label: 'Nomor Telepon',
                              keyboardType: TextInputType.phone,
                              hintText: 'Masukkan nomor telepon',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            // Email Field
                            CustomTextField(
                              controller: _emailController,
                              label: 'Alamat e-mail',
                              keyboardType: TextInputType.emailAddress,
                              hintText: 'Masukkan alamat e-mail',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!EmailValidator.validate(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            // Employment Status Field
                            CustomTextField(
                              controller: _employmentStatusController,
                              label: 'Status Kepegawaian',
                              hintText: 'Masukkan status kepegawaian',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your employment status';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            // Appointment Year Field
                            CustomTextField(
                              controller: _appointmentYearController,
                              label: 'Tahun Diangkat',
                              keyboardType: TextInputType.number,
                              hintText: 'Masukkan tahun diangkat',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your appointment year';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            // Placement Area Field
                            CustomTextField(
                              controller: _placementAreaController,
                              label: 'Wilayah Penempatan',
                              hintText: 'Masukkan wilayah penempatan',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your placement area';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            // Rank Field
                            CustomTextField(
                              controller: _rankController,
                              label: 'Golongan',
                              hintText: 'Masukkan golongan',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your rank';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            // Password Field
                            CustomTextField(
                              controller: _passwordController,
                              label: 'Kata Sandi',
                              obscureText: !_isPasswordVisible,
                              hintText: 'Masukkan kata sandi',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            // Confirm Password Field
                            CustomTextField(
                              controller: _confirmPasswordController,
                              label: 'Konfirmasi Kata Sandi',
                              obscureText: !_isConfirmPasswordVisible,
                              hintText: 'Konfirmasi kata sandi',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),
                            // Register Button
                            authProvider.isLoading
                                ? const Center(child: LoadingIndicator())
                                : CustomButton(
                                    text: 'BUAT AKUN',
                                    onPressed: _register,
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Login Link
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
                        );
                      },
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(color: Colors.white),
                          children: [
                            TextSpan(text: 'Already have an account? '),
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}