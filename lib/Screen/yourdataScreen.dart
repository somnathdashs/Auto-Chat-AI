import 'package:auto_chat_ai/Backend/Localstorage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

class ApiKeyStorageScreen extends StatelessWidget {
  ApiKeyStorageScreen({super.key});

  final TextEditingController apiKeyController = TextEditingController(text: LocalStorage.getString(MyKey.apiKey.toString()));
  final TextEditingController detailsController = TextEditingController(text: LocalStorage.getString(MyKey.details.toString()));

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
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'API Key Storage',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ).animate().fadeIn().slideX(),
                const SizedBox(height: 30),
                _buildGlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Store Your API Key Securely',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: apiKeyController,
                        decoration: InputDecoration(
                          labelText: 'API Key',
                          labelStyle: GoogleFonts.poppins(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2.0),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Enter your API key',
                          hintStyle: GoogleFonts.poppins(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            side: BorderSide(color: Theme.of(context).colorScheme.primary),
                          ),
                          onPressed: () => launchUrl(Uri.parse('https://aistudio.google.com/app/apikey')),
                          icon: const Icon(Icons.key_rounded),
                          label: Text(
                            'Get Gemini API Key',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideX(delay: 200.ms),
                const SizedBox(height: 20),
                _buildGlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Details',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Make AI understand who you are',
                        style: GoogleFonts.poppins(
                          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: detailsController,
                        maxLines: 5,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2.0),
                          ),
                          hintText: 'Enter your details start like: I am XYZ, a ... ',
                          hintStyle: GoogleFonts.poppins(),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideX(delay: 400.ms),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      String apiKey = apiKeyController.text;
                      String details = detailsController.text;
                      LocalStorage.saveString(MyKey.apiKey.toString(), apiKey);
                      LocalStorage.saveString(MyKey.details.toString(), details);
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Data saved successfully!',
                            style: GoogleFonts.poppins(),
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                        ),
                      );
                      
                      await Future.delayed(const Duration(milliseconds: 500));
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.save_rounded),
                    label: Text(
                      'Save Information',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ).animate().fadeIn().slideX(delay: 600.ms),
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
}