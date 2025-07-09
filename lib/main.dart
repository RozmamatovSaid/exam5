import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam5/firebase_options.dart';
import 'package:exam5/features/videos/presentation/screens/videos_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  checkFirestoreConnection();
  runApp(ProviderScope(child: MainApp()));
}

void checkFirestoreConnection() async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('videos')
        .get();
    print("Firestoredan ${snapshot.docs.length} ta video topildi");
  } catch (e) {
    print("Firestore ulanishda xatolik: $e");
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VideosScreen(),
    );
  }
}
