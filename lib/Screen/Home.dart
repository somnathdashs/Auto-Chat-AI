import 'package:auto_chat_ai/Backend/AINotification.dart';
import 'package:auto_chat_ai/Backend/ForgroundServies.dart';
import 'package:auto_chat_ai/Backend/Notification%20Services.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workmanager/workmanager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../Backend/Localstorage.dart';
import 'yourdataScreen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isWhatsAppEnabled = false;
  bool _isWhatsAppBusinessEnabled = false;
  bool _asYou = false;
  ForgroundServices _forgroundServices = ForgroundServices();
  PackageInfo? packageInfo;

  @override
  void initState() {
    super.initState();
    _initializeSettings();
    PackageInfo.fromPlatform().then((value) {
      packageInfo = value;
    });
  }

  Future<void> _initializeSettings() async {
    await LocalStorage.initialize();
    while (!await AI_Notifiyer.AskPermmission()) {}

    while (!(await DisableBatteryOptimization.isAllBatteryOptimizationDisabled ?? false)) {
      DisableBatteryOptimization.showDisableAllOptimizationsSettings(
          "Enable Auto Start",
          "Follow the steps and enable the auto start of this app",
          "Your device has additional battery optimization",
          "Follow the steps and disable the optimizations to allow smooth functioning of this app");
    }

    setState(() {
      _isWhatsAppEnabled = LocalStorage.getBool(MyKey.Whatsapp.toString()) ?? false;
      _isWhatsAppBusinessEnabled = LocalStorage.getBool(MyKey.WhatsappBusiness.toString()) ?? false;
      _asYou = LocalStorage.getBool(MyKey.Asyou.toString()) ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Auto Chat AI',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ).animate().fadeIn().slideX(),
                const SizedBox(height: 30),
                _buildGlassCard(
                  child: Column(
                    children: [
                      _buildSwitchTile(
                        'Enable WhatsApp',
                        _isWhatsAppEnabled,
                        (value) {
                          setState(() {
                            _isWhatsAppEnabled = value;
                            LocalStorage.saveBool(MyKey.Whatsapp.toString(), value);
                          });
                        },
                      ),
                      const Divider(),
                      _buildSwitchTile(
                        'Enable WhatsApp Business',
                        _isWhatsAppBusinessEnabled,
                        (value) {
                          setState(() {
                            _isWhatsAppBusinessEnabled = value;
                            LocalStorage.saveBool(MyKey.WhatsappBusiness.toString(), value);
                          });
                        },
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideX(delay: 200.ms),
                const SizedBox(height: 20),
                _buildGlassCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _asYou ? "As You" : "Your AI Assistance",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Switch(
                        value: _asYou,
                        onChanged: (value) {
                          setState(() {
                            _asYou = value;
                            LocalStorage.saveBool(MyKey.Asyou.toString(), value);
                          });
                        },
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.green,
                        activeTrackColor: const Color.fromRGBO(68, 138, 255, 0.5),
                        inactiveTrackColor: const Color.fromRGBO(68, 138, 255, 0.5),
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideX(delay: 400.ms),
                const SizedBox(height: 20),
                _buildActionButton(
                  "Start Background AI Reply",
                  () => _forgroundServices.initializeService(),
                  Icons.play_arrow_rounded,
                ).animate().fadeIn().slideX(delay: 600.ms),
                const SizedBox(height: 10),
                _buildActionButton(
                  "Stop Background AI Reply",
                  () => _forgroundServices.StopService(),
                  Icons.stop_rounded,
                ).animate().fadeIn().slideX(delay: 800.ms),
                const SizedBox(height: 20),
                _buildActionButton(
                  "Add API & Details",
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (builder) => ApiKeyStorageScreen()),
                  ),
                  Icons.settings_rounded,
                ).animate().fadeIn().slideX(delay: 1000.ms),
                const SizedBox(height: 20),
                _buildActionButton(
                  "Report Issues",
                  () => launchUrl(Uri.parse('https://github.com/somnathdashs/Auto-Chat-AI/issues')),
                  Icons.bug_report_rounded,
                ).animate().fadeIn().slideX(delay: 1200.ms),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    "App Version: ${packageInfo?.version ?? "v1.1.0"}",
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ).animate().fadeIn(delay: 1400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.1),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed, IconData icon) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
