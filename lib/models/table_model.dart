class CafeTable {
  final String id;
  final String name; // "Table 1"
  final int capacity;
  final bool isOccupied;

  CafeTable({
    required this.id,
    required this.name,
    required this.capacity,
    this.isOccupied = false,
  });
}
