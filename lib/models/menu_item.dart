class MenuItem {
  final String id;
  final String name;
  final String category;
  final double price;
  final List<String> availableExtras; // e.g., "Cheese", "Spice"

  MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.availableExtras = const [],
  });
}
