import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/order.dart';
import 'sales_report_screen.dart';

class CounterDashboardScreen extends StatelessWidget {
  const CounterDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
             tooltip: 'Sales Report',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SalesReportScreen())),
          )
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: provider.allTables.length,
            itemBuilder: (context, index) {
              final table = provider.allTables[index];
              final tableOrders = provider.allOrders.where((o) => o.tableId == table.id && o.status != OrderStatus.paid).toList();
              final hasActiveOrders = tableOrders.isNotEmpty;
              final totalBill = tableOrders.fold(0.0, (sum, o) => sum + o.totalAmount);

              return GestureDetector(
                onTap: () {
                  if (hasActiveOrders) {
                    _showTableDetails(context, provider, table.id, table.name, tableOrders, totalBill);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: hasActiveOrders ? Colors.red.withOpacity(0.2) : Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: hasActiveOrders ? Colors.red : Colors.green,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.table_bar, size: 40, color: hasActiveOrders ? Colors.red : Colors.green),
                      const SizedBox(height: 10),
                      Text(table.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      if (hasActiveOrders) ...[
                        const SizedBox(height: 10),
                         Text('Active: ${tableOrders.length}', style: const TextStyle(color: Colors.white70)),
                        Text('Rs. ${totalBill.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                      ] else 
                        const Text('Available', style: TextStyle(color: Colors.greenAccent)),
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

  void _showTableDetails(BuildContext context, AppProvider provider, String tableId, String tableName, List<Order> orders, double total) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$tableName Bill'),
        content: SizedBox(
          width: 400,
          height: 400,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         ...order.items.map((item) => ListTile(
                           title: Text(item.menuItem.name),
                           trailing: Text('Rs. ${item.total.toStringAsFixed(0)}'),
                         )).toList()
                      ],
                    );
                  },
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Text('Rs. ${total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.greenAccent)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            onPressed: () {
               // Mark all orders as paid and free table
               for (var o in orders) {
                 provider.updateOrderStatus(o.id, OrderStatus.paid);
               }
               provider.markTableFree(tableId);
               Navigator.pop(context);
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text('Confirm Payment & Clear Table', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
