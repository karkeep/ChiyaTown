import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/app_provider.dart';
import '../../models/order.dart';

class CustomerOrderHistoryScreen extends StatefulWidget {
  const CustomerOrderHistoryScreen({super.key});

  @override
  State<CustomerOrderHistoryScreen> createState() =>
      _CustomerOrderHistoryScreenState();
}

class _CustomerOrderHistoryScreenState
    extends State<CustomerOrderHistoryScreen> {
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
        title: const Text('My Order Status'),
        backgroundColor: Colors.brown.shade800,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFF1a1a2e),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final tableId = provider.currentTableId;
          if (tableId == null) {
            return const Center(
              child: Text('No table selected',
                  style: TextStyle(color: Colors.white54)),
            );
          }

          final myOrders = provider.allOrders
              .where(
                  (o) => o.tableId == tableId && o.status != OrderStatus.paid)
              .toList();
          final grandTotal =
              myOrders.fold(0.0, (sum, o) => sum + o.totalAmount);

          if (myOrders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 80, color: Colors.white24),
                  SizedBox(height: 20),
                  Text('No orders placed yet',
                      style: TextStyle(color: Colors.white54, fontSize: 18)),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Order status cards
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: myOrders.length,
                  itemBuilder: (context, index) {
                    return _OrderStatusCard(order: myOrders[index]);
                  },
                ),
              ),
              // Grand total footer
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.brown.shade800,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(100),
                        blurRadius: 10,
                        offset: const Offset(0, -5))
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Grand Total:',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text('Rs. ${grandTotal.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OrderStatusCard extends StatelessWidget {
  final Order order;

  const _OrderStatusCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('h:mm a').format(order.timestamp);
    final elapsed = DateTime.now().difference(order.timestamp);
    final elapsedStr = _formatElapsed(elapsed);

    // Calculate progress
    final totalItems = order.items.length;
    final readyItems = order.items
        .where((i) =>
            i.itemStatus == ItemStatus.ready ||
            i.itemStatus == ItemStatus.served)
        .length;
    final progress = totalItems > 0 ? readyItems / totalItems : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      color: const Color(0xFF2a2a4a),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _getOrderStatusColor(order.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        order.status.name.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text('Order @ $timeStr',
                        style: const TextStyle(color: Colors.white70)),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer, color: Colors.orange, size: 16),
                      const SizedBox(width: 5),
                      Text(elapsedStr,
                          style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Progress bar
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white24,
                      valueColor: AlwaysStoppedAnimation(
                          progress == 1 ? Colors.green : Colors.orange),
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text('$readyItems / $totalItems',
                    style: TextStyle(
                        color: progress == 1 ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 15),

            // Items with status
            ...order.items.map((item) => _ItemStatusRow(item: item)),

            const SizedBox(height: 10),
            const Divider(color: Colors.white24),

            // Order total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Order Total:',
                    style: TextStyle(color: Colors.white70)),
                Text('Rs. ${order.totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ],
            ),
          ],
        ),
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

  Color _getOrderStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.red;
      case OrderStatus.cooking:
        return Colors.orange;
      case OrderStatus.ready:
        return Colors.green;
      case OrderStatus.served:
        return Colors.blue;
      case OrderStatus.paid:
        return Colors.grey;
    }
  }
}

class _ItemStatusRow extends StatelessWidget {
  final OrderItem item;

  const _ItemStatusRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(item.itemStatus);
    final statusIcon = _getStatusIcon(item.itemStatus);
    final statusText = _getStatusText(item.itemStatus);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: statusColor.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withAlpha(50)),
      ),
      child: Row(
        children: [
          // Quantity
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.orange.shade700,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text('${item.quantity}x',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ),
          ),
          const SizedBox(width: 10),

          // Item name
          Expanded(
            child: Text(item.menuItem.name,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
          ),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(50),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: statusColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusIcon, color: statusColor, size: 14),
                const SizedBox(width: 4),
                Text(statusText,
                    style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ItemStatus status) {
    switch (status) {
      case ItemStatus.pending:
        return Colors.grey;
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
        return Icons.hourglass_empty;
      case ItemStatus.cooking:
        return Icons.local_fire_department;
      case ItemStatus.ready:
        return Icons.check_circle;
      case ItemStatus.served:
        return Icons.delivery_dining;
    }
  }

  String _getStatusText(ItemStatus status) {
    switch (status) {
      case ItemStatus.pending:
        return 'Waiting';
      case ItemStatus.cooking:
        return 'Cooking';
      case ItemStatus.ready:
        return 'Ready!';
      case ItemStatus.served:
        return 'Served';
    }
  }
}
