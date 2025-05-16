import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_akhir/screens/user/assistance/assistance_form_screen.dart';

class PersonalInfoStep extends StatefulWidget {
  final FormData formData;
  final VoidCallback onContinue;

  const PersonalInfoStep({
    super.key,
    required this.formData,
    required this.onContinue,
  });

  @override
  State<PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends State<PersonalInfoStep> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _birthDateController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    if (widget.formData.birthDate != null) {
      _birthDateController.text = DateFormat('dd/MM/yyyy').format(widget.formData.birthDate!);
    }
  }

  @override
  void dispose() {
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.formData.birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != widget.formData.birthDate) {
      setState(() {
        widget.formData.birthDate = picked;
        _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _validateAndContinue() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onContinue();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: widget.formData.familyCardNumber,
              decoration: const InputDecoration(
                labelText: 'Nomor Kartu Keluarga',
                hintText: 'Masukkan nomor kartu keluarga',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nomor kartu keluarga wajib diisi';
                }
                return null;
              },
              onSaved: (value) {
                widget.formData.familyCardNumber = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.formData.nik,
              decoration: const InputDecoration(
                labelText: 'NIK',
                hintText: 'Masukkan NIK',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'NIK wajib diisi';
                }
                if (value.length != 16) {
                  return 'NIK harus 16 digit';
                }
                return null;
              },
              onSaved: (value) {
                widget.formData.nik = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.formData.name,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap Sesuai KTP',
                hintText: 'Masukkan nama lengkap',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama lengkap wajib diisi';
                }
                return null;
              },
              onSaved: (value) {
                widget.formData.name = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.formData.birthPlace,
              decoration: const InputDecoration(
                labelText: 'Tempat Lahir',
                hintText: 'Masukkan tempat lahir',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tempat lahir wajib diisi';
                }
                return null;
              },
              onSaved: (value) {
                widget.formData.birthPlace = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _birthDateController,
              decoration: const InputDecoration(
                labelText: 'Tanggal Lahir',
                hintText: 'dd/mm/yyyy',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tanggal lahir wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Jenis Kelamin',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Laki-laki'),
                    value: 'Laki-laki',
                    groupValue: widget.formData.gender,
                    onChanged: (value) {
                      setState(() {
                        widget.formData.gender = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Perempuan'),
                    value: 'Perempuan',
                    groupValue: widget.formData.gender,
                    onChanged: (value) {
                      setState(() {
                        widget.formData.gender = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.formData.occupation,
              decoration: const InputDecoration(
                labelText: 'Pekerjaan',
                hintText: 'Masukkan pekerjaan',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pekerjaan wajib diisi';
                }
                return null;
              },
              onSaved: (value) {
                widget.formData.occupation = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.formData.maritalStatus,
              decoration: const InputDecoration(
                labelText: 'Status Perkawinan',
                hintText: 'Masukkan status perkawinan',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Status perkawinan wajib diisi';
                }
                return null;
              },
              onSaved: (value) {
                widget.formData.maritalStatus = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.formData.province,
              decoration: const InputDecoration(
                labelText: 'Provinsi',
                hintText: 'Masukkan provinsi',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Provinsi wajib diisi';
                }
                return null;
              },
              onSaved: (value) {
                widget.formData.province = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.formData.city,
              decoration: const InputDecoration(
                labelText: 'Kabupaten/Kota',
                hintText: 'Masukkan kabupaten/kota',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kabupaten/kota wajib diisi';
                }
                return null;
              },
              onSaved: (value) {
                widget.formData.city = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.formData.district,
              decoration: const InputDecoration(
                labelText: 'Kecamatan',
                hintText: 'Masukkan kecamatan',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kecamatan wajib diisi';
                }
                return null;
              },
              onSaved: (value) {
                widget.formData.district = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.formData.village,
              decoration: const InputDecoration(
                labelText: 'Kelurahan/Desa',
                hintText: 'Masukkan kelurahan/desa',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kelurahan/desa wajib diisi';
                }
                return null;
              },
              onSaved: (value) {
                widget.formData.village = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.formData.fullAddress,
              decoration: const InputDecoration(
                labelText: 'Alamat Lengkap Sesuai KTP',
                hintText: 'Masukkan alamat lengkap',
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Alamat lengkap wajib diisi';
                }
                return null;
              },
              onSaved: (value) {
                widget.formData.fullAddress = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.formData.email,
              decoration: const InputDecoration(
                labelText: 'Alamat Email',
                hintText: 'Masukkan alamat email',
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Alamat email wajib diisi';
                }
                if (!value.contains('@') || !value.contains('.')) {
                  return 'Alamat email tidak valid';
                }
                return null;
              },
              onSaved: (value) {
                widget.formData.email = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.formData.phoneNumber,
              decoration: const InputDecoration(
                labelText: 'Nomor Telepon',
                hintText: 'Masukkan nomor telepon',
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nomor telepon wajib diisi';
                }
                return null;
              },
              onSaved: (value) {
                widget.formData.phoneNumber = value;
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _validateAndContinue,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Selanjutnya'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}