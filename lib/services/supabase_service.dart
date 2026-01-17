import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import '../models/order.dart';
import '../models/menu_item.dart';
import '../data/menu_data.dart';
import '../models/table_model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Real-time stream of all orders (Kitchen/Counter view)
  Stream<List<Order>> get ordersStream {
    return _client
        .from('orders')
        .stream(primaryKey: ['id'])
        .order('timestamp', ascending: false)
        .map((List<Map<String, dynamic>> data) {
          return data.map((json) {
            // Parse Order Items from JSON
            final List<dynamic> itemsJson = json['items'] ?? [];
            final items = itemsJson.map((item) {
              final menuItem = MenuData.items.firstWhere(
                (m) => m.id == item['menuId'],
                orElse: () => MenuData.items.first,
              );
              return OrderItem(
                id: item['instanceId'],
                menuItem: menuItem,
                quantity: item['quantity'],
                remarks: item['remarks'] ?? '',
                itemStatus: ItemStatus.values.firstWhere(
                  (e) => e.name == (item['itemStatus'] ?? 'pending'),
                  orElse: () => ItemStatus.pending,
                ),
              );
            }).toList();

            return Order(
              id: json['id'],
              tableId: json['table_id'],
              status: OrderStatus.values.firstWhere(
                  (e) => e.name == json['status'],
                  orElse: () => OrderStatus.pending),
              timestamp: DateTime.parse(json['timestamp']).toLocal(),
              items: items,
            );
          }).toList();
        });
  }

  // Real-time stream of tables (syncs occupied status)
  Stream<List<CafeTable>> get tablesStream {
    return _client
        .from('tables')
        .stream(primaryKey: ['id'])
        .order('id', ascending: true)
        .map((data) => data
            .map((json) => CafeTable(
                  id: json['id'],
                  name: json['name'],
                  capacity: json['capacity'],
                  isOccupied: json['is_occupied'] ?? false,
                ))
            .toList());
  }

  Future<void> placeOrder(Order order) async {
    // 1. Convert OrderItems to a JSON storable format
    final itemsJson = order.items
        .map((item) => {
              'instanceId': item.id,
              'menuId': item.menuItem.id,
              'quantity': item.quantity,
              'remarks': item.remarks,
              'itemStatus': item.itemStatus.name,
            })
        .toList();

    // 2. Insert Order
    await _client.from('orders').insert({
      'id': order.id,
      'table_id': order.tableId,
      'status': order.status.name,
      'timestamp': order.timestamp.toUtc().toIso8601String(),
      'items': itemsJson,
      'total_amount': order.totalAmount,
    });

    // 3. Mark Table as Occupied
    await _client
        .from('tables')
        .update({'is_occupied': true}).eq('id', order.tableId);
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _client
        .from('orders')
        .update({'status': status.name}).eq('id', orderId);
  }

  // Update individual item status within an order
  Future<void> updateItemStatus(
      String orderId, String itemId, ItemStatus status) async {
    // 1. Get current order
    final response =
        await _client.from('orders').select('items').eq('id', orderId).single();

    // 2. Update the specific item's status
    final List<dynamic> items = response['items'] ?? [];
    final updatedItems = items.map((item) {
      if (item['instanceId'] == itemId) {
        return {...item, 'itemStatus': status.name};
      }
      return item;
    }).toList();

    // 3. Save back to database
    await _client
        .from('orders')
        .update({'items': updatedItems}).eq('id', orderId);
  }

  Future<void> freeTable(String tableId) async {
    await _client
        .from('tables')
        .update({'is_occupied': false}).eq('id', tableId);
  }
}
