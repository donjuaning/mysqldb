import 'dart:convert';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/material.dart';
import 'package:mysqldb/tool/sizeFit.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysqldb/tool/common.dart';
import 'dart:math';

class TableView extends StatefulWidget {
  TableView({Key? key, required this.setting, required this.title})
      : super(key: key);
  final String setting;
  final String title;

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  late db_tableDataSource _db_tableDataSource;
  List<GridColumn> gridColumnList = [];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("${widget.title}"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _save,
          tooltip: 'Increment',
          child: const Icon(Icons.save),
        ),
        body:
            Container(child: KanKanFutureBuilder().fb(_load(), buildGridView)));
  }

  Widget buildGridView(BuildContext context) {
    return SfDataGrid(
        source: _db_tableDataSource,
        allowEditing: true,
        selectionMode: SelectionMode.single,
        navigationMode: GridNavigationMode.cell,
        editingGestureType: EditingGestureType.doubleTap,
        footerFrozenRowsCount: 1,
        footer: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerRight,
            color: Colors.grey[400],
            child: Center(
                child:
                    TextButton(child: const Text('新增数据'), onPressed: addRow))),
        columns: gridColumnList);
  }

  GridColumn _setColumn(columnContent) {
    return GridColumn(
        columnName: columnContent["Field"],
        label: Container(
            padding: EdgeInsets.symmetric(horizontal: 1.0),
            alignment: Alignment.centerLeft,
            child: Text(
              columnContent["Field"],
              overflow: TextOverflow.ellipsis,
            )));
  }

  void addRow() {
    var new_data = {};
    for (var key in tableColumn.keys) {
      if (tableColumn[key]["Type"].toString().contains("varchar")) {
        if (key == "id") {
          new_data[key] =
              DateTime.now().millisecondsSinceEpoch.hashCode.toString();
        } else {
          new_data[key] = "0";
        }
      } else if (tableColumn[key]["Type"].toString().contains("int")) {
        new_data[key] = 0;
      } else if (tableColumn[key]["Type"].toString().contains("double")) {
        if (key == "time_stamp") {
          new_data[key] =
              double.parse(DateTime.now().millisecondsSinceEpoch.toString());
        } else {
          new_data[key] = 0.0;
        }
      }
    }
    db_table_data.add(new_data);
    _db_tableDataSource.buildDataGridRows(db_table_data);
    _db_tableDataSource.updateDataGridSource();
  }

  void _save() async {
    List<String> mySetting = widget.setting.split(":");
    print(db_table_data);
    var sql_string = "REPLACE INTO `${mySetting[4]}`.`${widget.title}` (";
    for (var key in tableColumn.keys) {
      sql_string = sql_string + key + ",";
    }
    sql_string = sql_string.substring(0, sql_string.length - 1) + ") VALUES ";
    for (var i = 0; i < db_table_data.length; i++) {
      sql_string += "(";
      for (var key in tableColumn.keys) {
        if (tableColumn[key]["Type"].toString().contains("varchar")) {
          sql_string += "'${db_table_data[i][key]}',";
        } else {
          sql_string += "${db_table_data[i][key]},";
        }
      }
      sql_string = sql_string.substring(0, sql_string.length - 1) + "),";
    }
    sql_string = sql_string.substring(0, sql_string.length - 1);
    sql_string += ";";
    print(sql_string);
    var settings = ConnectionSettings(
        host: mySetting[0],
        port: int.parse(mySetting[1]),
        user: mySetting[2],
        password: mySetting[3],
        db: mySetting[4]);
    var conn = await MySqlConnection.connect(settings);
    await conn.query(sql_string);
    Navigator.of(context).pop();
  }

  Future<void> _load() async {
    List<String> mySetting = widget.setting.split(":");
    // var sql_string = "SELECT * FROM `${mySetting[4]}`.`${widget.title}`;";
    var sql_string = "desc ${widget.title};";
    var settings = ConnectionSettings(
        host: mySetting[0],
        port: int.parse(mySetting[1]),
        user: mySetting[2],
        password: mySetting[3],
        db: mySetting[4]);
    var conn = await MySqlConnection.connect(settings);
    var results = await conn.query(sql_string);
    List columns = results.toList();
    gridColumnList.clear();
    for (var i = 0; i < columns.length; i++) {
      tableColumn[columns[i]["Field"]] = columns[i];
      gridColumnList.add(_setColumn(columns[i]));
    }

    sql_string = "SELECT * FROM `${mySetting[4]}`.`${widget.title}`;";
    results = await conn.query(sql_string);
    db_table_data.clear();
    var cash_db_table_data = results.toList();
    for (var i = 0; i < cash_db_table_data.length; i++) {
      db_table_data.add(cash_db_table_data[i].fields);
    }

    _db_tableDataSource = db_tableDataSource(db_tableData: db_table_data);
  }
}

