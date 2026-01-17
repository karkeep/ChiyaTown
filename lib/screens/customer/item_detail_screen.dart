import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/menu_item.dart';
import '../../providers/app_provider.dart';

class ItemDetailScreen extends StatefulWidget {
  final MenuItem item;
  const ItemDetailScreen({super.key, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int quantity = 1;
  final TextEditingController _remarksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.item.name)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             // Placeholder for image if we had one
             Container(
               height: 200,
               width: double.infinity,
               decoration: BoxDecoration(
                 color: Colors.white10,
                 borderRadius: BorderRadius.circular(20),
               ),
               child: const Center(child: Icon(Icons.fastfood, size: 80, color: Colors.white24)),
             ),
             const SizedBox(height: 20),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text(widget.item.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                 Text('Rs. ${widget.item.price.toStringAsFixed(0)}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
               ],
             ),
             const SizedBox(height: 30),
             const Text('Add Remarks (Optional)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
             const SizedBox(height: 10),
             TextField(
               controller: _remarksController,
               decoration: InputDecoration(
                 hintText: 'e.g., Less spicy, no onions...',
                 filled: true,
                 fillColor: Colors.white10,
                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
               ),
               maxLines: 3,
             ),
             const Spacer(),
             Row(
               children: [
                 Container(
                   decoration: BoxDecoration(
                     color: Colors.white10,
                     borderRadius: BorderRadius.circular(15),
                   ),
                   child: Row(
                     children: [
                       IconButton(onPressed: () => setState(() => quantity = quantity > 1 ? quantity - 1 : 1), icon: const Icon(Icons.remove)),
                       Text('$quantity', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                       IconButton(onPressed: () => setState(() => quantity++), icon: const Icon(Icons.add)),
                     ],
                   ),
                 ),
                 const SizedBox(width: 20),
                 Expanded(
                   child: ElevatedButton(
                     onPressed: () {
                       Provider.of<AppProvider>(context, listen: false).addToCart(widget.item, quantity, _remarksController.text);
                       Navigator.pop(context);
                     },
                     style: ElevatedButton.styleFrom(
                       backgroundColor: Theme.of(context).primaryColor,
                       foregroundColor: Colors.white,
                       padding: const EdgeInsets.symmetric(vertical: 20),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                     ),
                     child: Text('Add Rs. ${(widget.item.price * quantity).toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                   ),
                   ),
               ],
             ),
          ],
        ),
      ),
    );
  }
}
