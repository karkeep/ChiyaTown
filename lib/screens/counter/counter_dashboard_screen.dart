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
        backgroundColor: Colors.brown.shade800,
        foregroundColor: Colors.white,
        actions: [
          Consumer<AppProvider>(
            builder: (context, provider, _) {
              final unlockedCount =
                  provider.allTables.where((t) => !t.isLocked).length;
              return IconButton(
                icon: Badge(
                  label: Text('$unlockedCount'),
                  isLabelVisible: unlockedCount > 0,
                  child: const Icon(Icons.lock_open),
                ),
                tooltip: 'Lock All Tables',
                onPressed: () => _showLockAllDialog(context, provider),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Sales Report',
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SalesReportScreen())),
          )
        ],
      ),
      backgroundColor: const Color(0xFF1a1a2e),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          // Separate pending approval orders
          final pendingApprovalOrders = provider.allOrders
              .where((o) => o.status == OrderStatus.pending_approval)
              .toList();

          return Column(
            children: [
              // Pending Approval Section
              if (pendingApprovalOrders.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  color: Colors.purple.shade900,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.pending_actions,
                              color: Colors.purple),
                          const SizedBox(width: 10),
                          Text(
                            'Orders Pending Approval (${pendingApprovalOrders.length})',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: pendingApprovalOrders.length,
                          itemBuilder: (context, index) {
                            final order = pendingApprovalOrders[index];
                            final tableName = provider.allTables
                                .firstWhere((t) => t.id == order.tableId,
                                    orElse: () => provider.allTables.first)
                                .name;
                            return _PendingApprovalCard(
                                order: order,
                                tableName: tableName,
                                provider: provider);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

              // Tables Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: provider.allTables.length,
                  itemBuilder: (context, index) {
                    final table = provider.allTables[index];
                    final tableOrders = provider.allOrders
                        .where((o) =>
                            o.tableId == table.id &&
                            o.status != OrderStatus.paid &&
                            o.status != OrderStatus.pending_approval)
                        .toList();
                    final hasActiveOrders = tableOrders.isNotEmpty;
                    final totalBill =
                        tableOrders.fold(0.0, (sum, o) => sum + o.totalAmount);
                    final isLocked = table.isLocked;

                    return GestureDetector(
                      onTap: () {
                        if (hasActiveOrders) {
                          _showTableDetails(context, provider, table.id,
                              table.name, tableOrders, totalBill);
                        } else if (isLocked) {
                          _showUnlockDialog(
                              context, provider, table.id, table.name);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isLocked
                                ? [Colors.grey.shade800, Colors.grey.shade900]
                                : hasActiveOrders
                                    ? [Colors.red.shade700, Colors.red.shade900]
                                    : [
                                        Colors.green.shade700,
                                        Colors.green.shade900
                                      ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withAlpha(50),
                                blurRadius: 8,
                                offset: const Offset(0, 4))
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isLocked ? Icons.lock : Icons.table_bar,
                              size: 40,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 10),
                            Text(table.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white)),
                            const SizedBox(height: 5),
                            if (isLocked && !hasActiveOrders)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(30),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text('🔒 LOCKED',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 12)),
                              )
                            else if (hasActiveOrders) ...[
                              Text('${tableOrders.length} Orders',
                                  style:
                                      const TextStyle(color: Colors.white70)),
                              const SizedBox(height: 5),
                              Text('Rs. ${totalBill.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white)),
                            ] else
                              const Text('✓ Available',
                                  style: TextStyle(color: Colors.greenAccent)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showLockAllDialog(BuildContext context, AppProvider provider) {
    final unlockedTables =
        provider.allTables.where((t) => !t.isLocked).toList();

    if (unlockedTables.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('All tables are already locked'),
            backgroundColor: Colors.orange),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a4a),
        title: const Row(
          children: [
            Icon(Icons.lock, color: Colors.red),
            SizedBox(width: 10),
            Text('Lock All Tables?', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Text(
          'This will lock ${unlockedTables.length} unlocked table(s).\n\nCustomers will not be able to place orders until you unlock individual tables.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.lock),
            label: const Text('Lock All Tables'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              for (var table in unlockedTables) {
                provider.lockTable(table.id);
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      '${unlockedTables.length} table(s) locked. Business closed.'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showUnlockDialog(BuildContext context, AppProvider provider,
      String tableId, String tableName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a4a),
        title: Text('Unlock $tableName?',
            style: const TextStyle(color: Colors.white)),
        content: const Text(
            'This will allow customers to place orders for this table.',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.lock_open),
            label: const Text('Unlock Table'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              provider.unlockTable(tableId);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showTableDetails(BuildContext context, AppProvider provider,
      String tableId, String tableName, List<Order> orders, double total) {
    showDialog(
      context: context,
      builder: (context) => _TableBillDialog(
        tableId: tableId,
        tableName: tableName,
        orders: orders,
        total: total,
        provider: provider,
      ),
    );
  }
}

class _PendingApprovalCard extends StatelessWidget {
  final Order order;
  final String tableName;
  final AppProvider provider;

  const _PendingApprovalCard(
      {required this.order, required this.tableName, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple.shade800,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tableName,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Expanded(
            child: Text(
              order.items
                  .map((i) => '${i.quantity}x ${i.menuItem.name}')
                  .join(', '),
              style: const TextStyle(color: Colors.white70, fontSize: 12),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rs.${order.totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      // Reject - delete the order
                      provider.updateOrderStatus(
                          order.id, OrderStatus.paid); // Mark as paid to remove
                    },
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon:
                        const Icon(Icons.check, color: Colors.green, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      // Approve - change to pending
                      provider.updateOrderStatus(order.id, OrderStatus.pending);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TableBillDialog extends StatefulWidget {
  final String tableId;
  final String tableName;
  final List<Order> orders;
  final double total;
  final AppProvider provider;

  const _TableBillDialog({
    required this.tableId,
    required this.tableName,
    required this.orders,
    required this.total,
    required this.provider,
  });

  @override
  State<_TableBillDialog> createState() => _TableBillDialogState();
}

class _TableBillDialogState extends State<_TableBillDialog> {
  final Set<String> _itemsToRemove = {};

  double get adjustedTotal {
    double total = 0;
    for (var order in widget.orders) {
      for (var item in order.items) {
        if (!_itemsToRemove.contains(item.id)) {
          total += item.total;
        }
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2a2a4a),
      title: Text('${widget.tableName} Bill',
          style: const TextStyle(color: Colors.white)),
      content: SizedBox(
        width: 450,
        height: 450,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.orders.length,
                itemBuilder: (context, index) {
                  final order = widget.orders[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...order.items.map((item) {
                        final isRemoved = _itemsToRemove.contains(item.id);
                        return ListTile(
                          leading: Checkbox(
                            value: !isRemoved,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  _itemsToRemove.remove(item.id);
                                } else {
                                  _itemsToRemove.add(item.id);
                                }
                              });
                            },
                            activeColor: Colors.green,
                          ),
                          title: Text(
                            '${item.quantity}x ${item.menuItem.name}',
                            style: TextStyle(
                              color: isRemoved ? Colors.white38 : Colors.white,
                              decoration:
                                  isRemoved ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          trailing: Text(
                            'Rs. ${item.total.toStringAsFixed(0)}',
                            style: TextStyle(
                                color:
                                    isRemoved ? Colors.white38 : Colors.white),
                          ),
                        );
                      }),
                      const Divider(color: Colors.white24),
                    ],
                  );
                },
              ),
            ),
            const Divider(color: Colors.white54),
            if (_itemsToRemove.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '${_itemsToRemove.length} item(s) will be removed',
                  style: const TextStyle(color: Colors.orange, fontSize: 12),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white)),
                Text(
                  'Rs. ${adjustedTotal.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.greenAccent),
                ),
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
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          icon: const Icon(Icons.check_circle, color: Colors.white),
          label: const Text('Confirm Payment & Clear Table',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          onPressed: () {
            // Remove selected items
            for (var order in widget.orders) {
              for (var itemId in _itemsToRemove) {
                if (order.items.any((i) => i.id == itemId)) {
                  widget.provider.removeItemFromOrder(order.id, itemId);
                }
              }
            }

            // Mark all orders as paid
            for (var o in widget.orders) {
              widget.provider.updateOrderStatus(o.id, OrderStatus.paid);
            }

            // Free and lock the table
            widget.provider.markTableFree(widget.tableId);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