class db_tableDataSource extends DataGridSource {
  dynamic newCellValue;

  /// Helps to control the editable text in the [TextField] widget.
  TextEditingController editingController = TextEditingController();

  /// Creates the db_table data source class with required details.
  db_tableDataSource({required List db_tableData}) {
    buildDataGridRows(db_tableData);
  }

  List<DataGridRow> _db_tableData = [];

  @override
  List<DataGridRow> get rows => _db_tableData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    // Text going to display on editable widget
    final String displayText = dataGridRow
            .getCells()
            .firstWhere((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            .value
            ?.toString() ??
        '';

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].

    final bool isNumericType = tableColumn[column.columnName]["Type"]
            .toString()
            .contains("int") ||
        tableColumn[column.columnName]["Type"].toString().contains("double");

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        controller: editingController..text = displayText,
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
        ),
        keyboardType: isNumericType ? TextInputType.number : TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (isNumericType) {
              newCellValue = double.parse(value);
            } else {
              newCellValue = value;
            }
          } else {
            newCellValue = null;
          }
        },
        onSubmitted: (String value) {
          // In Mobile Platform.
          // Call [CellSubmit] callback to fire the canSubmitCell and
          // onCellSubmit to commit the new value in single place.
          submitCell();
        },
      ),
    );
  }

  @override
  void onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    final dynamic oldValue = dataGridRow
            .getCells()
            .firstWhere((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            .value ??
        '';

    final int dataRowIndex = _db_tableData.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }
    if (tableColumn[column.columnName]["Type"].toString().contains("varchar")) {
      _db_tableData[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: column.columnName, value: newCellValue);
      db_table_data[dataRowIndex][column.columnName] = newCellValue.toString();
    } else if (tableColumn[column.columnName]["Type"]
        .toString()
        .contains("int")) {
      _db_tableData[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: column.columnName, value: newCellValue);
      db_table_data[dataRowIndex][column.columnName] = newCellValue;
    } else if (tableColumn[column.columnName]["Type"]
        .toString()
        .contains("double")) {
      print(newCellValue.runtimeType);
      _db_tableData[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<double>(
              columnName: column.columnName, value: newCellValue);
      print(db_table_data);
      db_table_data[dataRowIndex][column.columnName] = newCellValue;
      print(1);
    }
  }

  void updateDataGridSource() {
    notifyListeners();
  }

  void buildDataGridRows(List db_tableData) {
    _db_tableData.clear();
    for (var i = 0; i < db_tableData.length; i++) {
      List<DataGridCell> mycells = [];
      for (var key in tableColumn.keys) {
        if (tableColumn[key]["Type"].toString().contains("varchar")) {
          mycells.add(
            DataGridCell<String>(columnName: key, value: db_tableData[i][key]),
          );
        } else if (tableColumn[key]["Type"].toString().contains("int")) {
          mycells.add(
            DataGridCell<int>(columnName: key, value: db_tableData[i][key]),
          );
        } else if (tableColumn[key]["Type"].toString().contains("double")) {
          mycells.add(
            DataGridCell<double>(columnName: key, value: db_tableData[i][key]),
          );
        }
      }
      _db_tableData.add(DataGridRow(cells: mycells));
    }
  }
}

var tableColumn = {};
List db_table_data = [];
