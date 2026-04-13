import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Screen/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
=======
import 'Screen/EnterContactPage.dart';

void main() {
  runApp(const MyApp());
>>>>>>> 61434a2692d502bb423a0275732ad9686c542c8d
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const LoginPage(), // Set LoginPage as the initial screen
    );
  }
}
=======
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EnterContactPage(),
    );
  }
}
>>>>>>> 61434a2692d502bb423a0275732ad9686c542c8d
