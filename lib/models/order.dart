import 'package:uuid/uuid.dart';
import 'menu_item.dart';

enum OrderStatus { pending, cooking, ready, served, paid }

enum ItemStatus { pending, cooking, ready, served }

class OrderItem {
  final String id;
  final MenuItem menuItem;
  final int quantity;
  final String remarks;
  final ItemStatus itemStatus;

  OrderItem({
    String? id,
    required this.menuItem,
    this.quantity = 1,
    this.remarks = '',
    this.itemStatus = ItemStatus.pending,
  }) : id = id ?? const Uuid().v4();

  double get total => menuItem.price * quantity;

  // Create a copy with updated status
  OrderItem copyWith({ItemStatus? itemStatus}) {
    return OrderItem(
      id: id,
      menuItem: menuItem,
      quantity: quantity,
      remarks: remarks,
      itemStatus: itemStatus ?? this.itemStatus,
    );
  }
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

  // Check if all items are at least ready (ready or served)
  bool get allItemsReady => items.every((item) =>
      item.itemStatus == ItemStatus.ready ||
      item.itemStatus == ItemStatus.served);

  // Check if all items are served
  bool get allItemsServed =>
      items.every((item) => item.itemStatus == ItemStatus.served);

  // Check if any item is cooking
  bool get anyItemCooking =>
      items.any((item) => item.itemStatus == ItemStatus.cooking);
}
