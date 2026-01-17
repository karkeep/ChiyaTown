import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';

import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import 'screens/customer/customer_menu_screen.dart';
import 'screens/customer/customer_landing_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Use Environment Variables if available, otherwise fallback to hardcoded (for local dev)
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL',
      defaultValue: 'https://wbyodrisfdnsczknuupz.supabase.co');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY',
      defaultValue:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndieW9kcmlzZmRuc2N6a251dXB6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg2MjA4MjEsImV4cCI6MjA4NDE5NjgyMX0.stZpO42GsZXCTjNAIy423mzOafrvqm15AtEzTWaBZ0Q');

  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    runApp(const ChiyaTownApp());
  } catch (e) {
    debugPrint('Startup Error: $e');
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Startup Error:\n$e',
                style: const TextStyle(color: Colors.red)),
          ),
        ),
      ),
    ));
  }
}

class ChiyaTownApp extends StatelessWidget {
  const ChiyaTownApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MaterialApp(
        title: 'Chiya Town Cafe',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF121212),
          primaryColor: const Color(0xFFE50914), // Red from menu
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFE50914),
            secondary: Color(0xFFE50914),
            surface: Color(0xFF1E1E1E),
          ),
          textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
          useMaterial3: true,
        ),
        home: const AppEntryPoint(),
      ),
    );
  }
}

class AppEntryPoint extends StatefulWidget {
  const AppEntryPoint({super.key});

  @override
  State<AppEntryPoint> createState() => _AppEntryPointState();
}

class _AppEntryPointState extends State<AppEntryPoint> {
  bool _deepLinkHandled = false;

  @override
  void initState() {
    super.initState();
    _handleDeepLink();
  }

  void _handleDeepLink() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uri = Uri.base;
      final provider = Provider.of<AppProvider>(context, listen: false);

      // Check if coming from customer QR code with table ID
      if (uri.queryParameters.containsKey('table')) {
        final tableId = uri.queryParameters['table'];
        if (tableId != null && !_deepLinkHandled) {
          debugPrint('Deep Link detected for table: $tableId');
          _waitForTablesAndNavigate(provider, tableId);
        }
      }
      // Check if customer mode (from QR code without table ID)
      else if (uri.queryParameters.containsKey('mode') &&
          uri.queryParameters['mode'] == 'customer') {
        if (!_deepLinkHandled) {
          _deepLinkHandled = true;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const CustomerLandingScreen()),
          );
        }
      }
    });
  }

  void _waitForTablesAndNavigate(AppProvider provider, String tableId) {
    // If tables are already loaded
    if (provider.allTables.isNotEmpty) {
      _navigateToTable(provider, tableId);
      return;
    }

    // Wait for tables to load (poll every 100ms, max 5 seconds)
    int attempts = 0;
    const maxAttempts = 50;

    void checkAndNavigate() {
      if (_deepLinkHandled) return;

      if (provider.allTables.isNotEmpty) {
        _navigateToTable(provider, tableId);
      } else if (attempts < maxAttempts) {
        attempts++;
        Future.delayed(const Duration(milliseconds: 100), checkAndNavigate);
      } else {
        // Timeout - go to customer landing instead
        _deepLinkHandled = true;
        debugPrint('Timeout waiting for tables, going to landing screen');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CustomerLandingScreen()),
        );
      }
    }

    checkAndNavigate();
  }

  void _navigateToTable(AppProvider provider, String tableId) {
    if (_deepLinkHandled) return;
    _deepLinkHandled = true;

    if (provider.allTables.any((t) => t.id == tableId)) {
      provider.selectTable(tableId);
      debugPrint('Navigating to menu for table: $tableId');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CustomerMenuScreen()),
      );
    } else {
      // Table not found, go to customer landing
      debugPrint('Table $tableId not found, going to landing screen');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CustomerLandingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
