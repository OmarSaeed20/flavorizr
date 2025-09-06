import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import '../config/firebase/firebase_config.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Test Firebase connection
  static Future<bool> testConnection() async {
    try {
      // Test Firestore connection
      await _firestore.collection('test').limit(1).get();

      // Log analytics event
      await _analytics.logEvent(
        name: 'firebase_test',
        parameters: {
          'flavor': FirebaseConfig.flavorName,
          'project_id': FirebaseConfig.projectId,
        },
      );

      return true;
    } catch (e) {
      if (kDebugMode) print('Firebase connection test failed: $e');

      return false;
    }
  }

  // Authentication methods
  static Future<User?> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return result.user;
    } catch (e) {
      if (kDebugMode) print('Anonymous sign-in failed: $e');
      return null;
    }
  }

  // Firestore methods
  static Future<void> addTestData() async {
    try {
      await _firestore.collection('tests').add({
        'flavor': FirebaseConfig.flavorName,
        'timestamp': FieldValue.serverTimestamp(),
        'message': 'Test from ${FirebaseConfig.flavorName} environment',
      });
    } catch (e) {
      if (kDebugMode) print('Failed to add test data: $e');
    }
  }
}
