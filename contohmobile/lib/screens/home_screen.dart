// Tambahkan import
import 'package:flutter/material.dart';
import 'butuhbantuan_screen.dart';
import 'donasimakanan_screen.dart';
import 'donasidana_screen.dart';
import 'login_screen.dart';

class HomePage extends StatefulWidget {
  final String userName;
  const HomePage({super.key, required this.userName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> bannerImages = [
    'https://images.unsplash.com/photo-1509099836639-18ba1795216d',
    'https://images.pexels.com/photos/6646914/pexels-photo-6646914.jpeg',
    'https://images.unsplash.com/photo-1490645935967-10de6ba17061',
  ];

  final List<Map<String, String>> artikelList = [
    {
      'image': 'https://images.unsplash.com/photo-1509099836639-18ba1795216d',
      'title': 'Pentingnya Gizi Seimbang',
      'desc': 'Pentingnya konsumsi makanan bergizi.',
      'content': 'Gizi seimbang penting untuk menjaga daya tahan tubuh, perkembangan otak, dan pertumbuhan. Makanan bergizi meliputi sayuran, buah, protein, dan karbohidrat kompleks. Masyarakat perlu menyadari pentingnya pola makan sehat sejak dini.'
    },
    {
      'image': 'https://images.pexels.com/photos/6646915/pexels-photo-6646915.jpeg',
      'title': 'Program Donasi Makanan',
      'desc': 'Komunitas membagikan makanan.',
      'content': 'Program donasi makanan adalah bentuk solidaritas untuk membantu mereka yang membutuhkan. Komunitas bisa menyumbangkan makanan berlebih, membuat dapur umum, atau mengedukasi pentingnya berbagi.'
    },
    {
      'image': 'https://images.pexels.com/photos/6646914/pexels-photo-6646914.jpeg',
      'title': 'Edukasi Zero Hunger',
      'desc': 'Kesadaran tentang kelaparan global.',
      'content': 'Zero Hunger adalah tujuan global untuk menghapus kelaparan. Edukasi kepada masyarakat sangat penting agar semua pihak berperan aktif dalam distribusi pangan yang adil dan tidak membuang makanan secara sembarangan.'
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

  void _openArtikelDetail(Map<String, String> artikel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailArtikelScreen(artikel: artikel),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[50],
      drawer: _buildDrawer(),
      appBar: AppBar(
        title: Text('Halo, ${widget.userName} 👋'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'drawer') _scaffoldKey.currentState?.openDrawer();
              if (value == 'bottom') _showBottomNavModal();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'drawer', child: Text("Open Drawer")),
              PopupMenuItem(value: 'bottom', child: Text("Bottom Sheet")),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanner(),
            const SizedBox(height: 20),
            _buildMenuRow(context),
            const SizedBox(height: 20),
            const Text("Artikel Zero Hunger", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...artikelList.map((artikel) => _buildArtikelCard(artikel)).toList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.push(context, MaterialPageRoute(builder: (_) => const DonasiMakananScreen()));
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ButuhBantuanScreen()));
              break;
            case 3:
              break;
            case 4:
              _showBottomNavModal();
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Donasi'),
          BottomNavigationBarItem(icon: Icon(Icons.inbox), label: 'Bantuan'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifikasi'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Akun'),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2022/09/19/18/40/woman-7465803_1280.jpg'),
          ),
          const SizedBox(height: 12),
          Text(widget.userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text('user@email.com', style: TextStyle(color: Colors.grey)),
          const Divider(height: 30),
          const ListTile(leading: Icon(Icons.favorite), title: Text('My Donation')),
          const ListTile(leading: Icon(Icons.help), title: Text('Help I Received')),
        ],
      ),
    );
  }

  void _showBottomNavModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(leading: Icon(Icons.info), title: Text("App Info")),
            const ListTile(leading: Icon(Icons.help), title: Text("Help")),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
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

  Widget _buildMenuRow(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildMenuCard(Icons.fastfood, "Donasi\nMakanan", Colors.green, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const DonasiMakananScreen()));
        })),
        const SizedBox(width: 12),
        Expanded(child: _buildMenuCard(Icons.help, "Butuh\nBantuan", Colors.orange, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ButuhBantuanScreen()));
        })),
        const SizedBox(width: 12),
        Expanded(child: _buildMenuCard(Icons.monetization_on, "Donasi\nDana", Colors.teal, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const DonasiDanaScreen()));
        })),
      ],
    );
  }

  Widget _buildMenuCard(IconData icon, String label, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 110,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Colors.white),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArtikelCard(Map<String, String> artikel) {
    return GestureDetector(
      onTap: () => _openArtikelDetail(artikel),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  artikel['image']!,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(artikel['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(artikel['desc']!, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================
// Halaman Detail Artikel
// ============================
class DetailArtikelScreen extends StatelessWidget {
  final Map<String, String> artikel;
  const DetailArtikelScreen({super.key, required this.artikel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(artikel['title'] ?? 'Detail Artikel'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              artikel['image']!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              artikel['title']!,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              artikel['content'] ?? '',
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
