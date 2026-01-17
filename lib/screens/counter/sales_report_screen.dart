import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/app_provider.dart';

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({super.key});

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  String _range = 'Daily'; // Daily, Weekly, Monthly

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sales Report')),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final now = DateTime.now();
           DateTime start;
           switch (_range) {
             case 'Weekly':
               start = now.subtract(const Duration(days: 7));
               break;
             case 'Monthly':
               start = now.subtract(const Duration(days: 30));
               break;
             case 'Daily':
             default:
               start = DateTime(now.year, now.month, now.day); 
               break;
           }
           
           final totalSales = provider.getTotalSales(start, now);
           
           return Padding(
             padding: const EdgeInsets.all(16.0),
             child: Column(
               children: [
                 SegmentedButton<String>(
                   segments: const [
                      ButtonSegment(value: 'Daily', label: Text('Daily')),
                      ButtonSegment(value: 'Weekly', label: Text('Weekly')),
                      ButtonSegment(value: 'Monthly', label: Text('Monthly')),
                   ], 
                   selected: {_range},
                   onSelectionChanged: (Set<String> newSelection) {
                     setState(() {
                       _range = newSelection.first;
                     });
                   },
                 ),
                 const SizedBox(height: 40),
                 Card(
                   color: Theme.of(context).primaryColor.withOpacity(0.1),
                   child: Padding(
                     padding: const EdgeInsets.all(20.0),
                     child: Column(
                       children: [
                         Text('Total Sales ($_range)', style: const TextStyle(fontSize: 18)),
                         const SizedBox(height: 10),
                         Text('Rs. ${totalSales.toStringAsFixed(0)}', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                       ],
                     ),
                   ),
                 ),
                 const SizedBox(height: 40),
                 const Text('Sales Trend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                 const SizedBox(height: 20),
                 Expanded(
                   child: totalSales == 0 ? const Center(child: Text('No sales data yet')) : BarChart(
                     BarChartData(
                       gridData: FlGridData(show: false),
                       titlesData: FlTitlesData(show: false),
                       borderData: FlBorderData(show: false),
                       barGroups: [
                         // Placeholder data for demo if no real data
                         BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: totalSales, color: Colors.blueAccent)]),
                       ],
                     ),
                   ),
                 ),
               ],
             ),
           );
        },
      ),
    );
  }
}
