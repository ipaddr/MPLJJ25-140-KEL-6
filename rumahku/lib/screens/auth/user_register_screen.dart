import 'dart:typed_data';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'package:rumahku/providers/auth_provider.dart';
import 'package:rumahku/screens/auth/user_login_screen.dart';
import 'package:rumahku/screens/user/user_main_screen.dart';
import 'package:rumahku/utils/app_theme.dart';
import 'package:rumahku/widgets/custom_button.dart';
import 'package:rumahku/widgets/custom_text_field.dart';
import 'package:rumahku/widgets/image_picker_field.dart';
import 'package:rumahku/widgets/loading_indicator.dart';

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({super.key});

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nikController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Uint8List? _ktpImage;
  Uint8List? _selfieImage;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nikController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickKtpImage() async {
    final pickedImage = await ImagePickerWeb.getImageAsBytes();
    if (pickedImage != null) {
      setState(() {
        _ktpImage = pickedImage;
      });
    }
  }

  Future<void> _pickSelfieImage() async {
    final pickedImage = await ImagePickerWeb.getImageAsBytes();
    if (pickedImage != null) {
      setState(() {
        _selfieImage = pickedImage;
      });
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_ktpImage == null || _selfieImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload both KTP and selfie images'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.registerUser(
      nik: _nikController.text.trim(),
      fullName: _fullNameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      ktpImage: _ktpImage,
      selfieImage: _selfieImage,
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const UserMainScreen()),
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
      backgroundColor: Color(0xFF366767),

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
                            // NIK Field
                            CustomTextField(
                              controller: _nikController,
                              label: 'NIK',
                              keyboardType: TextInputType.number,
                              hintText: 'Masukkan NIK',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your NIK';
                                }
                                if (value.length != 16) {
                                  return 'NIK must be 16 digits';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            // Full Name Field
                            CustomTextField(
                              controller: _fullNameController,
                              label: 'Nama Lengkap Sesuai KTP',
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
                            // Username Field
                            CustomTextField(
                              controller: _usernameController,
                              label: 'Username',
                              hintText: 'Masukkan username untuk login',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a username';
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
                            const SizedBox(height: 20),
                            // Image Upload Fields
                            Text(
                              'Lampiran Foto',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ImagePickerField(
                                    label: 'Swafoto dengan KTP',
                                    imageData: _selfieImage,
                                    onTap: _pickSelfieImage,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ImagePickerField(
                                    label: 'Foto KTP',
                                    imageData: _ktpImage,
                                    onTap: _pickKtpImage,
                                  ),
                                ),
                              ],
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
                          MaterialPageRoute(builder: (context) => const UserLoginScreen()),
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