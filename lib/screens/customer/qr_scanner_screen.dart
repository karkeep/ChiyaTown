import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import 'customer_menu_screen.dart';

class QRCodeScannerScreen extends StatefulWidget {
  const QRCodeScannerScreen({super.key});

  @override
  State<QRCodeScannerScreen> createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool _isScanned = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Table QR')),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (_isScanned) return;
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  final String code = barcode.rawValue!;
                  // Assuming QR contains "table.t1", "table.t2" etc. or simply "t1"
                  // For robustness, let's extract the table ID.
                  debugPrint('QR Code found! $code');
                  
                  // Simple parsers for demo: ID strictly matches "t1", "t2", ... "t10"
                  // Or a JSON {"tableId": "t1"}
                  // Let's implement robust matching
                  String? tableId;
                  
                  // Check if the code is exactly our table ID format
                  if (code.startsWith('t') && int.tryParse(code.substring(1)) != null) {
                    tableId = code;
                  } 
                  // Fallback: check if it contains the ID
                  else if (code.contains('table:')) {
                     final parts = code.split(':');
                     if (parts.length > 1) tableId = parts[1].trim();
                  }

                  if (tableId != null) {
                     _isScanned = true;
                     Provider.of<AppProvider>(context, listen: false).selectTable(tableId);
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text('Table $tableId detected!')),
                     );
                     Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const CustomerMenuScreen()),
                      );
                  }
                }
              }
            },
          ),
          Positioned(
            bottom: 50, 
            left: 0, 
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Point camera at Table QR', style: TextStyle(color: Colors.white)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
