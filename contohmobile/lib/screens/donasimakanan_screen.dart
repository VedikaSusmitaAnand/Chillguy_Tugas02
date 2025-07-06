import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DonasiMakananScreen extends StatefulWidget {
  const DonasiMakananScreen({Key? key}) : super(key: key);

  @override
  _DonasiMakananScreenState createState() => _DonasiMakananScreenState();
}

class _DonasiMakananScreenState extends State<DonasiMakananScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaMakananController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _jumlahPorsiController = TextEditingController();
  final TextEditingController _nomorKontakController = TextEditingController();
  String? _kategoriMakanan;
  String? _lokasiTerpilih;

  final List<String> _kategoriMakananList = [
    'Makanan Siap Saji',
    'Sembako',
    'Buah',
    'Sayur',
  ];

  final List<String> _lokasiList = [
    'Medan',
    'Aceh',
    'Jakarta',
    'Surabaya',
    'Bali',
  ];

  Future<void> _DonasiKeRiwayat() async {
    final prefs = await SharedPreferences.getInstance();
    final donasiBaru = {
      'kategori': _kategoriMakanan,
      'nama': _namaMakananController.text,
      'deskripsi': _deskripsiController.text,
      'porsi': _jumlahPorsiController.text,
      'lokasi': _lokasiTerpilih,
      'kontak': _nomorKontakController.text,
    };

    List<String> riwayat = prefs.getStringList('riwayatDonasi') ?? [];
    riwayat.add(jsonEncode(donasiBaru));
    await prefs.setStringList('riwayatDonasi', riwayat);
  }

  void _resetForm() {
    _kategoriMakanan = null;
    _lokasiTerpilih = null;
    _namaMakananController.clear();
    _deskripsiController.clear();
    _jumlahPorsiController.clear();
    _nomorKontakController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8F0),
      appBar: AppBar(
        title: Text('Donasi Makanan'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Card(
            elevation: 4,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDropdownField(),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            controller: _namaMakananController,
                            label: 'Nama Makanan',
                            icon: Icons.fastfood,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildTextFormField(
                            controller: _jumlahPorsiController,
                            label: 'Jumlah Porsi',
                            icon: Icons.format_list_numbered,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    _buildLokasiDropdownFake(),
                    _buildTextFormField(
                      controller: _nomorKontakController,
                      label: 'Nomor Kontak',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    _buildTextFormField(
                      controller: _deskripsiController,
                      label: 'Deskripsi Makanan',
                      icon: Icons.description,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
                        if (_kategoriMakanan == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Silakan pilih kategori makanan'),
                            ),
                          );
                          return;
                        }
                        if (_lokasiTerpilih == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Silakan pilih lokasi donasi'),
                            ),
                          );
                          return;
                        }
                        if (_formKey.currentState!.validate()) {
                          await _DonasiKeRiwayat();
                          _resetForm();
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: Text('Donasi Berhasil 🎉'),
                                  content: Text(
                                    'Terima kasih atas kebaikan Anda!',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                          );
                        }
                      },
                      child: Text(
                        'Konfirmasi Donasi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RiwayatDonasiScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Lihat Riwayat Donasi',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Kategori Makanan',
        prefixIcon: Icon(Icons.category, color: Colors.orange),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      value: _kategoriMakanan,
      items:
          _kategoriMakananList
              .map(
                (kategori) => DropdownMenuItem<String>(
                  value: kategori,
                  child: Text(kategori),
                ),
              )
              .toList(),
      onChanged: (value) {
        setState(() {
          _kategoriMakanan = value;
        });
      },
      validator: (value) => value == null ? 'Kategori harus dipilih' : null,
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.orange),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        validator:
            (value) =>
                value == null || value.isEmpty
                    ? '$label tidak boleh kosong'
                    : null,
      ),
    );
  }

  Widget _buildLokasiDropdownFake() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () => _showLokasiModal(),
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Lokasi Donasi',
              prefixIcon: Icon(Icons.location_on, color: Colors.orange),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            controller: TextEditingController(text: _lokasiTerpilih ?? ''),
            validator:
                (value) =>
                    (value == null || value.isEmpty)
                        ? 'Lokasi harus dipilih'
                        : null,
          ),
        ),
      ),
    );
  }

  void _showLokasiModal() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pilih Lokasi Donasi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ..._lokasiList.map(
                (lokasi) => RadioListTile<String>(
                  title: Text(lokasi),
                  value: lokasi,
                  groupValue: _lokasiTerpilih,
                  activeColor: Colors.orange,
                  onChanged: (val) {
                    setState(() {
                      _lokasiTerpilih = val;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class RiwayatDonasiScreen extends StatefulWidget {
  @override
  _RiwayatDonasiScreenState createState() => _RiwayatDonasiScreenState();
}

class _RiwayatDonasiScreenState extends State<RiwayatDonasiScreen> {
  List<Map<String, dynamic>> _riwayat = [];
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadRiwayat();
  }

  Future<void> _loadRiwayat() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('riwayatDonasi') ?? [];
    setState(() {
      _riwayat =
          data.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered =
        _riwayat.where((item) {
          final nama = (item['nama'] ?? '').toString().toLowerCase();
          return nama.contains(_query.toLowerCase());
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Donasi'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari Nama Makanan...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (val) {
                setState(() {
                  _query = val;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final item = filtered[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(item['nama'] ?? 'Donasi'),
                    subtitle: Text(
                      'Kategori: ${item['kategori']}\n'
                      'Porsi: ${item['porsi']} - Lokasi: ${item['lokasi']}\n'
                      'Kontak: ${item['kontak']}',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
