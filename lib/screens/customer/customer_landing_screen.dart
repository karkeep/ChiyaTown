import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import 'customer_menu_screen.dart';
import 'qr_scanner_screen.dart';

class CustomerLandingScreen extends StatelessWidget {
  const CustomerLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Icon(Icons.restaurant_menu,
                    size: 60, color: Colors.orange),
                const SizedBox(height: 10),
                const Text(
                  'Welcome to Chiya Town',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Select your table to start ordering',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 30),

                // Only show QR scanner button on mobile (not web)
                if (!kIsWeb) ...[
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const QRCodeScannerScreen()),
                      );
                    },
                    icon: const Icon(Icons.qr_code_scanner, size: 28),
                    label: const Text('Scan Table QR Code',
                        style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Or select a table below',
                    style: TextStyle(color: Colors.white54),
                  ),
                  const SizedBox(height: 15),
                ] else ...[
                  const Text(
                    'Tap on your table number',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 15),
                ],

                // Table Grid
                Expanded(
                  child: Consumer<AppProvider>(
                    builder: (context, provider, child) {
                      if (provider.allTables.isEmpty) {
                        return const Center(
                          child:
                              CircularProgressIndicator(color: Colors.orange),
                        );
                      }
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.3,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                        itemCount: provider.allTables.length,
                        itemBuilder: (context, index) {
                          final table = provider.allTables[index];
                          return _TableCard(
                            table: table,
                            onTap: () {
                              provider.selectTable(table.id);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const CustomerMenuScreen()),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TableCard extends StatelessWidget {
  final dynamic table;
  final VoidCallback onTap;

  const _TableCard({required this.table, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isOccupied = table.isOccupied;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isOccupied
                  ? [Colors.red.shade800, Colors.red.shade900]
                  : [Colors.green.shade600, Colors.green.shade800],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (isOccupied ? Colors.red : Colors.green).withAlpha(80),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.table_restaurant,
                size: 40,
                color: Colors.white.withAlpha(230),
              ),
              const SizedBox(height: 8),
              Text(
                table.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${table.capacity} seats',
                style: TextStyle(
                  color: Colors.white.withAlpha(180),
                  fontSize: 12,
                ),
              ),
              if (isOccupied)
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Occupied',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
