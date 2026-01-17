import 'package:uuid/uuid.dart';
import 'menu_item.dart';

enum OrderStatus { pending, cooking, ready, served, paid }

class OrderItem {
  final String id;
  final MenuItem menuItem;
  final int quantity;
  final String remarks;
  
  OrderItem({
    String? id,
    required this.menuItem,
    this.quantity = 1,
    this.remarks = '',
  }) : id = id ?? const Uuid().v4();

  double get total => menuItem.price * quantity;
}

class Order {
  final String id;
  final String tableId;
  final List<OrderItem> items;
  final OrderStatus status;
  final DateTime timestamp;

  Order({
    required this.id,
    required this.tableId,
    required this.items,
    required this.status,
    required this.timestamp,
  });

  double get totalAmount => items.fold(0, (sum, item) => sum + item.total);
}
