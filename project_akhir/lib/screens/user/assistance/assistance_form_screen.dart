import 'package:flutter/material.dart';
import 'package:project_akhir/screens/user/assistance/assistance_form_steps/personal_info_step.dart';
import 'package:project_akhir/screens/user/assistance/assistance_form_steps/house_info_step.dart';
import 'package:project_akhir/screens/user/assistance/assistance_form_steps/confirmation_step.dart';

class FormData {
  // Personal Info
  String? familyCardNumber;
  String? nik;
  String? name;
  String? birthPlace;
  DateTime? birthDate;
  String? gender;
  String? occupation;
  String? maritalStatus;
  String? province;
  String? city;
  String? district;
  String? village;
  String? fullAddress;
  String? email;
  String? phoneNumber;
  
  // House Info
  String? buildingYear;
  String? ownershipStatus;
  String? electricityCapacity;
  String? waterStatus;
  String? buildingArea;
  String? landArea;
  String? buildingType;
  List<dynamic>? photos;
}

class AssistanceFormScreen extends StatefulWidget {
  const AssistanceFormScreen({super.key});

  @override
  State<AssistanceFormScreen> createState() => _AssistanceFormScreenState();
}

class _AssistanceFormScreenState extends State<AssistanceFormScreen> {
  int _currentStep = 0;
  final FormData _formData = FormData();
  final PageController _pageController = PageController();

  final List<String> _steps = [
    'Data Individu',
    'Data Rumah',
    'Konfirmasi',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void goToNextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajukan Bantuan.'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: goToPreviousStep,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF8B0000),
      ),
      body: Column(
        children: [
          // Stepper indicator
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              children: List.generate(
                _steps.length,
                (index) => Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentStep >= index
                              ? const Color(0xFF8B0000)
                              : Colors.grey[300],
                        ),
                        child: Center(
                          child: _currentStep > index
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                )
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: _currentStep >= index
                                        ? Colors.white
                                        : Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      if (index < _steps.length - 1)
                        Expanded(
                          child: Container(
                            height: 2,
                            color: _currentStep > index
                                ? const Color(0xFF8B0000)
                                : Colors.grey[300],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Step title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                _steps.length,
                (index) => SizedBox(
                  width: 100,
                  child: Text(
                    _steps[index],
                    style: TextStyle(
                      fontSize: 12,
                      color: _currentStep >= index
                          ? const Color(0xFF8B0000)
                          : Colors.grey[700],
                      fontWeight:
                          _currentStep == index ? FontWeight.bold : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          
          // Form steps
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                PersonalInfoStep(
                  formData: _formData,
                  onContinue: goToNextStep,
                ),
                HouseInfoStep(
                  formData: _formData,
                  onContinue: goToNextStep,
                ),
                ConfirmationStep(
                  formData: _formData,
                  onSubmit: () {
                    // After successful submission
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}