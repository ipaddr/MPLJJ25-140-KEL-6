import 'package:flutter/material.dart';

class AjukanBantuanScreen2 extends StatefulWidget {
  const AjukanBantuanScreen2({Key? key}) : super(key: key);

  @override
  _AjukanBantuanScreen2State createState() => _AjukanBantuanScreen2State();
}

class _AjukanBantuanScreen2State extends State<AjukanBantuanScreen2> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajukan Bantuan (Data Individu)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nomor Kartu Keluarga'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'NIK'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Tempat Lahir'),
              ),
              ListTile(
                title: const Text('Tanggal Lahir'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () {
                  // Placeholder for DatePicker
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                },
              ),
              const Text('Jenis Kelamin'),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Perempuan'),
                      value: 'Perempuan',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Laki-laki'),
                      value: 'Laki-laki',
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Pekerjaan'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Status Perkawinan'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Provinsi'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Kabupaten/Kota'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Kecamatan'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Kelurahan/Desa'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Alamat Lengkap Sesuai KTP'),
                maxLines: 3,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Alamat Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Placeholder for navigation to AjukanBantuanScreen3
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => AjukanBantuanScreen3()),
                    // );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Navigasi ke Ajukan Bantuan 3 (placeholder)')),
                    );
                  },
                  child: const Text('Selanjutnya'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}