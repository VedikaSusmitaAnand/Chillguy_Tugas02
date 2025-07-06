import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DonasiDanaScreen extends StatefulWidget {
  const DonasiDanaScreen({Key? key}) : super(key: key);

  @override
  _DonasiDanaScreenState createState() => _DonasiDanaScreenState();
}

class _DonasiDanaScreenState extends State<DonasiDanaScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _customAmountController = TextEditingController();

  int? _selectedAmount;
  bool _donationComplete = false;
  bool _showHistory = false;

  final List<int> presetAmounts = [50000, 100000, 250000, 500000];
  final List<String> _lokasiList = [
    'Medan',
    'Aceh',
    'Jakarta',
    'Surabaya',
    'Bali',
  ];
  String? _lokasiTerpilih;
  bool _tampilOpsiLokasi = false;

  List<int> _donationHistory = [];

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _loadDonationHistory();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _donationComplete = false;
              _selectedAmount = null;
              _customAmountController.clear();
              _lokasiTerpilih = null;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _customAmountController.dispose();
    super.dispose();
  }

  Future<void> _loadDonationHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? history = prefs.getStringList('donation_history');
    if (history != null) {
      setState(() {
        _donationHistory = history.map(int.parse).toList();
      });
    }
  }

  Future<void> _saveDonationHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> historyStrings =
        _donationHistory.map((e) => e.toString()).toList();
    await prefs.setStringList('donation_history', historyStrings);
  }

  void _submitDonation() {
    if ((_selectedAmount == null || _selectedAmount == 0) &&
        (_customAmountController.text.isEmpty ||
            int.tryParse(_customAmountController.text) == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon pilih atau masukkan jumlah donasi yang valid.'),
        ),
      );
      return;
    }

    if (_lokasiTerpilih == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih lokasi donasi.')),
      );
      return;
    }

    int donationAmount = _selectedAmount ?? 0;
    if (_customAmountController.text.isNotEmpty) {
      final custom = int.tryParse(_customAmountController.text);
      if (custom != null && custom > 0) {
        donationAmount = custom;
      }
    }

    if (donationAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jumlah donasi harus lebih besar dari 0.'),
        ),
      );
      return;
    }

    setState(() {
      _donationComplete = true;
      _donationHistory.add(donationAmount);
    });

    _saveDonationHistory();
    _animationController.forward(from: 0);
  }

  Widget _buildPresetAmountButton(int amount) {
    final isSelected = _selectedAmount == amount;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedAmount = amount;
            _customAmountController.clear();
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.orange : Colors.orange.shade100,
            borderRadius: BorderRadius.circular(16),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.6),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                    : [],
          ),
          child: Center(
            child: Text(
              'Rp ${_formatCurrency(amount)}',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.orange.shade800,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatCurrency(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        title: const Text(
          'Donasi Dana Bantuan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          _donationComplete
              ? Center(
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Card(
                    color: Colors.white,
                    margin: const EdgeInsets.all(30),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Colors.orange,
                            size: 80,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Terima kasih atas donasimu!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Donasimu sangat berarti bagi mereka yang membutuhkan.\nKamu membuat dunia menjadi tempat yang lebih baik.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    color: Colors.white,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pilih jumlah donasi',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children:
                                  presetAmounts
                                      .map(_buildPresetAmountButton)
                                      .toList(),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Atau masukkan jumlah lain',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _customAmountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Masukkan jumlah (Rp)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixText: 'Rp ',
                                filled: true,
                                fillColor: Colors.orange.shade50,
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _selectedAmount = null;
                                });
                              },
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  final valInt = int.tryParse(value);
                                  if (valInt == null || valInt <= 0) {
                                    return 'Masukkan angka yang valid lebih dari 0';
                                  }
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Pilih Lokasi Donasi',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _tampilOpsiLokasi = !_tampilOpsiLokasi;
                                });
                              },
                              icon: const Icon(
                                Icons.place,
                                color: Colors.orange,
                              ),
                              label: Text(
                                _tampilOpsiLokasi
                                    ? 'Tutup Lokasi'
                                    : 'Pilih Lokasi',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (_tampilOpsiLokasi)
                              Column(
                                children: [
                                  ..._lokasiList.map((lokasi) {
                                    return RadioListTile<String>(
                                      title: Text(lokasi),
                                      value: lokasi,
                                      groupValue: _lokasiTerpilih,
                                      activeColor: Colors.orange,
                                      onChanged: (value) {
                                        setState(() {
                                          _lokasiTerpilih = value;
                                          _tampilOpsiLokasi = false;
                                        });
                                      },
                                    );
                                  }),
                                  const SizedBox(height: 10),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _lokasiTerpilih =
                                            (_lokasiList..shuffle()).first;
                                        _tampilOpsiLokasi = false;
                                      });
                                    },
                                    icon: const Icon(Icons.casino),
                                    label: const Text(
                                      'Donasikan Secara Random',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange.shade300,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (_lokasiTerpilih != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Text(
                                  'Lokasi dipilih: $_lokasiTerpilih',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _showHistory = !_showHistory;
                                });
                              },
                              child: Text(
                                _showHistory
                                    ? 'Sembunyikan Riwayat'
                                    : 'Lihat Riwayat Donasi',
                                style: TextStyle(color: Colors.orange.shade800),
                              ),
                            ),
                            if (_showHistory)
                              _donationHistory.isEmpty
                                  ? const Text('Belum ada riwayat donasi.')
                                  : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        _donationHistory.map((amount) {
                                          return Card(
                                            color: Colors.orange.shade50,
                                            elevation: 2,
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 4,
                                            ),
                                            child: ListTile(
                                              leading: const Icon(
                                                Icons.receipt,
                                                color: Colors.orange,
                                              ),
                                              title: Text(
                                                'Rp ${_formatCurrency(amount)}',
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                  ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _submitDonation,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 6,
                                  shadowColor: Colors.orange.shade300,
                                ),
                                child: const Text(
                                  'DONASI SEKARANG',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18,
                                    letterSpacing: 1.2,
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
    );
  }
}
