import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/menu_item.dart';
import '../models/table_model.dart';
// import '../services/mock_database_service.dart';
import '../services/supabase_service.dart';

class AppProvider with ChangeNotifier {
  // final MockDatabaseService _service = MockDatabaseService(); // OLD
  final SupabaseService _service = SupabaseService(); // NEW

  List<Order> _allOrders = [];
  List<CafeTable> _allTables = [];

  // Cart Logic
  final List<OrderItem> _cart = [];
  String? _currentTableId;

  AppProvider() {
    _service.ordersStream.listen((orders) {
      _allOrders = orders;
      notifyListeners();
    });

    _service.tablesStream.listen((tables) {
      _allTables = tables;
      notifyListeners();
    });
  }

  List<Order> get allOrders => _allOrders;
  List<CafeTable> get allTables => _allTables;
  List<OrderItem> get cart => _cart;
  String? get currentTableId => _currentTableId;

  double get cartTotal => _cart.fold(0, (sum, item) => sum + item.total);

  void selectTable(String tableId) {
    _currentTableId = tableId;
    notifyListeners();
  }

  void addToCart(MenuItem item, int quantity, String remarks) {
    _cart.add(OrderItem(menuItem: item, quantity: quantity, remarks: remarks));
    notifyListeners();
  }

  void removeFromCart(OrderItem item) {
    _cart.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void placeOrder() {
    if (_currentTableId == null || _cart.isEmpty) return;

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tableId: _currentTableId!,
      items: List.from(_cart),
      status: OrderStatus.pending_approval, // Requires staff approval first
      timestamp: DateTime.now(),
    );

    _service.placeOrder(order);
    clearCart();
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    _service.updateOrderStatus(orderId, status);
  }

  void updateItemStatus(String orderId, String itemId, ItemStatus status) {
    _service.updateItemStatus(orderId, itemId, status);
  }

  void markTableFree(String tableId) {
    _service.freeTable(tableId);
  }

  void unlockTable(String tableId) {
    _service.unlockTable(tableId);
  }

  void lockTable(String tableId) {
    _service.lockTable(tableId);
  }

  void removeItemFromOrder(String orderId, String itemId) {
    _service.removeItemFromOrder(orderId, itemId);
  }

  // Helper for sales
  double getTotalSales(DateTime start, DateTime end) {
    return _allOrders
        .where((o) =>
            o.timestamp.isAfter(start) &&
            o.timestamp.isBefore(end) &&
            o.status == OrderStatus.paid)
        .fold(0, (sum, o) => sum + o.totalAmount);
  }
}
