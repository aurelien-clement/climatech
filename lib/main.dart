// main.dart

// Importations nécessaires
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/app_theme.dart';
import 'screens/screen_splash.dart';
import 'screens/screen_home.dart';

// Global key for logging messages in a snackbar
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();// Necessary for asynchronous initialization
  await initializeDateFormatting("fr_FR", null);
  await dotenv.load(fileName: ".env");
  runApp(const ClimatechApp());
}

class ClimatechApp extends StatefulWidget {
  const ClimatechApp({super.key});

  @override
  ClimatechAppState createState() => ClimatechAppState();
}

class ClimatechAppState extends State<ClimatechApp> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initializing necessary data before launching the main screen
    AppTheme.initialize(context); 
    await Future.delayed(const Duration(seconds: 2)); // Simulating a loading delay
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClimaTech',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo),
        useMaterial3: true,
      ),

      // Date formatting:
      locale: const Locale('fr', 'FR'),
      supportedLocales: const [Locale('fr', 'FR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      scaffoldMessengerKey: scaffoldMessengerKey,
      home: _isInitialized ? const ScreenHome() : const ScreenSplash(),
    );
  }
}
