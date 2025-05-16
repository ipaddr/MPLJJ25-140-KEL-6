import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:project_akhir/providers/auth_provider.dart';
import 'package:project_akhir/screens/welcome_screen.dart';

class AdminProfileTab extends StatefulWidget {
  const AdminProfileTab({super.key});

  @override
  State<AdminProfileTab> createState() => _AdminProfileTabState();
}

class _AdminProfileTabState extends State<AdminProfileTab> {
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;
  File? _coverImage;
  bool _isUpdating = false;

  Future<void> _pickImage(bool isProfileImage) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isProfileImage) {
          _profileImage = File(image.path);
        } else {
          _coverImage = File(image.path);
        }
      });

      // Update the image immediately
      _updateImage(isProfileImage, File(image.path));
    }
  }

  Future<void> _updateImage(bool isProfileImage, File image) async {
    setState(() {
      _isUpdating = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.updateUserProfile(
        profileImage: isProfileImage ? image : null,
        coverImage: !isProfileImage ? image : null,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Provider.of<AuthProvider>(context, listen: false).logout();
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final admin = authProvider.adminModel;
    
    if (admin == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return Scaffold(
      body: _isUpdating
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Cover image
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          image: admin.coverImageUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(admin.coverImageUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: admin.coverImageUrl == null
                            ? const Center(
                                child: Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                  size: 50,
                                ),
                              )
                            : null,
                      ),
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: GestureDetector(
                          onTap: () => _pickImage(false),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.black87,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        right: 10,
                        child: IconButton(
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          onPressed: _logout,
                        ),
                      ),
                      Positioned(
                        bottom: -50,
                        left: 20,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                image: admin.profileImageUrl != null
                                    ? DecorationImage(
                                        image: NetworkImage(admin.profileImageUrl!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                                color: admin.profileImageUrl == null
                                    ? Colors.grey[300]
                                    : null,
                              ),
                              child: admin.profileImageUrl == null
                                  ? const Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                      size: 50,
                                    )
                                  : null,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () => _pickImage(true),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8B0000),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  // Profile info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      left: 140,
                      right: 20,
                      top: 10,
                      bottom: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          admin.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          admin.gender ?? 'Laki-laki',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          '${admin.gender == 'Perempuan' ? 'Usia' : 'Usia'}: 24 Tahun',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Admin info card
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildInfoRow('NIP', admin.nip),
                            const Divider(),
                            _buildInfoRow('Status Kepegawaian', admin.employmentStatus),
                            const Divider(),
                            _buildInfoRow('Tahun Diangkat', admin.appointmentYear),
                            const Divider(),
                            _buildInfoRow('Wilayah Penempatan', admin.placementArea),
                            const Divider(),
                            _buildInfoRow('Golongan', admin.grade),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}