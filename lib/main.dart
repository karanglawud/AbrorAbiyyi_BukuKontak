import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buku Kontak',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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

// Tambahkan "with SingleTickerProviderStateMixin"
class _HalamanBerandaState extends State<HalamanBeranda> with SingleTickerProviderStateMixin {
  List<Map<String, String>> contacts = [];
  
  // Buat TabController manual
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller untuk 2 tab
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Hapus DefaultTabController, langsung return Scaffold
    return Scaffold(
      appBar: AppBar(
        title: const Text('BUKU KONTAK'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController, // Hubungkan controller ke TabBar
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.purple,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: 'Kontak'),
            Tab(icon: Icon(Icons.star), text: 'Favorit'),
          ],
        ),
      ),
      drawer: Drawer( // Tidak perlu Builder lagi
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
                _tabController.animateTo(0); // Pindah ke Tab Kontak
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Tambah Kontak'),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.pushNamed(context, '/tambah');
                if (result != null) {
                  final data = result as Map;
                  setState(() {
                    contacts.add({
                      'nama': data['nama'].toString(),
                      'email': data['email'].toString(),
                      'phone': data['phone'].toString(),
                    });
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Favorit'),
              onTap: () {
                Navigator.pop(context); 
                _tabController.animateTo(1); // Pindah ke Tab Favorit
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
        controller: _tabController, // Hubungkan controller ke TabBarView
        children: [
          // Isi Tab 1: Kontak
          contacts.isEmpty
              ? const Center(child: Text('Belum ada kontak'))
              : ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            contacts[index]['nama']![0].toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(contacts[index]['nama']!),
                        subtitle: Text('${contacts[index]['email']!}\n${contacts[index]['phone']!}'),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
          // Isi Tab 2: Favorit
          const Center(child: Text('Belum ada kontak favorit.')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/tambah');
          if (result != null) {
            final data = result as Map;
            setState(() {
              contacts.add({
                'nama': data['nama'].toString(),
                'email': data['email'].toString(),
                'phone': data['phone'].toString(),
              });
            });
          }
        },
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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kontak'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Lengkap'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'No Handphone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Kirim data kembali ke halaman sebelumnya
                Navigator.pop(context, {
                  'nama': nameController.text,
                  'email': emailController.text,
                  'phone': phoneController.text,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade50,
                foregroundColor: Colors.purple,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text('Simpan'),
              ),
            ),
          ],
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