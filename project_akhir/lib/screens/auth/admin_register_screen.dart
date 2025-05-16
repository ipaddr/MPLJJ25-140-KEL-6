import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_akhir/providers/auth_provider.dart';
import 'package:project_akhir/screens/admin/admin_main_screen.dart';

class AdminRegisterScreen extends StatefulWidget {
  const AdminRegisterScreen({super.key});

  @override
  State<AdminRegisterScreen> createState() => _AdminRegisterScreenState();
}

class _AdminRegisterScreenState extends State<AdminRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nipController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _employmentStatusController = TextEditingController();
  final _appointmentYearController = TextEditingController();
  final _placementAreaController = TextEditingController();
  final _gradeController = TextEditingController();
  final _passwordController = TextEditingController();
  
  @override
  void dispose() {
    _nipController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _employmentStatusController.dispose();
    _appointmentYearController.dispose();
    _placementAreaController.dispose();
    _gradeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final success = await authProvider.registerAdmin(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        nip: _nipController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        employmentStatus: _employmentStatusController.text.trim(),
        appointmentYear: _appointmentYearController.text.trim(),
        placementArea: _placementAreaController.text.trim(),
        grade: _gradeController.text.trim(),
      );
      
      if (success && mounted) {
        // Navigate to admin main screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AdminMainScreen()),
          (route) => false,
        );
      } else if (mounted) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Pendaftaran gagal'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF8B0000),
              const Color(0xFF8B0000).withOpacity(0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign Up.',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _nipController,
                              decoration: const InputDecoration(
                                labelText: 'NIP',
                                hintText: 'Masukkan NIP',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harap masukkan NIP';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Nama Lengkap Sesuai NIP',
                                hintText: 'Masukkan nama lengkap',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harap masukkan nama lengkap';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Nomor Telepon',
                                hintText: 'Masukkan nomor telepon',
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harap masukkan nomor telepon';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Alamat e-mail',
                                hintText: 'Masukkan alamat e-mail',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harap masukkan alamat e-mail';
                                }
                                if (!value.contains('@') || !value.contains('.')) {
                                  return 'Harap masukkan alamat e-mail yang valid';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: _employmentStatusController,
                              decoration: const InputDecoration(
                                labelText: 'Status Kepegawaian',
                                hintText: 'Masukkan status kepegawaian',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harap masukkan status kepegawaian';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: _appointmentYearController,
                              decoration: const InputDecoration(
                                labelText: 'Tahun Diangkat',
                                hintText: 'Masukkan tahun diangkat',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harap masukkan tahun diangkat';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: _placementAreaController,
                              decoration: const InputDecoration(
                                labelText: 'Wilayah Penempatan',
                                hintText: 'Masukkan wilayah penempatan',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harap masukkan wilayah penempatan';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: _gradeController,
                              decoration: const InputDecoration(
                                labelText: 'Golongan',
                                hintText: 'Masukkan golongan',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harap masukkan golongan';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Kata Sandi',
                                hintText: 'Masukkan kata sandi',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harap masukkan kata sandi';
                                }
                                if (value.length < 6) {
                                  return 'Kata sandi minimal 6 karakter';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 25),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: authProvider.isLoading ? null : _register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.brown[900],
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: authProvider.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Buat Akun',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
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