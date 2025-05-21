import 'package:flutter/material.dart';

class UserSignUpScreen extends StatefulWidget {
  const UserSignUpScreen({super.key});

  @override
  State<UserSignUpScreen> createState() => _UserSignUpScreenState();
}

class _UserSignUpScreenState extends State<UserSignUpScreen> {
  final TextEditingController nikController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nikController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nikController,
                decoration: const InputDecoration(labelText: 'NIK'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12.0),
              TextField(
                controller: fullNameController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
              ),
              const SizedBox(height: 12.0),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12.0),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Alamat Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12.0),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 12.0),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Kata Sandi'),
                obscureText: true,
              ),
              const SizedBox(height: 24.0),
              const Text(
                'Lampirkan Foto',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300], // Placeholder for image
                        child: const Icon(Icons.camera_alt, size: 40),
                      ),
                      const SizedBox(height: 4.0),
                      const Text('Swafoto'),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300], // Placeholder for image
                        child: const Icon(Icons.camera_alt, size: 40),
                      ),
                      const SizedBox(height: 4.0),
                      const Text('Foto KTP'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement sign up logic
                },
                child: const Text('Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}