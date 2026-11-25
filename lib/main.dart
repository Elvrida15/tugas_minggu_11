import 'dart:async';

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
      title: 'Tugas Asynchronous',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HalamanAsync(),
    );
  }
}

// Jenis kondisi data
enum KondisiData { berhasil, kosong, gagal }

class HalamanAsync extends StatefulWidget {
  const HalamanAsync({super.key});

  @override
  State<HalamanAsync> createState() => _HalamanAsyncState();
}

class _HalamanAsyncState extends State<HalamanAsync> {
  late Future<List<String>> futureData;

  KondisiData kondisi = KondisiData.berhasil;

  @override
  void initState() {
    super.initState();

    // Future dibuat sekali saat halaman dibuka
    futureData = ambilData(KondisiData.berhasil);
  }

  // Fungsi mengambil data pertama
  Future<String> ambilNama() async {
    await Future.delayed(const Duration(seconds: 2));

    return 'Elvrida Kurnia Orita';
  }

  // Fungsi mengambil data kedua
  Future<String> ambilProgramStudi() async {
    await Future.delayed(const Duration(seconds: 1));

    return 'Teknik Komputer';
  }

  // Fungsi utama mengambil data
  Future<List<String>> ambilData(KondisiData jenis) async {
    // Simulasi proses pemuatan
    await Future.delayed(const Duration(seconds: 2));

    // Kondisi gagal
    if (jenis == KondisiData.gagal) {
      throw Exception('Terjadi kesalahan saat mengambil data.');
    }

    // Kondisi kosong
    if (jenis == KondisiData.kosong) {
      return [];
    }

    // Mengambil beberapa data secara bersamaan
    final hasil = await Future.wait([ambilNama(), ambilProgramStudi()])
        .timeout(const Duration(seconds: 3));

    return hasil;
  }

  // Fungsi memuat ulang data
  void muatUlang(KondisiData jenis) {
    setState(() {
      kondisi = jenis;
      futureData = ambilData(jenis);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemrograman Asynchronous'),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 15),

            const Text(
              'Daftar Data Mahasiswa',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              'Contoh penerapan Future, async, await, '
              'dan FutureBuilder.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            // Tombol pengujian kondisi
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {
                    muatUlang(KondisiData.berhasil);
                  },
                  child: const Text('Data Berhasil'),
                ),

                ElevatedButton(
                  onPressed: () {
                    muatUlang(KondisiData.kosong);
                  },
                  child: const Text('Data Kosong'),
                ),

                ElevatedButton(
                  onPressed: () {
                    muatUlang(KondisiData.gagal);
                  },
                  child: const Text('Simulasi Error'),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Menampilkan empat kondisi Future
            Expanded(
              child: FutureBuilder<List<String>>(
                future: futureData,

                builder: (context, snapshot) {
                  // 1. KONDISI LOADING
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.green),

                          SizedBox(height: 15),

                          Text(
                            'Sedang memuat data...',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  // 2. KONDISI ERROR
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 65,
                          ),

                          const SizedBox(height: 15),

                          const Text(
                            'Gagal Memuat Data!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            'Terjadi kesalahan. '
                            'Silakan coba kembali.',
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 20),

                          ElevatedButton.icon(
                            onPressed: () {
                              // Simulasi percobaan ulang
                              muatUlang(KondisiData.berhasil);
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  // Mengambil hasil data
                  final data = snapshot.data ?? [];

                  // 3. KONDISI EMPTY
                  if (data.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.inbox_outlined,
                            color: Colors.orange,
                            size: 65,
                          ),

                          const SizedBox(height: 15),

                          const Text(
                            'Data Masih Kosong',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          const Text('Belum ada data yang tersedia.'),

                          const SizedBox(height: 20),

                          ElevatedButton.icon(
                            onPressed: () {
                              muatUlang(KondisiData.berhasil);
                            },
                            icon: const Icon(Icons.download),
                            label: const Text('Muat Data'),
                          ),
                        ],
                      ),
                    );
                  }

                  // 4. KONDISI SUCCESS
                  return ListView(
                    children: [
                      const Center(
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 60,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Center(
                        child: Text(
                          'Data Berhasil Dimuat',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: const Text('Nama Mahasiswa'),
                          subtitle: Text(data[0]),
                        ),
                      ),

                      Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Icon(Icons.school, color: Colors.white),
                          ),
                          title: const Text('Program Studi'),
                          subtitle: Text(data[1]),
                        ),
                      ),

                      const SizedBox(height: 15),

                      ElevatedButton.icon(
                        onPressed: () {
                          muatUlang(KondisiData.berhasil);
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Muat Ulang Data'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
