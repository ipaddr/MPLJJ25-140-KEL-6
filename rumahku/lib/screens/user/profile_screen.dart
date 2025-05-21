import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'package:rumahku/providers/auth_provider.dart';
import 'package:rumahku/screens/auth/user_login_screen.dart';
import 'package:rumahku/utils/app_theme.dart';
import 'package:rumahku/utils/constants.dart';
import 'package:rumahku/widgets/custom_button.dart';
import 'package:rumahku/widgets/loading_indicator.dart';
import 'package:rumahku/widgets/profile_stat_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? _profileImage;
  Uint8List? _coverImage;
  bool _isEditing = false;

  final _formKey = GlobalKey<FormState>();
  final _familyMembersController = TextEditingController();
  String _selectedGender = 'Laki-laki';
  String _selectedResidenceStatus = 'Tetap';
  String _selectedOwnershipYear = '2020';
  String _selectedOwnershipStatus = 'Milik Sendiri';
  String _selectedWaterStatus = 'PDAM';
  String _selectedHumidityStatus = 'Cukup Lembab';
  String _selectedEnvironmentStatus = 'Baik';

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  @override
  void dispose() {
    _familyMembersController.dispose();
    super.dispose();
  }

  void _initializeUserData() {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      _selectedGender = user.gender ?? 'Laki-laki';
      _familyMembersController.text = user.familyMembers?.toString() ?? '';
      _selectedResidenceStatus = user.residenceStatus ?? 'Tetap';
      _selectedOwnershipYear = user.ownershipYear ?? '2020';
      _selectedOwnershipStatus = user.ownershipStatus ?? 'Milik Sendiri';
      _selectedWaterStatus = user.waterStatus ?? 'PDAM';
      _selectedHumidityStatus = user.humidityStatus ?? 'Cukup Lembab';
      _selectedEnvironmentStatus = user.environmentStatus ?? 'Baik';
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
    final success = await authProvider.updateUserProfile(
      gender: _selectedGender,
      familyMembers: int.tryParse(_familyMembersController.text),
      residenceStatus: _selectedResidenceStatus,
      ownershipYear: _selectedOwnershipYear,
      ownershipStatus: _selectedOwnershipStatus,
      waterStatus: _selectedWaterStatus,
      humidityStatus: _selectedHumidityStatus,
      environmentStatus: _selectedEnvironmentStatus,
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
        MaterialPageRoute(builder: (context) => const UserLoginScreen()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
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
                      : user.coverImageUrl != null
                      ? Image.network(user.coverImageUrl!, fit: BoxFit.cover)
                      : Image.network(
                    'https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg',
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
                      // User Name
                      Text(
                        user.fullName,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),

                      // Gender
                      Text(
                        user.gender ?? 'Tidak disetel',
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

                              // Family Members
                              Text(
                                'Jumlah Anggota Keluarga',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              TextFormField(
                                controller: _familyMembersController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Masukkan jumlah anggota keluarga',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the number of family members';
                                  }
                                  final number = int.tryParse(value);
                                  if (number == null || number < 1) {
                                    return 'Please enter a valid number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Residence Status
                              Text(
                                'Status Hunian',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              DropdownButtonFormField<String>(
                                value: _selectedResidenceStatus,
                                decoration: const InputDecoration(
                                  hintText: 'Pilih status hunian',
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'Tetap', child: Text('Tetap')),
                                  DropdownMenuItem(value: 'Sementara', child: Text('Sementara')),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedResidenceStatus = value!;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),

                              // Ownership Year
                              Text(
                                'Tahun Kepemilikan',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              DropdownButtonFormField<String>(
                                value: _selectedOwnershipYear,
                                decoration: const InputDecoration(
                                  hintText: 'Pilih tahun kepemilikan',
                                ),
                                items: List.generate(30, (index) {
                                  final year = (DateTime.now().year - index).toString();
                                  return DropdownMenuItem(value: year, child: Text(year));
                                }),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedOwnershipYear = value!;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),

                              // Ownership Status
                              Text(
                                'Status Kepemilikan',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              DropdownButtonFormField<String>(
                                value: _selectedOwnershipStatus,
                                decoration: const InputDecoration(
                                  hintText: 'Pilih status kepemilikan',
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'Milik Sendiri', child: Text('Milik Sendiri')),
                                  DropdownMenuItem(value: 'Sewa', child: Text('Sewa')),
                                  DropdownMenuItem(value: 'Menumpang', child: Text('Menumpang')),
                                  DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya')),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedOwnershipStatus = value!;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),

                              // Water Status
                              Text(
                                'Status Air',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              DropdownButtonFormField<String>(
                                value: _selectedWaterStatus,
                                decoration: const InputDecoration(
                                  hintText: 'Pilih status air',
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'PDAM', child: Text('PDAM')),
                                  DropdownMenuItem(value: 'Sumur', child: Text('Sumur')),
                                  DropdownMenuItem(value: 'Sungai', child: Text('Sungai')),
                                  DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya')),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedWaterStatus = value!;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),

                              // Humidity Status
                              Text(
                                'Status Kelembapan',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              DropdownButtonFormField<String>(
                                value: _selectedHumidityStatus,
                                decoration: const InputDecoration(
                                  hintText: 'Pilih status kelembapan',
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'Cukup Lembab', child: Text('Cukup Lembab')),
                                  DropdownMenuItem(value: 'Sangat Lembab', child: Text('Sangat Lembab')),
                                  DropdownMenuItem(value: 'Kering', child: Text('Kering')),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedHumidityStatus = value!;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),

                              // Environment Status
                              Text(
                                'Status Lingkungan',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              DropdownButtonFormField<String>(
                                value: _selectedEnvironmentStatus,
                                decoration: const InputDecoration(
                                  hintText: 'Pilih status lingkungan',
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'Baik', child: Text('Baik')),
                                  DropdownMenuItem(value: 'Cukup', child: Text('Cukup')),
                                  DropdownMenuItem(value: 'Buruk', child: Text('Buruk')),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedEnvironmentStatus = value!;
                                  });
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
                                          _initializeUserData();
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
                      // Profile Stats
                        Column(
                          children: [
                            // First Row
                            Row(
                              children: [
                                Expanded(
                                  child: ProfileStatCard(
                                    title: 'Jumlah Anggota Keluarga',
                                    value: user.familyMembers?.toString() ?? 'Tidak disetel',
                                    icon: Icons.people,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ProfileStatCard(
                                    title: 'Status Penerima Bantuan',
                                    value: user.aidStatus ?? 'Tidak Menerima',
                                    icon: Icons.volunteer_activism,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Second Row
                            Row(
                              children: [
                                Expanded(
                                  child: ProfileStatCard(
                                    title: 'Status Hunian',
                                    value: user.residenceStatus ?? 'Tidak disetel',
                                    icon: Icons.home,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ProfileStatCard(
                                    title: 'Tahun Kepemilikan',
                                    value: user.ownershipYear ?? 'Tidak disetel',
                                    icon: Icons.calendar_today,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Third Row
                            Row(
                              children: [
                                Expanded(
                                  child: ProfileStatCard(
                                    title: 'Status Kepemilikan',
                                    value: user.ownershipStatus ?? 'Tidak disetel',
                                    icon: Icons.key,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ProfileStatCard(
                                    title: 'Status Air',
                                    value: user.waterStatus ?? 'Tidak disetel',
                                    icon: Icons.water_drop,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Fourth Row
                            Row(
                              children: [
                                Expanded(
                                  child: ProfileStatCard(
                                    title: 'Status Kelembapan',
                                    value: user.humidityStatus ?? 'Tidak disetel',
                                    icon: Icons.thermostat,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ProfileStatCard(
                                    title: 'Status Lingkungan',
                                    value: user.environmentStatus ?? 'Tidak disetel',
                                    icon: Icons.nature_people,
                                  ),
                                ),
                              ],
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
                                : user.profileImageUrl != null
                                ? NetworkImage(user.profileImageUrl!)
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