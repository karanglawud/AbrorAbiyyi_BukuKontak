import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ==================== MODEL KONTAK (JSON & NULL SAFETY) ====================
class Kontak {
  final String nama;
  final String email;
  final String phone;
  final String? kategori; // Nullable (String?) sesuai Tugas 4

  Kontak({
    required this.nama,
    required this.email,
    required this.phone,
    this.kategori, // Kategori bersifat opsional
  });

  // Factory constructor untuk mapping JSON (Map<String, dynamic>) ke Object Kontak
  factory Kontak.fromJson(Map<String, dynamic> json) {
    return Kontak(
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      kategori: json['kategori'],
    );
  }

  // Mengubah Object Kontak kembali ke format Map / JSON
  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'email': email,
      'phone': phone,
      'kategori': kategori,
    };
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buku Kontak',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HalamanBeranda(),
        '/tambah': (context) => const HalamanTambahKontak(),
        '/tentang': (context) => const HalamanTentang(),
      },
    );
  }
}

// ==================== HALAMAN BERANDA ====================
class HalamanBeranda extends StatefulWidget {
  const HalamanBeranda({super.key});

  @override
  State<HalamanBeranda> createState() => _HalamanBerandaState();
}

class _HalamanBerandaState extends State<HalamanBeranda>
    with SingleTickerProviderStateMixin {
  // Menggunakan List<Kontak> berorientasi objek
  List<Kontak> contacts = [];

  // TabController manual
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Fungsi navigasi asinkron (Future, Async, Await)
  Future<void> _navigasiTambahKontak() async {
    final result = await Navigator.pushNamed(context, '/tambah');
    if (result != null) {
      final Kontak kontakBaru = result is Kontak
          ? result
          : Kontak.fromJson(Map<String, dynamic>.from(result as Map));
      setState(() {
        contacts.add(kontakBaru);
      });
      // Berpindah otomatis ke tab Kontak (indeks 0) jika sedang di tab lain
      _tabController.animateTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BUKU KONTAK'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.purple,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: 'Kontak'),
            Tab(icon: Icon(Icons.star), text: 'Favorit'),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'BUKU KONTAK',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.contact_page),
              title: const Text('Kontak'),
              onTap: () {
                Navigator.pop(context);
                _tabController.animateTo(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Tambah Kontak'),
              onTap: () async {
                Navigator.pop(context);
                await _navigasiTambahKontak();
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Favorit'),
              onTap: () {
                Navigator.pop(context);
                _tabController.animateTo(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Tentang'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/tentang');
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Isi Tab 1: Kontak
          contacts.isEmpty
              ? const Center(child: Text('Belum ada kontak'))
              : ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final kontak = contacts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            kontak.nama.isNotEmpty
                                ? kontak.nama[0].toUpperCase()
                                : '?',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(kontak.nama),
                        // Menampilkan kategori dengan null-aware operator (??) sesuai Tugas 4
                        subtitle: Text(
                          '${kontak.email}\n${kontak.phone}\nKategori: ${kontak.kategori ?? 'Tanpa kategori'}',
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
          // Isi Tab 2: Favorit
          ListView(
            children: const [
              Card(
                margin: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      'A',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text('Albanie Setyawan'),
                  subtitle: Text(
                    'albanisetyawan@gmail.com\n0895422599631\nKategori: Teman',
                  ),
                  isThreeLine: true,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigasiTambahKontak,
        backgroundColor: Colors.purple.shade100,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ==================== HALAMAN TAMBAH KONTAK ====================
class HalamanTambahKontak extends StatefulWidget {
  const HalamanTambahKontak({super.key});

  @override
  State<HalamanTambahKontak> createState() => _HalamanTambahKontakState();
}

class _HalamanTambahKontakState extends State<HalamanTambahKontak> {
  // GlobalKey untuk validasi FormState sesuai modul
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController categoryController = TextEditingController(); // Controller kategori (Tugas 4)

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  // Fungsi untuk menyimpan kontak dan kembali ke halaman sebelumnya
  void simpanKontak() {
    final kontakBaru = Kontak(
      nama: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      // Jika dikosongkan, nilainya adalah null (Null Safety)
      kategori: categoryController.text.trim().isEmpty
          ? null
          : categoryController.text.trim(),
    );
    // Kirim object kontak kembali ke halaman beranda
    Navigator.pop(context, kontakBaru);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kontak'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Validasi Nama Lengkap
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  hintText: 'Masukkan nama kontak',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama wajib diisi';
                  }
                  if (value.trim().length < 3) {
                    return 'Nama minimal 3 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 2. Validasi Email
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'contoh@domain.com',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email wajib diisi';
                  }
                  // Validasi format email harus ada @ dan domain
                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Format email tidak valid (harus mengandung @ dan domain)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 3. Validasi No Handphone
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'No Handphone',
                  hintText: '08123456789',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'No Handphone wajib diisi';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
                    return 'No Handphone hanya boleh berisi angka';
                  }
                  if (value.trim().length < 10) {
                    return 'No Handphone minimal 10 angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 4. Input Kategori (Opsional - Tugas 4)
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Kategori (Opsional)',
                  hintText: 'Contoh: Keluarga, Teman, Kerja',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 28),

              // Tombol Simpan dengan Pengecekan FormState sebelum memanggil simpanKontak()
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    simpanKontak();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== HALAMAN TENTANG ====================
class HalamanTentang extends StatelessWidget {
  const HalamanTentang({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/product.png'),
            ),
            SizedBox(height: 20),
            Text(
              'Abror Abiyyi',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('XII RPL B', style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            Text('SMK Negeri 5 Surakarta', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
