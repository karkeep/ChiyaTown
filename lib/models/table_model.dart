class CafeTable {
  final String id;
  final String name; // "Table 1"
  final int capacity;
  final bool isOccupied;
  final bool isLocked; // When true, customers cannot place orders
  final String?
      sessionId; // Unique session token that changes when table is cleared

  CafeTable({
    required this.id,
    required this.name,
    required this.capacity,
    this.isOccupied = false,
    this.isLocked = true, // Default locked until staff opens
    this.sessionId,
  });
}
