import 'package:flutter/material.dart';
import 'riwayat_screen.dart';

class ButuhBantuanScreen extends StatefulWidget {
  const ButuhBantuanScreen({Key? key}) : super(key: key);

  @override
  _ButuhBantuanScreenState createState() => _ButuhBantuanScreenState();
}

class _ButuhBantuanScreenState extends State<ButuhBantuanScreen> {
  String? selectedKategoriMakanan;
  String? selectedKategoriKebutuhan;

  final TextEditingController alamatController = TextEditingController();
  final TextEditingController kontakController = TextEditingController();
  final TextEditingController pesanController = TextEditingController();
  final TextEditingController minJumlahController = TextEditingController();

  final List<Map<String, String>> riwayatList = [];

  final List<String> kategoriMakananList = [
    'Makanan Siap Saji',
    'Sembako',
    'Buah',
    'Sayur',
  ];

  final List<String> kategoriKebutuhanList = [
    'Bantuan untuk Pribadi',
    'Bantuan untuk Tempat Khusus',
  ];

  void _kirimPermintaan() {
    final newRiwayat = {
      'title': selectedKategoriMakanan ?? 'Bantuan',
      'date': DateTime.now().toString().split(' ')[0],
      'status': 'Diproses',
    };

    setState(() {
      riwayatList.add(newRiwayat);
      selectedKategoriMakanan = null;
      selectedKategoriKebutuhan = null;
      alamatController.clear();
      kontakController.clear();
      pesanController.clear();
      minJumlahController.clear();
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => RiwayatScreen(
              judulHalaman: 'Riwayat Permintaan Bantuan',
              riwayatList: riwayatList,
            ),
      ),
    );
  }

  void _lihatRiwayat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => RiwayatScreen(
              judulHalaman: 'Riwayat Permintaan Bantuan',
              riwayatList: riwayatList,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        title: Text('Butuh Bantuan Makanan'),
        backgroundColor: Colors.orange,
        elevation: 4,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Isi Formulir Ini Untuk Menerima Bantuan',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade800,
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildDropdownField(
                        label: 'Kategori Makanan',
                        value: selectedKategoriMakanan,
                        icon: Icons.fastfood,
                        items: kategoriMakananList,
                        onChanged: (value) {
                          setState(() {
                            selectedKategoriMakanan = value;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      _buildDropdownField(
                        label: 'Kategori Kebutuhan',
                        value: selectedKategoriKebutuhan,
                        icon: Icons.category,
                        items: kategoriKebutuhanList,
                        onChanged: (value) {
                          setState(() {
                            selectedKategoriKebutuhan = value;
                          });
                        },
                      ),

                      if (selectedKategoriKebutuhan ==
                          'Bantuan untuk Tempat Khusus')
                        _buildTextField(
                          controller: minJumlahController,
                          label: 'Jumlah Kebutuhan',
                          icon: Icons.format_list_numbered,
                          keyboardType: TextInputType.number,
                        ),

                      _buildTextField(
                        controller: alamatController,
                        label: 'Alamat Lengkap',
                        icon: Icons.location_on,
                      ),
                      _buildTextField(
                        controller: kontakController,
                        label: 'Nomor Kontak',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      _buildTextField(
                        controller: pesanController,
                        label: 'Pesan atau Kebutuhan Lain',
                        icon: Icons.message,
                        maxLines: 3,
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _kirimPermintaan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Kirim Permintaan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Center(
                        child: TextButton(
                          onPressed: _lihatRiwayat,
                          child: Text(
                            'Lihat Riwayat Proses Bantuan',
                            style: TextStyle(
                              color: Colors.orange.shade200,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.orange),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        items:
            items
                .map(
                  (item) =>
                      DropdownMenuItem<String>(value: item, child: Text(item)),
                )
                .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.orange),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
