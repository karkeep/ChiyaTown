import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/order.dart';
import '../../providers/app_provider.dart';

class KitchenMonitorScreen extends StatelessWidget {
  const KitchenMonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kitchen Monitor')),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final activeOrders = provider.allOrders.where((o) => o.status != OrderStatus.paid && o.status != OrderStatus.served).toList();
          if (activeOrders.isEmpty) {
            return const Center(child: Text('No active orders', style: TextStyle(fontSize: 24, color: Colors.grey)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: activeOrders.length,
            itemBuilder: (context, index) {
              final order = activeOrders[index];
              return Card(
                color: _getStatusColor(order.status),
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Table: ${provider.allTables.firstWhere((t) => t.id == order.tableId, orElse: () => provider.allTables.first).name}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(DateFormat('h:mm a').format(order.timestamp), style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const Divider(),
                      ...order.items.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Text('${item.quantity}x', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(width: 10),
                            Expanded(child: Text(item.menuItem.name, style: const TextStyle(fontSize: 18))),
                            if(item.remarks.isNotEmpty)
                              Text('(${item.remarks})', style: const TextStyle(color: Colors.yellow, fontStyle: FontStyle.italic)),
                          ],
                        ),
                      )).toList(),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                           ElevatedButton(
                            onPressed: () {
                              final nextStatus = order.status == OrderStatus.pending 
                                  ? OrderStatus.cooking 
                                  : (order.status == OrderStatus.cooking ? OrderStatus.ready : OrderStatus.served);
                              provider.updateOrderStatus(order.id, nextStatus);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black
                            ),
                            child: Text(_getNextActionText(order.status)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending: return Colors.red.withOpacity(0.2);
      case OrderStatus.cooking: return Colors.orange.withOpacity(0.2);
      case OrderStatus.ready: return Colors.green.withOpacity(0.2);
      default: return Colors.grey.withOpacity(0.2);
    }
  }

  String _getNextActionText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending: return 'Start Cooking';
      case OrderStatus.cooking: return 'Mark Ready';
      case OrderStatus.ready: return 'Mark Served';
      default: return 'Close';
    }
  }
}
