import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'form_peminjaman.dart';
import 'register_page.dart';
import '../main.dart';

final supabase = Supabase.instance.client;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final noHpController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;
  bool isLoading = false;

  void login() async {
    final noHp = noHpController.text.trim();
    final password = passwordController.text.trim();

    setState(() => isLoading = true);

    try {
      final response = await supabase
          .from('pengguna')
          .select()
          .eq('no_hp', noHp)
          .eq('password', password);

      if (response.isNotEmpty) {
        final penggunaLogin = response[0];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Text("Selamat datang, ${penggunaLogin['nama_pengguna']}!"),
              ],
            ),
            backgroundColor: const Color(0xFF5CB85C),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 2),
          ),
        );

        await Future.delayed(const Duration(seconds: 1));

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => FormPeminjamanPage(penggunaLoginId: penggunaLogin['id']),
          ),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No HP atau password salah")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF111827) : const Color(0xFFF0F4FF),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1F2937) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.07),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E3A5F) : const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.inventory_2_outlined, size: 44, color: Color(0xFF3B82F6)),
                    ),
                    const SizedBox(height: 24),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(text: "Pinjam", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1B3A5C))),
                          TextSpan(text: ".", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1B3A5C))),
                          TextSpan(text: "in", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF5CB85C))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Masuk untuk melanjutkan",
                      style: TextStyle(fontSize: 13, color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF9CA3AF)),
                    ),
                    const SizedBox(height: 28),
                    TextField(
                      controller: noHpController,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        hintText: "No HP",
                        hintStyle: TextStyle(color: isDark ? const Color(0xFF6B7280) : const Color(0xFFB0B7C3), fontSize: 14),
                        prefixIcon: Icon(Icons.phone_outlined, color: isDark ? const Color(0xFF6B7280) : const Color(0xFFB0B7C3), size: 20),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: passwordController,
                      obscureText: hidePassword,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(color: isDark ? const Color(0xFF6B7280) : const Color(0xFFB0B7C3), fontSize: 14),
                        prefixIcon: Icon(Icons.lock_outline, color: isDark ? const Color(0xFF6B7280) : const Color(0xFFB0B7C3), size: 20),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            hidePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: isDark ? const Color(0xFF6B7280) : const Color(0xFFB0B7C3),
                            size: 20,
                          ),
                          onPressed: () => setState(() => hidePassword = !hidePassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                        child: isLoading
                            ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                            : const Text("Login"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 13),
                        children: [
                          TextSpan(text: "Belum punya akun? ", style: TextStyle(color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF9CA3AF))),
                          TextSpan(
                            text: "Register",
                            style: const TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.w600),
                            recognizer: TapGestureRecognizer()..onTap = goToRegister,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (context, mode, _) {
                return IconButton(
                  icon: Icon(
                    mode == ThemeMode.light ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                    color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                  ),
                  onPressed: () {
                    themeNotifier.value = themeNotifier.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}