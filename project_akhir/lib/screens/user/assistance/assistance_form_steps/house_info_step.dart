import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_akhir/screens/user/assistance/assistance_form_screen.dart';

class HouseInfoStep extends StatefulWidget {
  final FormData formData;
  final VoidCallback onContinue;

  const HouseInfoStep({
    super.key,
    required this.formData,
    required this.onContinue,
  });

  @override
  State<HouseInfoStep> createState() => _HouseInfoStepState();
}

class _HouseInfoStepState extends State<HouseInfoStep> {
  final _formKey = GlobalKey<FormState>();
  final List<File> _photos = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize the photos list if it exists in formData
    if (widget.formData.photos != null) {
      for (var photo in widget.formData.photos!) {
        if (photo is File) {
          _photos.add(photo);
        }
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _photos.add(File(pickedFile.path));
      });
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _photos.removeAt(index);
    });
  }

  void _validateAndContinue() {
    if (_formKey.currentState!.validate()) {
      if (_photos.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap unggah setidaknya satu foto rumah'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      _formKey.currentState!.save();
      widget.formData.photos = _photos;
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
              initialValue: widget.formData.buildingYear,
              decoration: const InputDecoration(
                labelText: 'Tahun Bangunan',
                hintText: 'Masukkan tahun bangunan',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tahun bangunan wajib diisi';
                }
                return null;
              },
              onSaved: (value) {
                widget.formData.buildingYear = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.formData.ownershipStatus,
              decoration: const InputDecoration(
                labelText: 'Status Kepemilikan',
                hintText: 'Masukkan status kepemilikan',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Status kepemilikan wajib diisi';
                }
                return null;
              },
              onSaved: (value) {
                widget.formData.ownershipStatus = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.formData.electricityCapacity,
              decoration: const InputDecoration(
                labelText: 'Tegangan Listrik',
                hintText: 'Masukkan tegangan listrik',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tegangan listrik wajib diisi';
                }
                return null;
              },
              onSaved: (value) {
                widget.formData.electricityCapacity = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.formData.waterStatus,
              decoration: const InputDecoration(
                labelText: 'Status Perairan',
                hintText: 'Masukkan status perairan',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Status perairan wajib diisi';
                }
                return null;
              },
              onSaved: (value) {
                widget.formData.waterStatus = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.formData.buildingArea,
              decoration: const InputDecoration(
                labelText: 'Luas Bangunan',
                hintText: 'Masukkan luas bangunan',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Luas bangunan wajib diisi';
                }
                return null;
              },
              onSaved: (value) {
                widget.formData.buildingArea = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.formData.landArea,
              decoration: const InputDecoration(
                labelText: 'Luas Tanah',
                hintText: 'Masukkan luas tanah',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Luas tanah wajib diisi';
                }
                return null;
              },
              onSaved: (value) {
                widget.formData.landArea = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.formData.buildingType,
              decoration: const InputDecoration(
                labelText: 'Tipe Bangunan',
                hintText: 'Masukkan tipe bangunan',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tipe bangunan wajib diisi';
                }
                return null;
              },
              onSaved: (value) {
                widget.formData.buildingType = value;
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Lampiran Foto',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Tampak Depan',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Tampak Belakang',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Pilih Foto'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.photo_camera),
                              title: const Text('Ambil Foto'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('Pilih dari Galeri'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.gallery);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    child: Container(
                      height: 100,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _photos.isNotEmpty
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _photos[0],
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: GestureDetector(
                                    onTap: () => _removePhoto(0),
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const Icon(Icons.add_a_photo),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Pilih Foto'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.photo_camera),
                              title: const Text('Ambil Foto'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('Pilih dari Galeri'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.gallery);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    child: Container(
                      height: 100,
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _photos.length > 1
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _photos[1],
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: GestureDetector(
                                    onTap: () => _removePhoto(1),
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const Icon(Icons.add_a_photo),
                    ),
                  ),
                ),
              ],
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