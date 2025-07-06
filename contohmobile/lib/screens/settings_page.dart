import 'package:flutter/material.dart';
import './theme_notifier.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeNotifier.isDarkMode,
      builder: (context, isDarkMode, _) {
        return Scaffold(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          appBar: AppBar(
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Pengaturan',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              _buildListTile(Icons.person_outline, 'Edit Profil', () {
                _navigateTo(context, const EditProfilePage());
              }, isDarkMode),
              _buildListTile(Icons.logout, 'Keluar', () => _showLogoutDialog(context), isDarkMode),
              const Divider(height: 30),
              SwitchListTile(
                value: isDarkMode,
                onChanged: (value) {
                  ThemeNotifier.isDarkMode.value = value;
                },
                secondary: Icon(
                  Icons.dark_mode,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                title: Text(
                  'Mode Gelap',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                ),
                activeColor: Colors.white,
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.black26,
              ),
              _buildListTile(Icons.info_outline, 'Tentang Aplikasi', () {
                _navigateTo(context, const AboutPage());
              }, isDarkMode),
              _buildListTile(Icons.privacy_tip_outlined, 'Kebijakan Privasi', () {
                _navigateTo(context, const PrivacyPolicyPage());
              }, isDarkMode),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap, bool isDarkMode) {
    return ListTile(
      leading: Icon(icon, color: isDarkMode ? Colors.white : Colors.black),
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontSize: 16,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: isDarkMode ? Colors.white : Colors.black, size: 16),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Keluar'),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Selamat! Anda telah berhasil keluar.')),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ===================== EDIT PROFILE PAGE =====================
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ThemeNotifier.isDarkMode.value;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: const AssetImage('assets/placeholder.png'),
                backgroundColor: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nama',
                hintText: 'Masukkan nama Anda',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                contentPadding: const EdgeInsets.all(12),
              ),
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Profil berhasil diperbarui: $name')),
                );
              },
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================== ABOUT PAGE =====================
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ThemeNotifier.isDarkMode.value;

    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tentang Aplikasi Ini', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
              'Aplikasi ini dirancang untuk membantu pengguna mengelola profil, pengaturan, dan preferensi mereka dengan mudah.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text('Versi: 1.0.0', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Dikembangkan oleh: Nama Tim Anda', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

// ===================== PRIVACY POLICY PAGE =====================
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ThemeNotifier.isDarkMode.value;

    return Scaffold(
      appBar: AppBar(title: const Text('Kebijakan Privasi')),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kebijakan Privasi', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
              'Privasi Anda penting bagi kami. Kebijakan ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan melindungi informasi Anda.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Kami mengumpulkan informasi pribadi seperti nama dan alamat email untuk penggunaan aplikasi yang lebih baik.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}