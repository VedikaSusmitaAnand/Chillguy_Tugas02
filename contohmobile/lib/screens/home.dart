import 'package:flutter/material.dart';
import 'butuhbantuan_screen.dart';
import 'donasimakanan_screen.dart';
import 'donasidana_screen.dart';
import 'artikel_screen.dart';

class HomePage extends StatefulWidget {
  final String userName;
  const HomePage({super.key, required this.userName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> bannerImages = [
    'https://images.unsplash.com/photo-1509099836639-18ba1795216d',
    'https://images.pexels.com/photos/6646914/pexels-photo-6646914.jpeg',
    'https://images.unsplash.com/photo-1490645935967-10de6ba17061',
  ];

  final List<Map<String, String>> artikelList = [
    {
      'image':
          'https://images.unsplash.com/photo-1509099836639-18ba1795216d?w=600',
      'title': 'Pentingnya Gizi Seimbang',
      'desc': 'Pentingnya konsumsi makanan bergizi.',
      'content': '''
Gizi yang seimbang sangat penting bagi kesehatan tubuh manusia, karena gizi adalah bahan bakar utama yang dibutuhkan tubuh untuk berfungsi secara optimal.

1. Apa Itu Gizi Seimbang?
Gizi seimbang adalah susunan makanan sehari-hari yang mengandung semua zat gizi yang dibutuhkan tubuh dalam jumlah yang cukup dan seimbang, seperti karbohidrat, protein, lemak, vitamin, mineral, air, dan serat.

2. Mengapa Gizi Seimbang Penting?
- Pertumbuhan dan Perkembangan: Mendukung pertumbuhan fisik dan otak, terutama pada anak-anak dan remaja.
- Daya Tahan Tubuh: Membantu tubuh melawan infeksi dan penyakit.
- Energi dan Konsentrasi: Menjaga fokus saat belajar dan bekerja.
- Mencegah Penyakit: Mengurangi risiko obesitas, diabetes, tekanan darah tinggi, dan jantung.
- Kesehatan Mental: Gizi baik menjaga suasana hati dan fungsi otak.
- Penyembuhan: Nutrisi mempercepat pemulihan setelah sakit.

3. Contoh Pola Makan Seimbang:
- Makan 3 kali sehari dengan porsi cukup.
- Setengah piring sayur dan buah, 1/4 protein, 1/4 karbohidrat.
- Minum air 6–8 gelas sehari.
- Kurangi makanan olahan dan manis.

Kesimpulan:
Gizi seimbang adalah fondasi utama untuk hidup sehat, aktif, dan produktif. Mari biasakan pola makan yang sehat mulai dari sekarang!
''',
    },
    {
      'image':
          'https://images.pexels.com/photos/6646915/pexels-photo-6646915.jpeg?w=600',
      'title': 'Program Donasi Makanan',
      'desc': 'Komunitas membagikan makanan.',
      'content': '''
Program Donasi Makanan adalah inisiatif sosial yang bertujuan untuk mengumpulkan, mendistribusikan, dan memberikan makanan kepada individu atau komunitas yang membutuhkan.

Tujuan:
- Mengurangi kelaparan.
- Mengurangi pemborosan makanan.
- Menumbuhkan solidaritas sosial.

Pelaksanaan:
1. Pengumpulan dari individu/lembaga.
2. Pemeriksaan kelayakan makanan.
3. Pengemasan.
4. Distribusi.
5. Edukasi gizi.

Manfaat:
- Meringankan beban masyarakat.
- Mengurangi sampah makanan.
- Membentuk masyarakat peduli.
''',
    },
    {
      'image':
          'https://images.pexels.com/photos/6646914/pexels-photo-6646914.jpeg?w=600',
      'title': 'Edukasi Zero Hunger',
      'desc': 'Kesadaran tentang kelaparan global.',
      'content': '''
Zero Hunger adalah tujuan global untuk menghapus kelaparan dan kekurangan gizi.

Strategi:
1. Produksi Pangan Berkelanjutan.
2. Pendidikan Gizi.
3. Pengurangan Limbah.
4. Kemitraan Multisektor.

Kontribusi Kita:
- Tidak membuang makanan.
- Donasi makanan berlebih.
- Edukasi masyarakat.

Dampak:
- Anak sehat dan pintar.
- Ekonomi lokal tumbuh.
- Lingkungan lestari.
''',
    },
  ];

  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    Future.delayed(const Duration(seconds: 3), _autoScroll);
  }

  void _autoScroll() {
    if (!mounted) return;
    _currentPage = (_currentPage + 1) % bannerImages.length;
    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    Future.delayed(const Duration(seconds: 3), _autoScroll);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Halo, ${widget.userName} 👋'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.article_outlined),
            tooltip: "Artikel",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ArtikelScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Tentang') {
                showDialog(
                  context: context,
                  builder:
                      (ctx) => AlertDialog(
                        title: const Text('Tentang Aplikasi'),
                        content: const Text(
                          'Aplikasi ini dibuat untuk mendukung gerakan Zero Hunger melalui donasi makanan, bantuan, dan dana.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Tutup'),
                          ),
                        ],
                      ),
                );
              } else if (value == 'Bantuan') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ButuhBantuanScreen()),
                );
              }
            },
            itemBuilder:
                (context) => const [
                  PopupMenuItem(
                    value: 'Tentang',
                    child: Text('Tentang Aplikasi'),
                  ),
                  PopupMenuItem(value: 'Bantuan', child: Text('Bantuan')),
                ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildBanner(),
          const SizedBox(height: 20),
          _buildMenuRow(),
          const SizedBox(height: 24),
          _buildArtikelSection(),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ArtikelScreen()),
              );
            },
            icon: const Icon(Icons.article, color: Colors.white),
            label: const Text(
              "Baca Artikel Selengkapnya",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _pageController,
        itemCount: bannerImages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(bannerImages[index], fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMenuCard(
            Icons.fastfood,
            "Donasi\nMakanan",
            Colors.green,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DonasiMakananScreen()),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMenuCard(
            Icons.help,
            "Butuh\nBantuan",
            Colors.orange,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ButuhBantuanScreen()),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMenuCard(
            Icons.monetization_on,
            "Donasi\nDana",
            Colors.teal,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DonasiDanaScreen()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArtikelSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Artikel Zero Hunger",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...artikelList.map(
              (artikel) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        artikel['image']!,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            artikel['title']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            artikel['desc']!,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
