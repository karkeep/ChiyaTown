import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/order.dart';
import '../../providers/app_provider.dart';

class KitchenMonitorScreen extends StatefulWidget {
  const KitchenMonitorScreen({super.key});

  @override
  State<KitchenMonitorScreen> createState() => _KitchenMonitorScreenState();
}

class _KitchenMonitorScreenState extends State<KitchenMonitorScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Update every second for elapsed time
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen Monitor'),
        backgroundColor: Colors.brown.shade800,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFF1a1a2e),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          // Get active orders (not paid/served)
          final activeOrders = provider.allOrders
              .where((o) =>
                  o.status != OrderStatus.paid &&
                  o.status != OrderStatus.served)
              .toList();

          if (activeOrders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant, size: 80, color: Colors.white24),
                  SizedBox(height: 20),
                  Text('No Active Orders',
                      style: TextStyle(fontSize: 24, color: Colors.white38)),
                  SizedBox(height: 10),
                  Text('Orders will appear here',
                      style: TextStyle(color: Colors.white24)),
                ],
              ),
            );
          }

          // Group orders by table
          final ordersByTable = <String, List<Order>>{};
          for (final order in activeOrders) {
            ordersByTable.putIfAbsent(order.tableId, () => []).add(order);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: ordersByTable.length,
            itemBuilder: (context, index) {
              final tableId = ordersByTable.keys.elementAt(index);
              final tableOrders = ordersByTable[tableId]!;
              final tableName = provider.allTables
                  .firstWhere((t) => t.id == tableId,
                      orElse: () => provider.allTables.first)
                  .name;

              return _TableOrdersCard(
                tableName: tableName,
                orders: tableOrders,
                provider: provider,
              );
            },
          );
        },
      ),
    );
  }
}

class _TableOrdersCard extends StatelessWidget {
  final String tableName;
  final List<Order> orders;
  final AppProvider provider;

  const _TableOrdersCard({
    required this.tableName,
    required this.orders,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate total elapsed time from oldest order
    final oldestOrder =
        orders.reduce((a, b) => a.timestamp.isBefore(b.timestamp) ? a : b);
    final elapsed = DateTime.now().difference(oldestOrder.timestamp);
    final elapsedStr = _formatElapsed(elapsed);

    // Determine urgency color based on elapsed time
    Color urgencyColor;
    if (elapsed.inMinutes < 10) {
      urgencyColor = Colors.green;
    } else if (elapsed.inMinutes < 20) {
      urgencyColor = Colors.orange;
    } else {
      urgencyColor = Colors.red;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      color: const Color(0xFF2a2a4a),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with table name and elapsed time
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.brown.shade700,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.table_restaurant, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(
                      tableName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: urgencyColor.withAlpha(50),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: urgencyColor),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.timer, color: urgencyColor, size: 18),
                      const SizedBox(width: 5),
                      Text(
                        elapsedStr,
                        style: TextStyle(
                          color: urgencyColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Orders list
          ...orders
              .map((order) => _OrderSection(order: order, provider: provider)),
        ],
      ),
    );
  }

  String _formatElapsed(Duration d) {
    if (d.inMinutes < 60) {
      return '${d.inMinutes}m ${d.inSeconds % 60}s';
    }
    return '${d.inHours}h ${d.inMinutes % 60}m';
  }
}

class _OrderSection extends StatelessWidget {
  final Order order;
  final AppProvider provider;

  const _OrderSection({required this.order, required this.provider});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(order.status);
    final timeStr = DateFormat('h:mm a').format(order.timestamp);

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withAlpha(30),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: statusColor.withAlpha(100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      order.status.name.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Order @ $timeStr',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              _buildStatusButton(context),
            ],
          ),
          const SizedBox(height: 10),

          // Items list with individual controls
          ...order.items.map((item) => _ItemRow(item: item)),
        ],
      ),
    );
  }

  Widget _buildStatusButton(BuildContext context) {
    String buttonText;
    Color buttonColor;
    OrderStatus? nextStatus;

    switch (order.status) {
      case OrderStatus.pending:
        buttonText = 'Start Cooking';
        buttonColor = Colors.orange;
        nextStatus = OrderStatus.cooking;
        break;
      case OrderStatus.cooking:
        buttonText = 'Mark Ready';
        buttonColor = Colors.green;
        nextStatus = OrderStatus.ready;
        break;
      case OrderStatus.ready:
        buttonText = 'Served';
        buttonColor = Colors.blue;
        nextStatus = OrderStatus.served;
        break;
      default:
        buttonText = 'Done';
        buttonColor = Colors.grey;
        nextStatus = null;
    }

    return ElevatedButton(
      onPressed: nextStatus != null
          ? () => provider.updateOrderStatus(order.id, nextStatus!)
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(buttonText),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.red;
      case OrderStatus.cooking:
        return Colors.orange;
      case OrderStatus.ready:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class _ItemRow extends StatelessWidget {
  final OrderItem item;

  const _ItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.orange.shade700,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${item.quantity}x',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.menuItem.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (item.remarks.isNotEmpty)
                  Text(
                    '📝 ${item.remarks}',
                    style: TextStyle(
                      color: Colors.yellow.shade300,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
