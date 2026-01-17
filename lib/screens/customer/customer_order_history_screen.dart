import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/order.dart';

class CustomerOrderHistoryScreen extends StatelessWidget {
  const CustomerOrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Table Bill')),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final tableId = provider.currentTableId;
          if (tableId == null) return const Center(child: Text('No table selected'));

          final myOrders = provider.allOrders.where((o) => o.tableId == tableId && o.status != OrderStatus.paid).toList();
          final grandTotal = myOrders.fold(0.0, (sum, o) => sum + o.totalAmount);

          if (myOrders.isEmpty) {
            return const Center(child: Text('No orders placed yet.'));
          }

          return Column(
             children: [
               Expanded(
                 child: ListView.builder(
                   itemCount: myOrders.length,
                   itemBuilder: (context, index) {
                     final order = myOrders[index];
                     return Card(
                       margin: const EdgeInsets.all(8),
                       child: ExpansionTile(
                         title: Text('Order #${order.id.substring(0, 4)}'),
                         subtitle: Text('${order.status.name.toUpperCase()} - Rs. ${order.totalAmount.toStringAsFixed(0)}'),
                         children: order.items.map((item) => ListTile(
                           title: Text(item.menuItem.name),
                           trailing: Text('x${item.quantity}'),
                         )).toList(),
                       ),
                     );
                   },
                 ),
               ),
               Container(
                 padding: const EdgeInsets.all(20),
                 color: const Color(0xFF1E1E1E),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     const Text('Grand Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                     Text('Rs. ${grandTotal.toStringAsFixed(0)}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                   ],
                 ),
               ),
             ],
          );
        },
      ),
    );
  }
}
