import 'package:flutter/material.dart';

class ArtikelScreen extends StatefulWidget {
  const ArtikelScreen({super.key});

  @override
  State<ArtikelScreen> createState() => _ArtikelScreenState();
}

class _ArtikelScreenState extends State<ArtikelScreen> {
  final TextEditingController _artikelController = TextEditingController();

  final List<String> _artikelList = [
    "💡 *Pentingnya Akses Makanan Sehat*\nSetiap orang berhak mendapatkan makanan yang bergizi dan cukup setiap harinya. Akses terhadap pangan sehat adalah fondasi kehidupan yang layak.",
    "🍚 *Gerakan Berbagi Makanan*\nMulai dari hal kecil, seperti menyumbangkan makanan berlebih atau mendukung dapur umum. Tindakan sederhana bisa mengurangi kelaparan di sekitar kita.",
    "🌱 *Pertanian Berkelanjutan*\nDukung petani lokal dan pertanian organik. Sistem pertanian yang adil dan ramah lingkungan bisa menjadi kunci untuk mengakhiri kelaparan di masa depan.",
  ];

  void _postArtikel() {
    if (_artikelController.text.trim().isEmpty) return;

    setState(() {
      _artikelList.add(_artikelController.text.trim());
      _artikelController.clear();
    });
  }

  void _openDetail(String artikel) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailArtikelScreen(artikel: artikel)),
    );
  }

  Widget _buildArtikelBox(String artikel) {
    return InkWell(
      onTap: () => _openDetail(artikel),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.orange[50],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(artikel, style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel Terkini'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Artikel Tentang Zero Hunger',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ..._artikelList.take(3).map(_buildArtikelBox).toList(),
            const SizedBox(height: 24),
            const Text(
              'Tulis Artikel Kamu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange),
              ),
              child: TextField(
                controller: _artikelController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Tambahkan Artikel Anda ..',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.orange,
              ),
              child: TextButton(
                onPressed: _postArtikel,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  child: Text(
                    'Kirimkan Artikel',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Artikel Baru',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ..._artikelList.skip(3).map(_buildArtikelBox).toList(),
          ],
        ),
      ),
    );
  }
}

// ✅ Class DetailArtikelScreen DILUAR class ArtikelScreen
class DetailArtikelScreen extends StatelessWidget {
  final String artikel;

  const DetailArtikelScreen({super.key, required this.artikel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Artikel'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(artikel, style: const TextStyle(fontSize: 16, height: 1.5)),
      ),
    );
  }
}
