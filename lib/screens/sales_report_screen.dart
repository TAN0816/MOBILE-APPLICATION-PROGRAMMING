import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:secondhand_book_selling_platform/model/user.dart';
import 'package:secondhand_book_selling_platform/services/report_service.dart';
import 'package:secondhand_book_selling_platform/services/user_service.dart';
import 'package:secondhand_book_selling_platform/widgets/appbar_with_back.dart';

class SalesReportPage extends StatefulWidget {
  final String sellerId;

  SalesReportPage({required this.sellerId});

  @override
  _SalesReportPageState createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  final SalesService _salesService = SalesService();
  final UserService _userService = UserService();
  late Future<Map<String, dynamic>> _salesData;

  @override
  void initState() {
    super.initState();
    _salesData = _loadData();
  }

  Future<Map<String, dynamic>> _loadData() async {
    try {
      UserModel user = await _userService.getUserData(widget.sellerId);
      Map<String, int> monthlySales =
          await _salesService.getMonthlySalesData(widget.sellerId);
      return {
        'seller': user,
        'monthlySales': monthlySales,
      };
    } catch (error) {
      print('Error loading data: $error');
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithBackBtn(
        title: ('Sales Report'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _salesData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No sales data available.'));
          } else {
            UserModel seller = snapshot.data!['seller'];
            Map<String, int> monthlySales = snapshot.data!['monthlySales'];
            return _buildSalesReport(seller, monthlySales);
          }
        },
      ),
    );
  }

  Widget _buildSalesReport(UserModel seller, Map<String, int> monthlySales) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildPersonalInfoRow('Name:', seller.username),
                  _buildPersonalInfoRow('Email:', seller.email),
                  _buildPersonalInfoRow('Phone:', seller.phone),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Monthly Sales Analysis',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Expanded(
            child: charts.BarChart(
              _createSalesSeries(monthlySales),
              animate: true,
              domainAxis: charts.OrdinalAxisSpec(
                renderSpec: charts.SmallTickRendererSpec(
                  labelStyle: charts.TextStyleSpec(
                    fontSize: 14,
                    color: charts.MaterialPalette.black,
                  ),
                  labelRotation: 45,
                  minimumPaddingBetweenLabelsPx: 20,
                ),
              ),
              primaryMeasureAxis: charts.NumericAxisSpec(
                renderSpec: charts.GridlineRendererSpec(
                  labelStyle: charts.TextStyleSpec(
                    fontSize: 14,
                    color: charts.MaterialPalette.black,
                  ),
                ),
              ),
              barRendererDecorator: charts.BarLabelDecorator<String>(),
              behaviors: [
                charts.ChartTitle(
                  'Months',
                  behaviorPosition: charts.BehaviorPosition.bottom,
                  titleOutsideJustification:
                      charts.OutsideJustification.middleDrawArea,
                ),
                charts.ChartTitle(
                  'Sales Quantity',
                  behaviorPosition: charts.BehaviorPosition.start,
                  titleOutsideJustification:
                      charts.OutsideJustification.middleDrawArea,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  List<charts.Series<MapEntry<String, int>, String>> _createSalesSeries(
      Map<String, int> monthlySales) {
    return [
      charts.Series<MapEntry<String, int>, String>(
        id: 'Sales',
        domainFn: (entry, _) => entry.key,
        measureFn: (entry, _) => entry.value,
        data: monthlySales.entries.toList(),
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        labelAccessorFn: (entry, _) => '${entry.value}',
      ),
    ];
  }
}
