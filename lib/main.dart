import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokemon_app/pages/homepage.dart';
import 'package:pokemon_app/services/database_services.dart';
import 'package:pokemon_app/services/http_services.dart';

Future<void> _setupServices() async {
  GetIt.instance.registerSingleton<HttpServices>(HttpServices());
  GetIt.instance.registerSingleton<DatabaseServices>(DatabaseServices());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setupServices();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Riverpod',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: .fromSeed(seedColor: Colors.tealAccent),
        textTheme: GoogleFonts.quattrocentoSansTextTheme(),
      ),
      home: const MyHomePage(),
    );
  }
}
