

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvvm/res/color.dart';
import '../../model/dsf_measure_model.dart';
import '../../respository/dsf_meansure_repository.dart';

class DSFMeasurePopup extends StatefulWidget {
  final String startDate;
  final String endDate;
  final String dsfCode;

  DSFMeasurePopup({
    required this.startDate,
    required this.endDate,
    required this.dsfCode,
  });

  @override
  _DSFMeasurePopupState createState() => _DSFMeasurePopupState();
}

class _DSFMeasurePopupState extends State<DSFMeasurePopup> {
  final dsfMeasureRepository = dsf_measure_Repository();
  late Future<List<DsfMeasureModel>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = fetchData();
  }

  Future<List<DsfMeasureModel>> fetchData() async {
    try {
      return

        await dsfMeasureRepository.fetchData(
        widget.startDate,
        widget.endDate,
        int.parse(widget.dsfCode),
      );
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }

  String formatNumber(String? number) {
    if (number == null || number.isEmpty) {
      return 'N/A';
    }

    double? parsedNumber = double.tryParse(number);

    if (parsedNumber == null) {
      return 'Invalid number';
    }

    final numberFormat = NumberFormat('#,##0.00');
    return numberFormat.format(parsedNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {

          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // Makes the sheet height dynamic
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<List<DsfMeasureModel>>(
                  future: _futureData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: Colors.red),
                      );
                    } else {
                      List<DsfMeasureModel> data = snapshot.data!;
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'DSF KPI',
                              style: TextStyle(
                                color: AppColors.greencolor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            // Dynamically increasing the height using Container
                            Container(
                              height: 500, // Explicitly setting height (increase this value as needed)
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  var item = data[index];
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildDataRow('Name', item.dsfDsfName),
                                      _buildDivider(),
                                      _buildDataRow('SAF Customer', item.safCustomer.toString()),
                                      _buildDivider(),
                                      _buildDataRow('Avg Sku Per Bill', item.avgSkuPerBill?.toStringAsFixed(2) ?? '0.00'),
                                      _buildDivider(),
                                      _buildDataRow('DSF SAF BusinessLine', item.dsfSafBusinessLine),
                                      _buildDivider(),
                                      _buildDataRow('Duration', item.duration.toString()),
                                      _buildDivider(),
                                      _buildDataRow('Eco Percentage', item.ecoPercentage),
                                      _buildDivider(),
                                      _buildDataRow('First Order',
                                          item.firstOrder != null
                                              ? DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(item.firstOrder!))
                                              : 'N/A'),
                                      _buildDivider(),
                                      _buildDataRow('Last Order',
                                          item.lastOrder != null
                                              ? DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(item.lastOrder!))
                                              : 'N/A'),
                                      _buildDivider(),
                                      _buildDataRow('Productive Customer', item.productiveCustomer.toString()),
                                      _buildDivider(),
                                      _buildDataRow('DSF Target Days Remaining', item.DSFTargetDaysDSFRemaining.toString()),
                                      _buildDivider(),
                                      _buildDataRow('DSF Target Days Worked', item.DSFTargetDaysDSFWorked.toString()),
                                      _buildDivider(),
                                      _buildDataRow('DSFTarget %', item.DSFTarget.toString()),
                                      _buildDivider(),
                                      _buildDataRow('DSF Target Remaining', formatNumber(item.DSFTarget_Remaining.toString())),
                                      _buildDivider(),
                                      _buildDataRow('DSF Target Per Day Required', formatNumber(item.DSFTarget_Per_Day_Required.toString())),
                                      _buildDivider(),
                                      _buildDataRow('DSF Target Expected Landing', formatNumber(item.DSFTarget_Expected_Landing.toString())),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );


        },
        child: Text('Show DSF KPI'),
      ),
    );
  }

  Widget _buildDataRow(String heading, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 18),  // Reduced vertical padding between rows
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              '$heading:',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade300,
      thickness: 1,
    );
  }
}
