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
    final oldestOrder =
        orders.reduce((a, b) => a.timestamp.isBefore(b.timestamp) ? a : b);
    final elapsed = DateTime.now().difference(oldestOrder.timestamp);
    final elapsedStr = _formatElapsed(elapsed);

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
                    Text(tableName,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
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
                      Text(elapsedStr,
                          style: TextStyle(
                              color: urgencyColor,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ...orders
              .map((order) => _OrderSection(order: order, provider: provider)),
        ],
      ),
    );
  }

  String _formatElapsed(Duration d) {
    final minutes = d.inMinutes.abs();
    final seconds = (d.inSeconds.abs() % 60);
    if (minutes < 60) {
      return '${minutes}m ${seconds}s';
    }
    return '${d.inHours.abs()}h ${minutes % 60}m';
  }
}

class _OrderSection extends StatelessWidget {
  final Order order;
  final AppProvider provider;

  const _OrderSection({required this.order, required this.provider});

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('h:mm a').format(order.timestamp);

    // Calculate order progress
    final totalItems = order.items.length;
    final readyItems =
        order.items.where((i) => i.itemStatus == ItemStatus.ready).length;
    final progress = totalItems > 0 ? readyItems / totalItems : 0.0;

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order @ $timeStr',
                  style: const TextStyle(color: Colors.white70, fontSize: 14)),
              Text('$readyItems / $totalItems ready',
                  style: TextStyle(
                      color: progress == 1 ? Colors.green : Colors.orange)),
            ],
          ),
          const SizedBox(height: 8),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation(
                  progress == 1 ? Colors.green : Colors.orange),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 12),

          // Items with individual status controls
          ...order.items.map((item) => _ItemRowWithControls(
                item: item,
                orderId: order.id,
                provider: provider,
              )),

          const SizedBox(height: 10),

          // Mark all ready / served button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (order.allItemsReady && order.status != OrderStatus.ready)
                ElevatedButton.icon(
                  onPressed: () =>
                      provider.updateOrderStatus(order.id, OrderStatus.ready),
                  icon: const Icon(Icons.check_circle, size: 18),
                  label: const Text('Order Ready'),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              if (order.status == OrderStatus.ready)
                ElevatedButton.icon(
                  onPressed: () =>
                      provider.updateOrderStatus(order.id, OrderStatus.served),
                  icon: const Icon(Icons.delivery_dining, size: 18),
                  label: const Text('Served'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ItemRowWithControls extends StatelessWidget {
  final OrderItem item;
  final String orderId;
  final AppProvider provider;

  const _ItemRowWithControls({
    required this.item,
    required this.orderId,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(item.itemStatus);
    final statusIcon = _getStatusIcon(item.itemStatus);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: statusColor.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withAlpha(100)),
      ),
      child: Row(
        children: [
          // Quantity badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.orange.shade700,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text('${item.quantity}x',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 12),

          // Item name and remarks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.menuItem.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
                if (item.remarks.isNotEmpty)
                  Text('📝 ${item.remarks}',
                      style: TextStyle(
                          color: Colors.yellow.shade300, fontSize: 12)),
              ],
            ),
          ),

          // Status indicator
          Icon(statusIcon, color: statusColor, size: 24),
          const SizedBox(width: 8),

          // Status control buttons
          _buildStatusButton(),
        ],
      ),
    );
  }

  Widget _buildStatusButton() {
    switch (item.itemStatus) {
      case ItemStatus.pending:
        return ElevatedButton(
          onPressed: () =>
              provider.updateItemStatus(orderId, item.id, ItemStatus.cooking),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: const Text('Cook', style: TextStyle(fontSize: 12)),
        );
      case ItemStatus.cooking:
        return ElevatedButton(
          onPressed: () =>
              provider.updateItemStatus(orderId, item.id, ItemStatus.ready),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: const Text('Done', style: TextStyle(fontSize: 12)),
        );
      case ItemStatus.ready:
        return ElevatedButton(
          onPressed: () =>
              provider.updateItemStatus(orderId, item.id, ItemStatus.served),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: const Text('Serve', style: TextStyle(fontSize: 12)),
        );
      case ItemStatus.served:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue.withAlpha(50),
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Text('✓ Served',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
        );
    }
  }

  Color _getStatusColor(ItemStatus status) {
    switch (status) {
      case ItemStatus.pending:
        return Colors.red;
      case ItemStatus.cooking:
        return Colors.orange;
      case ItemStatus.ready:
        return Colors.green;
      case ItemStatus.served:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon(ItemStatus status) {
    switch (status) {
      case ItemStatus.pending:
        return Icons.pending;
      case ItemStatus.cooking:
        return Icons.local_fire_department;
      case ItemStatus.ready:
        return Icons.check_circle;
      case ItemStatus.served:
        return Icons.delivery_dining;
    }
  }
}
