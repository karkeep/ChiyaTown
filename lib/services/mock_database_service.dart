import 'dart:async';
import '../models/order.dart';
import '../models/table_model.dart';
import '../data/menu_data.dart';

class MockDatabaseService {
  static final MockDatabaseService _instance = MockDatabaseService._internal();

  factory MockDatabaseService() => _instance;

  MockDatabaseService._internal() {
    _initTables();
  }

  final List<CafeTable> _tables = [];
  final List<Order> _orders = [];

  final _ordersController = StreamController<List<Order>>.broadcast();
  final _tablesController = StreamController<List<CafeTable>>.broadcast();

  Stream<List<Order>> get ordersStream => _ordersController.stream;
  Stream<List<CafeTable>> get tablesStream => _tablesController.stream;

  void _initTables() {
    // 10 tables
    for (int i = 1; i <= 10; i++) {
      _tables.add(CafeTable(id: 't$i', name: 'Table $i', capacity: 4));
    }
    _notifyTables();
  }

  void placeOrder(Order order) {
    _orders.add(order);
    
    // Update table status
    int index = _tables.indexWhere((t) => t.id == order.tableId);
    if (index != -1) {
      _tables[index] = CafeTable(
        id: _tables[index].id,
        name: _tables[index].name,
        capacity: _tables[index].capacity,
        isOccupied: true,
      );
    }
    
    _notifyOrders();
    _notifyTables();
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    int index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      Order old = _orders[index];
      _orders[index] = Order(
        id: old.id,
        tableId: old.tableId,
        items: old.items,
        status: status,
        timestamp: old.timestamp,
      );
      _notifyOrders();
    }
  }

  void freeTable(String tableId) {
     int index = _tables.indexWhere((t) => t.id == tableId);
    if (index != -1) {
      _tables[index] = CafeTable(
        id: _tables[index].id,
        name: _tables[index].name,
        capacity: _tables[index].capacity,
        isOccupied: false, 
      );
      _notifyTables();
    }
  }

  void _notifyOrders() {
    _ordersController.add(List.from(_orders));
  }

  void _notifyTables() {
    _tablesController.add(List.from(_tables));
  }
  
  List<Order> get currentOrders => List.from(_orders);
}
