import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTable extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> rows;

  const CustomTable({
    Key? key,
    required this.headers,
    required this.rows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.green),
      columnWidths: _getColumnWidths(headers.length),
      children: [
        _builderHeaderRow(),
        ...rows.asMap().entries.map((entry) {
          int index = entry.key;
          List<String> row = entry.value;
          return _buildDataRow(row, index);
        })
      ],
    );
  }

  TableRow _builderHeaderRow() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.green.shade100),
      children: headers.map((text) => _tableCell(text, true)).toList(),
    );
  }

  TableRow _buildDataRow(List<String> rowData, int index) {
    return TableRow(
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.green.shade50 : Colors.green.shade100,
      ),
      children: rowData.map((text) => _tableCell(text, false)).toList(),
    );
  }

  Widget _tableCell(String text, bool isHeader) {
    return Padding(
      padding: EdgeInsets.all(10.r),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 12.sp,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Map<int, TableColumnWidth> _getColumnWidths(int count) {
    return Map.fromIterable(
      List.generate(count, (index) => index),
      value: (_) => const FlexColumnWidth(),
    );
  }
}
