import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'package:rumahku/providers/auth_provider.dart';
import 'package:rumahku/screens/auth/admin_login_screen.dart';
import 'package:rumahku/utils/app_theme.dart';
import 'package:rumahku/utils/constants.dart';
import 'package:rumahku/widgets/custom_button.dart';
import 'package:rumahku/widgets/loading_indicator.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  Uint8List? _profileImage;
  Uint8List? _coverImage;
  bool _isEditing = false;

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedGender = 'Laki-laki';
  final _employmentStatusController = TextEditingController();
  final _appointmentYearController = TextEditingController();
  final _placementAreaController = TextEditingController();
  final _rankController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeAdminData();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _employmentStatusController.dispose();
    _appointmentYearController.dispose();
    _placementAreaController.dispose();
    _rankController.dispose();
    super.dispose();
  }

  void _initializeAdminData() {
    final admin = Provider.of<AuthProvider>(context, listen: false).admin;
    if (admin != null) {
      _fullNameController.text = admin.fullName;
      _phoneController.text = admin.phoneNumber;
      _selectedGender = admin.gender ?? 'Laki-laki';
      _employmentStatusController.text = admin.employmentStatus;
      _appointmentYearController.text = admin.appointmentYear;
      _placementAreaController.text = admin.placementArea;
      _rankController.text = admin.rank;
    }
  }

  Future<void> _pickProfileImage() async {
    final pickedImage = await ImagePickerWeb.getImageAsBytes();
    if (pickedImage != null) {
      setState(() {
        _profileImage = pickedImage;
      });
    }
  }

  Future<void> _pickCoverImage() async {
    final pickedImage = await ImagePickerWeb.getImageAsBytes();
    if (pickedImage != null) {
      setState(() {
        _coverImage = pickedImage;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.updateAdminProfile(
      fullName: _fullNameController.text,
      phoneNumber: _phoneController.text,
      gender: _selectedGender,
      employmentStatus: _employmentStatusController.text,
      appointmentYear: _appointmentYearController.text,
      placementArea: _placementAreaController.text,
      rank: _rankController.text,
      profileImage: _profileImage,
      coverImage: _coverImage,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        _isEditing = false;
        _profileImage = null;
        _coverImage = null;
      });
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  Future<void> _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
            (route) => false,
      );
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.red[900],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(' : '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final admin = authProvider.admin;

    if (admin == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please log in to view your profile'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: authProvider.isLoading
          ? const Center(child: LoadingIndicator())
          : Stack(
        children: [
          // Main content
          SingleChildScrollView(
            // Make entire content scrollable
            child: Column(
              children: [
                // Cover image with profile picture
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Cover Image
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: _coverImage != null
                              ? MemoryImage(_coverImage!)
                              : admin.coverImageUrl != null
                              ? NetworkImage(admin.coverImageUrl!)
                              : const NetworkImage(
                            'https://images.pexels.com/photos/305821/pexels-photo-305821.jpeg',
                          ),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5),
                            BlendMode.darken,
                          ),
                        ),
                      ),
                      child: _isEditing
                          ? Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onPressed: _pickCoverImage,
                        ),
                      )
                          : null,
                    ),

                    // Profile picture
                    Positioned(
                      bottom: -50,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 47,
                              backgroundImage: _profileImage != null
                                  ? MemoryImage(_profileImage!)
                                  : admin.profileImageUrl != null
                                  ? NetworkImage(admin.profileImageUrl!)
                                  : const NetworkImage(AppConstants.placeholderProfileImage),
                            ),
                          ),
                          if (_isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: AppTheme.primaryColor,
                                  child: IconButton(
                                    icon: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                                    onPressed: _pickProfileImage,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Space for profile picture overflow
                const SizedBox(height: 60),

                // Admin name and information
                Text(
                  admin.fullName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${admin.gender ?? 'Laki-laki'} - ${DateTime.now().year - int.parse(admin.appointmentYear)} Tahun',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),

                // Admin details or edit form
                _isEditing
                    ? _buildEditForm()
                    : _buildProfileInfo(admin),

                // Add padding at the bottom for the bottom navigation bar
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(admin) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildInfoCard(Icons.badge, 'NIP', admin.nip),
          _buildInfoCard(Icons.work, 'Status Kepegawaian', admin.employmentStatus),
          _buildInfoCard(Icons.date_range, 'Tahun Diangkat', admin.appointmentYear),
          _buildInfoCard(Icons.location_on, 'Wilayah Penempatan', admin.placementArea),
          _buildInfoCard(Icons.military_tech, 'Golongan', admin.rank),
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.red.shade800),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      )),
                  const SizedBox(height: 4),
                  Text(value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full Name
            TextFormField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Phone Number
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Nomor Telepon',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Gender Selection
            Text(
              'Jenis Kelamin',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Row(
              children: [
                Radio<String>(
                  value: 'Laki-laki',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                const Text('Laki-laki'),
                const SizedBox(width: 16),
                Radio<String>(
                  value: 'Perempuan',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                const Text('Perempuan'),
              ],
            ),
            const SizedBox(height: 16),

            // Employment Status
            TextFormField(
              controller: _employmentStatusController,
              decoration: const InputDecoration(
                labelText: 'Status Kepegawaian',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your employment status';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Appointment Year
            TextFormField(
              controller: _appointmentYearController,
              decoration: const InputDecoration(
                labelText: 'Tahun Diangkat',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your appointment year';
                }
                final year = int.tryParse(value);
                if (year == null || year < 1900 || year > DateTime.now().year) {
                  return 'Please enter a valid year';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Placement Area
            TextFormField(
              controller: _placementAreaController,
              decoration: const InputDecoration(
                labelText: 'Wilayah Penempatan',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your placement area';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Rank
            TextFormField(
              controller: _rankController,
              decoration: const InputDecoration(
                labelText: 'Golongan',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your rank';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Save and Cancel Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = false;
                        _profileImage = null;
                        _coverImage = null;
                        _initializeAdminData();
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.red[900],
                    ),
                    child: const Text('Simpan', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}