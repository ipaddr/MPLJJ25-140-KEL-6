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

  // Konstanta untuk nilai dropdown
  static const String GENDER_MALE = 'Laki-laki';
  static const String GENDER_FEMALE = 'Perempuan';

  static const String RESIDENCE_PERMANENT = 'Tetap';
  static const String RESIDENCE_TEMPORARY = 'Sementara';
  static const String RESIDENCE_OBSERVE = 'Layak - Perlu Observasi';

  static const String OWNERSHIP_SELF = 'Milik Sendiri';
  static const String OWNERSHIP_RENT = 'Sewa';
  static const String OWNERSHIP_SHARED = 'Menumpang';
  static const String OWNERSHIP_OTHER = 'Lainnya';

  static const String WATER_PDAM = 'PDAM';
  static const String WATER_WELL = 'Sumur';
  static const String WATER_RIVER = 'Sungai';
  static const String WATER_GOOD = 'Cukup Baik';
  static const String WATER_OTHER = 'Lainnya';

  static const String HUMIDITY_MEDIUM = 'Cukup Lembab';
  static const String HUMIDITY_HIGH = 'Sangat Lembab';
  static const String HUMIDITY_DRY = 'Kering';

  static const String ENV_GOOD = 'Baik';
  static const String ENV_MEDIUM = 'Cukup';
  static const String ENV_BAD = 'Buruk';

  String _selectedGender = GENDER_MALE;
  String _selectedResidenceStatus = RESIDENCE_PERMANENT;
  String _selectedOwnershipYear = '2020';
  String _selectedOwnershipStatus = OWNERSHIP_SELF;
  String _selectedWaterStatus = WATER_PDAM;
  String _selectedHumidityStatus = HUMIDITY_MEDIUM;
  String _selectedEnvironmentStatus = ENV_GOOD;

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
      // Pastikan nilai yang kita set ada dalam daftar dropdown
      setState(() {
        _selectedGender = _normalizeGender(user.gender);
        _familyMembersController.text = user.familyMembers?.toString() ?? '';
        _selectedResidenceStatus = _normalizeResidenceStatus(user.residenceStatus);
        _selectedOwnershipYear = user.ownershipYear ?? '2020';
        _selectedOwnershipStatus = _normalizeOwnershipStatus(user.ownershipStatus);
        _selectedWaterStatus = _normalizeWaterStatus(user.waterStatus);
        _selectedHumidityStatus = _normalizeHumidityStatus(user.humidityStatus);
        _selectedEnvironmentStatus = _normalizeEnvironmentStatus(user.environmentStatus);
      });
    }
  }

  // Fungsi normalisasi untuk memastikan nilai dalam dropdown ada
  String _normalizeGender(String? value) {
    if (value == GENDER_MALE) return GENDER_MALE;
    if (value == GENDER_FEMALE) return GENDER_FEMALE;
    return GENDER_MALE; // Default
  }

  String _normalizeResidenceStatus(String? value) {
    if (value == RESIDENCE_PERMANENT) return RESIDENCE_PERMANENT;
    if (value == RESIDENCE_TEMPORARY) return RESIDENCE_TEMPORARY;
    if (value == RESIDENCE_OBSERVE) return RESIDENCE_OBSERVE;
    return RESIDENCE_PERMANENT; // Default
  }

  String _normalizeOwnershipStatus(String? value) {
    if (value == OWNERSHIP_SELF) return OWNERSHIP_SELF;
    if (value == OWNERSHIP_RENT) return OWNERSHIP_RENT;
    if (value == OWNERSHIP_SHARED) return OWNERSHIP_SHARED;
    if (value == OWNERSHIP_OTHER) return OWNERSHIP_OTHER;
    return OWNERSHIP_SELF; // Default
  }

  String _normalizeWaterStatus(String? value) {
    if (value == WATER_PDAM) return WATER_PDAM;
    if (value == WATER_WELL) return WATER_WELL;
    if (value == WATER_RIVER) return WATER_RIVER;
    if (value == WATER_GOOD) return WATER_GOOD;
    if (value == WATER_OTHER) return WATER_OTHER;
    return WATER_PDAM; // Default
  }

  String _normalizeHumidityStatus(String? value) {
    if (value == HUMIDITY_MEDIUM) return HUMIDITY_MEDIUM;
    if (value == HUMIDITY_HIGH) return HUMIDITY_HIGH;
    if (value == HUMIDITY_DRY) return HUMIDITY_DRY;
    return HUMIDITY_MEDIUM; // Default
  }

  String _normalizeEnvironmentStatus(String? value) {
    if (value == ENV_GOOD) return ENV_GOOD;
    if (value == ENV_MEDIUM) return ENV_MEDIUM;
    if (value == ENV_BAD) return ENV_BAD;
    return ENV_GOOD; // Default
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
          : SingleChildScrollView(
        child: Column(
          children: [
            // Cover Image Section
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Cover Image
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _coverImage != null
                          ? MemoryImage(_coverImage!)
                          : user.coverImageUrl != null
                          ? NetworkImage(user.coverImageUrl!)
                          : const NetworkImage(
                          'https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                ),

                // Edit Cover Button
                if (_isEditing)
                  Positioned(
                    top: 80,
                    right: 16,
                    child: CircleAvatar(
                      backgroundColor:Color(0xFFFFD0FF).withOpacity(0.7),
                      child: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: _pickCoverImage,
                      ),
                    ),
                  ),

                // Profile Image
                Positioned(
                  bottom: -50,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0xFFFFD0FF),
                        child: CircleAvatar(
                          radius: 48,
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
                            radius: 20,
                            backgroundColor: Color(0xFFFFD0FF),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: AppTheme.primaryColor,
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
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

            // User Name & Gender
            Container(
              margin: const EdgeInsets.only(top: 60),
              child: Column(
                children: [
                  Text(
                    user.fullName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.gender ?? 'Tidak disetel',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Profile information
            Container(
              padding: const EdgeInsets.all(16),
              child: _isEditing ? _buildEditForm() : _buildProfileInfo(user),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? AppTheme.primaryColor : Colors.grey,
        ),
        Text(
          label,
          style: TextStyle(
            color: isActive ? AppTheme.primaryColor : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo(user) {
    return Column(
      children: [
        // Main Info Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Jumlah Anggota Keluarga',
                  style: TextStyle(
                    color: Color.fromARGB(255, 5, 5, 5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  ': ${user.familyMembers?.toString() ?? '0'} Orang',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                const Text(
                  'Status Hunian',
                  style: TextStyle(
                    color: Color.fromARGB(255, 5, 5, 5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  ': ${user.residenceStatus ?? 'Tidak disetel'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                const Text(
                  'Tahun Kepemilikan',
                  style: TextStyle(
                    color: Color.fromARGB(255, 5, 5, 5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  ': ${user.ownershipYear ?? 'Tidak disetel'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // First Row of Status Cards
        Row(
          children: [
            Expanded(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.home, color: Color(0xFF003837)),
                      const SizedBox(height: 8),
                      const Text(
                        'Status Kepemilikan',
                        style: TextStyle(
                          color:Color.fromARGB(255, 5, 5, 5),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.ownershipStatus ?? 'Tidak disetel',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.water_drop,color: Color(0xFF003837)),
                      const SizedBox(height: 8),
                      const Text(
                        'Status Air',
                        style: TextStyle(
                          color: Color.fromARGB(255, 5, 5, 5),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.waterStatus ?? 'Tidak disetel',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Second Row of Status Cards
        Row(
          children: [
            Expanded(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.thermostat, color: Color(0xFF003837)),

                      const SizedBox(height: 8),
                      const Text(
                        'Status Kelembapan',
                        style: TextStyle(
                          color: Color.fromARGB(255, 5, 5, 5),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.humidityStatus ?? 'Tidak disetel',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.nature_people, color: Color(0xFF003837)),
                      const SizedBox(height: 8),
                      const Text(
                        'Status Lingkungan',
                        style: TextStyle(
                          color: Color.fromARGB(255, 5, 5, 5),

                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.environmentStatus ?? 'Tidak disetel',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditForm() {
    return Form(
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
                value: GENDER_MALE,
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
                value: GENDER_FEMALE,
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
            items: [
              DropdownMenuItem(value: RESIDENCE_PERMANENT, child: Text(RESIDENCE_PERMANENT)),
              DropdownMenuItem(value: RESIDENCE_TEMPORARY, child: Text(RESIDENCE_TEMPORARY)),
              DropdownMenuItem(value: RESIDENCE_OBSERVE, child: Text(RESIDENCE_OBSERVE)),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedResidenceStatus = value;
                });
              }
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
              if (value != null) {
                setState(() {
                  _selectedOwnershipYear = value;
                });
              }
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
            items: [
              DropdownMenuItem(value: OWNERSHIP_SELF, child: Text(OWNERSHIP_SELF)),
              DropdownMenuItem(value: OWNERSHIP_RENT, child: Text(OWNERSHIP_RENT)),
              DropdownMenuItem(value: OWNERSHIP_SHARED, child: Text(OWNERSHIP_SHARED)),
              DropdownMenuItem(value: OWNERSHIP_OTHER, child: Text(OWNERSHIP_OTHER)),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedOwnershipStatus = value;
                });
              }
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
            items: [
              DropdownMenuItem(value: WATER_PDAM, child: Text(WATER_PDAM)),
              DropdownMenuItem(value: WATER_WELL, child: Text(WATER_WELL)),
              DropdownMenuItem(value: WATER_RIVER, child: Text(WATER_RIVER)),
              DropdownMenuItem(value: WATER_GOOD, child: Text(WATER_GOOD)),
              DropdownMenuItem(value: WATER_OTHER, child: Text(WATER_OTHER)),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedWaterStatus = value;
                });
              }
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
            items: [
              DropdownMenuItem(value: HUMIDITY_MEDIUM, child: Text(HUMIDITY_MEDIUM)),
              DropdownMenuItem(value: HUMIDITY_HIGH, child: Text(HUMIDITY_HIGH)),
              DropdownMenuItem(value: HUMIDITY_DRY, child: Text(HUMIDITY_DRY)),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedHumidityStatus = value;
                });
              }
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
            items: [
              DropdownMenuItem(value: ENV_GOOD, child: Text(ENV_GOOD)),
              DropdownMenuItem(value: ENV_MEDIUM, child: Text(ENV_MEDIUM)),
              DropdownMenuItem(value: ENV_BAD, child: Text(ENV_BAD)),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedEnvironmentStatus = value;
                });
              }
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
    );
  }
}