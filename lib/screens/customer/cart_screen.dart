import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          if (provider.cart.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: provider.cart.length,
                  itemBuilder: (context, index) {
                    final item = provider.cart[index];
                    return ListTile(
                      title: Text(item.menuItem.name),
                      subtitle: item.remarks.isNotEmpty ? Text('Note: ${item.remarks}') : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('x${item.quantity}   Rs. ${item.total.toStringAsFixed(0)}'),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => provider.removeFromCart(item),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E1E1E),
                   borderRadius: BorderRadius.vertical(top: Radius.circular(20)), 
                ),
                 child: Column(
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                         Text('Rs. ${provider.cartTotal.toStringAsFixed(0)}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                       ],
                     ),
                     const SizedBox(height: 20),
                     SizedBox(
                       width: double.infinity,
                       child: ElevatedButton(
                         onPressed: () {
                           provider.placeOrder();
                           showDialog(
                             context: context, 
                             builder: (_) => AlertDialog(
                               title: const Text('Order Sent!'),
                               content: const Text('Your order has been sent to the kitchen.'),
                               actions: [TextButton(onPressed: () {
                                 Navigator.pop(context); // Close dialog
                                 Navigator.pop(context); // Close cart
                               }, child: const Text('OK'))],
                             )
                           );
                         },
                         style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                             foregroundColor: Colors.white,
                           padding: const EdgeInsets.symmetric(vertical: 16),
                         ),
                         child: const Text('PLACE ORDER', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                       ),
                     )
                   ],
                 ),
              )
            ],
          );
        },
      ),
    );
  }
}
