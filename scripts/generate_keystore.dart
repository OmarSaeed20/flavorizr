import 'dart:io' show File, Process;
import 'dart:math' show Random;

import 'package:flutter/foundation.dart' show kDebugMode;

void main() async {
  final String password = generateSecurePassword();
  const String keyName = "debug";

  if (kDebugMode) print("Generated Password: $password");

  // Ensure no existing keystore conflicts
  final keystoreFile = File("android/app/debug.keystore");
  if (keystoreFile.existsSync()) {
    keystoreFile.deleteSync();
    if (kDebugMode) print("Old keystore deleted.");
  }

  final result = await Process.run("keytool", [
    "-genkeypair", // Use -genkeypair instead of -genkey
    "-v",
    "-keystore", "debug.keystore",
    "-storetype", "JKS",
    "-keyalg", "RSA",
    "-keysize", "2048",
    "-validity", "10000",
    "-alias", keyName,
    "-dname",
    "CN=Flavoriz, OU=Flavoriz, O=Flavoriz, L=Egypt, ST=Alexandria, C=EG",
    "-storepass", password, // Store Password
    "-keypass", password, // Key Password (matches Store Password)
  ], runInShell: true);

  if (result.exitCode == 0) {
    if (kDebugMode) {
      print("✅ Keystore generated successfully! at ${keystoreFile.path}");
    }
    if (kDebugMode) print("🔑 Key Alias: $keyName");
    if (kDebugMode) print("🔑 Key Password: $password");
    if (kDebugMode) print("🔐 Store Password: $password");
  } else {
    if (kDebugMode) print("❌ Error generating keystore: ${result.stderr}");
  }
}

/// Generates a secure password with at least one uppercase, lowercase, and digit.
String generateSecurePassword({int length = 12}) {
  const String upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const String lower = 'abcdefghijklmnopqrstuvwxyz';
  const String digits = '0123456789';
  const String special = '!@#\$%^&*()-_=+<>?';
  const String allChars = upper + lower + digits + special;

  final Random random = Random();
  return upper[random.nextInt(upper.length)] +
      lower[random.nextInt(lower.length)] +
      digits[random.nextInt(digits.length)] +
      List.generate(
        length - 3,
        (index) => allChars[random.nextInt(allChars.length)],
      ).join();
}
