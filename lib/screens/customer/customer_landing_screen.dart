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
      appBar: AppBar(title: const Text('Scan Table QR')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Select Your Table',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
             const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const QRCodeScannerScreen()));
              },
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan Table QR Code'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '(Or select manually for Testing)',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<AppProvider>(
                builder: (context, provider, child) {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: provider.allTables.length,
                    itemBuilder: (context, index) {
                      final table = provider.allTables[index];
                      return GestureDetector(
                        onTap: () {
                          provider.selectTable(table.id);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const CustomerMenuScreen()),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: table.isOccupied ? Colors.red.withOpacity(0.3) : Colors.green.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: table.isOccupied ? Colors.red : Colors.green,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.table_restaurant, color: Colors.white, size: 30),
                                const SizedBox(height: 5),
                                Text(
                                  table.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                if (table.isOccupied)
                                  const Text('(Occupied)', style: TextStyle(fontSize: 10, color: Colors.redAccent)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
