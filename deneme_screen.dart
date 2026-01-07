import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DenemeScreen extends StatefulWidget {
  const DenemeScreen({super.key});

  @override
  State<DenemeScreen> createState() => _DenemeScreenState();
}

class _DenemeScreenState extends State<DenemeScreen> {
  final TextEditingController _kullaniciAdiController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();

  String sonuc = "";

  final String loginUrl =
      "https://unfrounced-cordia-equiponderant.ngrok-free.dev/api/kullanici/login";

  Future<void> girisKontrol() async {
    setState(() {
      sonuc = "Kontrol ediliyor...";
    });

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "kullaniciAdi": _kullaniciAdiController.text.trim(),
          "sifre": _sifreController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);
      final String message = data["message"] ?? "Bilinmeyen cevap";

      setState(() {
        if (message.toLowerCase().contains("başarılı")) {
          sonuc = "✅ Giriş başarılı";
        } else {
          sonuc = "❌ $message";
        }
      });
    } catch (e) {
      setState(() {
        sonuc = "❌ Sunucuya bağlanılamadı";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Deneme Giriş Ekranı")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _kullaniciAdiController,
              decoration: const InputDecoration(labelText: "Kullanıcı Adı"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _sifreController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Şifre"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: girisKontrol,
              child: const Text("Girişi Kontrol Et"),
            ),
            const SizedBox(height: 30),
            Text(sonuc, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
