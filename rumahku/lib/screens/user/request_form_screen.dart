import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rumahku/providers/request_provider.dart';
import 'package:rumahku/utils/app_theme.dart';
import 'package:rumahku/widgets/custom_button.dart';
import 'package:rumahku/widgets/custom_text_field.dart';
import 'package:rumahku/widgets/image_picker_field.dart';
import 'package:rumahku/widgets/loading_indicator.dart';
import 'package:rumahku/widgets/step_indicator.dart';

class RequestFormScreen extends StatefulWidget {
  const RequestFormScreen({super.key});

  @override
  State<RequestFormScreen> createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends State<RequestFormScreen> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  
  // Personal Data Form Controllers
  final _familyCardController = TextEditingController();
  final _nikController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _occupationController = TextEditingController();
  final _provinceController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _villageController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  // House Data Form Controllers
  final _buildingYearController = TextEditingController();
  final _electricVoltageController = TextEditingController();
  final _buildingAreaController = TextEditingController();
  final _landAreaController = TextEditingController();
  final _buildingTypeController = TextEditingController();
  
  // Form Data
  DateTime? _selectedBirthDate;
  String _selectedGender = 'Laki-laki';
  String _selectedMaritalStatus = 'Belum Kawin';
  String _selectedOwnershipStatus = 'Milik Sendiri';
  String _selectedWaterStatus = 'PDAM';
  Uint8List? _frontPhoto;
  Uint8List? _backPhoto;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize request form data
    final requestProvider = Provider.of<RequestProvider>(context, listen: false);
    requestProvider.resetForm();
  }
  
  @override
  void dispose() {
    // Dispose all controllers
    _familyCardController.dispose();
    _nikController.dispose();
    _fullNameController.dispose();
    _birthPlaceController.dispose();
    _birthDateController.dispose();
    _occupationController.dispose();
    _provinceController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _villageController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _buildingYearController.dispose();
    _electricVoltageController.dispose();
    _buildingAreaController.dispose();
    _landAreaController.dispose();
    _buildingTypeController.dispose();
    super.dispose();
  }
  
  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(1990),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }
  
  Future<void> _pickFrontPhoto() async {
    final pickedImage = await ImagePickerWeb.getImageAsBytes();
    if (pickedImage != null) {
      setState(() {
        _frontPhoto = pickedImage;
      });
    }
  }
  
  Future<void> _pickBackPhoto() async {
    final pickedImage = await ImagePickerWeb.getImageAsBytes();
    if (pickedImage != null) {
      setState(() {
        _backPhoto = pickedImage;
      });
    }
  }
  
  bool _validateStep1() {
    if (_formKey1.currentState?.validate() ?? false) {
      // Save personal data to request provider
      final requestProvider = Provider.of<RequestProvider>(context, listen: false);
      requestProvider.updateFormData({
        'familyCardNumber': _familyCardController.text,
        'nik': _nikController.text,
        'fullName': _fullNameController.text,
        'birthPlace': _birthPlaceController.text,
        'birthDate': _selectedBirthDate,
        'gender': _selectedGender,
        'occupation': _occupationController.text,
        'maritalStatus': _selectedMaritalStatus,
        'province': _provinceController.text,
        'city': _cityController.text,
        'district': _districtController.text,
        'village': _villageController.text,
        'fullAddress': _addressController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneController.text,
      });
      return true;
    }
    return false;
  }
  
  bool _validateStep2() {
    if (_formKey2.currentState?.validate() ?? false) {
      if (_frontPhoto == null || _backPhoto == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please upload both front and back house photos'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return false;
      }
      
      // Save house data to request provider
      final requestProvider = Provider.of<RequestProvider>(context, listen: false);
      requestProvider.updateFormData({
        'buildingYear': _buildingYearController.text,
        'ownershipStatus': _selectedOwnershipStatus,
        'electricVoltage': _electricVoltageController.text,
        'waterStatus': _selectedWaterStatus,
        'buildingArea': double.parse(_buildingAreaController.text),
        'landArea': double.parse(_landAreaController.text),
        'buildingType': _buildingTypeController.text,
        'frontPhoto': _frontPhoto,
        'backPhoto': _backPhoto,
      });
      return true;
    }
    return false;
  }
  
  Future<void> _submitRequest() async {
    final requestProvider = Provider.of<RequestProvider>(context, listen: false);
    final success = await requestProvider.submitRequest();
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request submitted successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(requestProvider.error ?? 'Failed to submit request'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }
  
  Widget _buildStep1() {
    return Form(
      key: _formKey1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data Individu',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Family Card Number
          CustomTextField(
            controller: _familyCardController,
            label: 'Nomor Kartu Keluarga',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your family card number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // NIK
          CustomTextField(
            controller: _nikController,
            label: 'NIK',
            keyboardType: TextInputType.number,
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
          const SizedBox(height: 16),
          
          // Full Name
          CustomTextField(
            controller: _fullNameController,
            label: 'Nama Lengkap Sesuai KTP',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Birth Place
          CustomTextField(
            controller: _birthPlaceController,
            label: 'Tempat Lahir',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your birth place';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Birth Date
          CustomTextField(
            controller: _birthDateController,
            label: 'Tanggal Lahir',
            readOnly: true,
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _selectBirthDate(context),
            ),
            onTap: () => _selectBirthDate(context),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your birth date';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Gender
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
          
          // Occupation
          CustomTextField(
            controller: _occupationController,
            label: 'Pekerjaan',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your occupation';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Marital Status
          Text(
            'Status Perkawinan',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          DropdownButtonFormField<String>(
            value: _selectedMaritalStatus,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'Belum Kawin', child: Text('Belum Kawin')),
              DropdownMenuItem(value: 'Kawin', child: Text('Kawin')),
              DropdownMenuItem(value: 'Cerai Hidup', child: Text('Cerai Hidup')),
              DropdownMenuItem(value: 'Cerai Mati', child: Text('Cerai Mati')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedMaritalStatus = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          
          // Province
          CustomTextField(
            controller: _provinceController,
            label: 'Provinsi',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your province';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // City
          CustomTextField(
            controller: _cityController,
            label: 'Kabupaten/Kota',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your city';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // District
          CustomTextField(
            controller: _districtController,
            label: 'Kecamatan',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your district';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Village
          CustomTextField(
            controller: _villageController,
            label: 'Kelurahan/Desa',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your village';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Full Address
          CustomTextField(
            controller: _addressController,
            label: 'Alamat Lengkap Sesuai KTP',
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Email
          CustomTextField(
            controller: _emailController,
            label: 'Alamat Email',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Phone Number
          CustomTextField(
            controller: _phoneController,
            label: 'Nomor Telepon',
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          
          // Next Button
          CustomButton(
            text: 'Selanjutnya',
            onPressed: () {
              if (_validateStep1()) {
                final requestProvider = Provider.of<RequestProvider>(context, listen: false);
                requestProvider.nextStep();
              }
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildStep2() {
    return Form(
      key: _formKey2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data Rumah',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Building Year
          CustomTextField(
            controller: _buildingYearController,
            label: 'Tahun Bangunan',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter building year';
              }
              final year = int.tryParse(value);
              if (year == null || year < 1900 || year > DateTime.now().year) {
                return 'Please enter a valid year';
              }
              return null;
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
              border: OutlineInputBorder(),
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
          
          // Electric Voltage
          CustomTextField(
            controller: _electricVoltageController,
            label: 'Tegangan Listrik',
            hintText: 'Contoh: 900VA',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter electric voltage';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Water Status
          Text(
            'Status Perairan',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          DropdownButtonFormField<String>(
            value: _selectedWaterStatus,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
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
          
          // Building Area
          CustomTextField(
            controller: _buildingAreaController,
            label: 'Luas Bangunan',
            hintText: 'Dalam meter persegi (m²)',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter building area';
              }
              final area = double.tryParse(value);
              if (area == null || area <= 0) {
                return 'Please enter a valid area';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Land Area
          CustomTextField(
            controller: _landAreaController,
            label: 'Luas Tanah',
            hintText: 'Dalam meter persegi (m²)',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter land area';
              }
              final area = double.tryParse(value);
              if (area == null || area <= 0) {
                return 'Please enter a valid area';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Building Type
          CustomTextField(
            controller: _buildingTypeController,
            label: 'Tipe Bangunan',
            hintText: 'Contoh: Tipe 36',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter building type';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          
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
                  label: 'Tampak Depan',
                  imageData: _frontPhoto,
                  onTap: _pickFrontPhoto,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ImagePickerField(
                  label: 'Tampak Belakang',
                  imageData: _backPhoto,
                  onTap: _pickBackPhoto,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Navigation Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    final requestProvider = Provider.of<RequestProvider>(context, listen: false);
                    requestProvider.previousStep();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Kembali'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_validateStep2()) {
                      final requestProvider = Provider.of<RequestProvider>(context, listen: false);
                      requestProvider.nextStep();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Selanjutnya'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.fact_check_outlined,
          size: 80,
          color: AppTheme.primaryColor,
        ),
        const SizedBox(height: 24),
        Text(
          'Pastikan data anda terisi dengan benar!',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        const Text(
          'Periksa kembali semua data yang telah anda masukkan sebelum mengirimkan pengajuan bantuan.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        
        // Submit Button
        Consumer<RequestProvider>(
          builder: (context, provider, child) {
            return provider.isLoading
                ? const LoadingIndicator()
                : CustomButton(
                    text: 'Ajukan',
                    onPressed: _submitRequest,
                  );
          },
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            final requestProvider = Provider.of<RequestProvider>(context, listen: false);
            requestProvider.previousStep();
          },
          child: const Text('Kembali'),
        ),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final requestProvider = Provider.of<RequestProvider>(context);
    final currentStep = requestProvider.currentStep;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajukan Bantuan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (currentStep > 0) {
              requestProvider.previousStep();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step Indicator
              StepIndicator(
                currentStep: currentStep,
                totalSteps: 3,
              ),
              const SizedBox(height: 32),
              
              // Step Content
              if (currentStep == 0) _buildStep1(),
              if (currentStep == 1) _buildStep2(),
              if (currentStep == 2) _buildStep3(),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}