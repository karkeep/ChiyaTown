import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/menu_data.dart';
import '../../providers/app_provider.dart';
import 'cart_screen.dart';
import 'item_detail_screen.dart';
import 'customer_order_history_screen.dart';

class CustomerMenuScreen extends StatefulWidget {
  const CustomerMenuScreen({super.key});

  @override
  State<CustomerMenuScreen> createState() => _CustomerMenuScreenState();
}

class _CustomerMenuScreenState extends State<CustomerMenuScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> categories = MenuData.items.map((e) => e.category).toSet().toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          splashFactory: NoSplash.splashFactory,
          indicatorColor: Theme.of(context).primaryColor,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: categories.map((c) => Tab(text: c)).toList(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerOrderHistoryScreen()));
            },
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: categories.map((category) {
          final items = MenuData.items.where((i) => i.category == category).toList();
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                color: const Color(0xFF2C2C2C),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Text('Rs. ${item.price.toStringAsFixed(0)}', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('ADD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (_) => ItemDetailScreen(item: item)));
                  },
                ),
              );
            },
          );
        }).toList(),
      ),
      bottomNavigationBar: Consumer<AppProvider>(
        builder: (context, provider, _) {
          if (provider.cart.isEmpty) return const SizedBox.shrink();
          return SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${provider.cart.length} Items', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Rs. ${provider.cartTotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('View Bill'),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
