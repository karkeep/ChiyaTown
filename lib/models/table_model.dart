class CafeTable {
  final String id;
  final String name; // "Table 1"
  final int capacity;
  final bool isOccupied;
  final String?
      sessionId; // Unique session token that changes when table is cleared

  CafeTable({
    required this.id,
    required this.name,
    required this.capacity,
    this.isOccupied = false,
    this.sessionId,
  });
}
