import 'package:flutter/material.dart';
import 'package:gcs_scheduler/engine.dart';

class ClassesTable extends StatelessWidget {
  DataSet dataSet;
  ClassesTable({required this.dataSet});
  
  @override
  Widget build(BuildContext context) {
    List<DataColumn> columns = [];
    columns.add(DataColumn(label: Text("#")));
    for(var x=0; x<dataSet.data[0].length; x++) {
      columns.add(DataColumn(label: Text("${x+1}")));
    }
    List<DataRow> rows = []; 
    for(var x=0; x<dataSet.data.length; x++) {
      List<DataCell> cells = [];
      cells.add(DataCell(Text("${x+1}")));
      for(var y=0; y<dataSet.data[x].length; y++) {
        cells.add(DataCell(Text("${dataSet.data[x][y]!+1}")));
      }
      rows.add(DataRow(cells: cells));
    }
    return DataTable(
        columns: columns, 
        rows: rows);
  }
  
}