import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'package:rumahku/providers/auth_provider.dart';
import 'package:rumahku/screens/auth/admin_login_screen.dart';
import 'package:rumahku/utils/app_theme.dart';
import 'package:rumahku/utils/constants.dart';
import 'package:rumahku/widgets/admin_profile_item.dart';
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
      body: authProvider.isLoading
          ? const Center(child: LoadingIndicator())
          : CustomScrollView(
              slivers: [
                // App Bar with Cover Image
                SliverAppBar(
                  expandedHeight: 200.0,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Cover Image
                        _coverImage != null
                            ? Image.memory(_coverImage!, fit: BoxFit.cover)
                            : admin.coverImageUrl != null
                                ? Image.network(admin.coverImageUrl!, fit: BoxFit.cover)
                                : Image.network(
                                    'https://images.pexels.com/photos/305821/pexels-photo-305821.jpeg',
                                    fit: BoxFit.cover,
                                  ),
                        
                        // Gradient Overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        
                        // Edit Cover Button
                        if (_isEditing)
                          Positioned(
                            top: 60,
                            right: 16,
                            child: CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.7),
                              child: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: _pickCoverImage,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  actions: [
                    if (!_isEditing)
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            _isEditing = true;
                          });
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: _logout,
                    ),
                  ],
                ),
                
                // Profile Information
                SliverToBoxAdapter(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Profile Card
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        padding: const EdgeInsets.only(top: 40, bottom: 16, left: 16, right: 16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Admin Name
                            Text(
                              admin.fullName,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            
                            // Gender & Age
                            Text(
                              '${admin.gender ?? 'Tidak disetel'} · ${admin.appointmentYear.isNotEmpty ? '${DateTime.now().year - int.parse(admin.appointmentYear)} Tahun' : 'N/A'}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Profile Edit Form
                            if (_isEditing)
                              Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Full Name
                                    TextFormField(
                                      controller: _fullNameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Nama Lengkap',
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
                                            ),
                                            child: const Text('Simpan'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            else
                              // Admin Information
                              Column(
                                children: [
                                  AdminProfileItem(
                                    label: 'NIP',
                                    value: admin.nip,
                                    icon: Icons.badge,
                                  ),
                                  const SizedBox(height: 8),
                                  AdminProfileItem(
                                    label: 'Status Kepegawaian',
                                    value: admin.employmentStatus,
                                    icon: Icons.work,
                                  ),
                                  const SizedBox(height: 8),
                                  AdminProfileItem(
                                    label: 'Tahun Diangkat',
                                    value: admin.appointmentYear,
                                    icon: Icons.calendar_today,
                                  ),
                                  const SizedBox(height: 8),
                                  AdminProfileItem(
                                    label: 'Wilayah Penempatan',
                                    value: admin.placementArea,
                                    icon: Icons.location_on,
                                  ),
                                  const SizedBox(height: 8),
                                  AdminProfileItem(
                                    label: 'Golongan',
                                    value: admin.rank,
                                    icon: Icons.military_tech,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      
                      // Profile Image
                      Positioned(
                        top: -40,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 38,
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}