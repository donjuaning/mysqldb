/*
 * @Author: DonJuaning
 * @Date: 2024-05-07 15:22:17
 * @LastEditors: DonJuaning
 * @LastEditTime: 2024-05-17 17:47:20
 * @FilePath: /mysqldb/lib/pages/table/new_table.dart
 * @Description: 
 */

import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/material.dart';
import 'package:mysqldb/tool/sizeFit.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysqldb/tool/common.dart';

class db_table {
  /// Creates the db_table class with required details.
  db_table(this.column, this.dataType);

  /// Name of an db_table.
  String column;

  /// Designation of an db_table.
  String dataType;
}

class NewTable extends StatefulWidget {
  NewTable({Key? key, required this.setting}) : super(key: key);
  final String setting;

  @override
  State<NewTable> createState() => _NewTableState();
}

class _NewTableState extends State<NewTable> {
  late db_tableDataSource _db_tableDataSource;
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    db_tables = getdb_tableData();
    _db_tableDataSource = db_tableDataSource(db_tableData: db_tables);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("新建表格"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _save,
          tooltip: 'Increment',
          child: const Icon(Icons.save),
        ),
        body: Column(
          children: [
            Row(children: [
              Expanded(
                child: ClipRRect(
                  child: Container(
                    child: TextField(
                      autofocus: false,
                      controller: _nameController, //设置controller
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: '输入表名',
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                    color: Colors.white,
                    height: 56.rpx,
                    alignment: Alignment.center,
                  ),
                  borderRadius: BorderRadius.circular(12.rpx),
                ),
              ),
            ]),
            SfDataGrid(
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
                        child: TextButton(
                            child: const Text('新增属性'), onPressed: addRow))),
                columns: [
                  GridColumn(
                      columnName: 'column',
                      label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.centerRight,
                          child: Text(
                            'column',
                            overflow: TextOverflow.ellipsis,
                          ))),
                  GridColumn(
                      columnName: 'dataType',
                      label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'dataType',
                            overflow: TextOverflow.ellipsis,
                          ))),
                ]),
          ],
        ));
  }

  void _save() async {
    List<String> mySetting = widget.setting.split(":");
    print(db_tables);
    var sql_string =
        "CREATE TABLE `${mySetting[4]}`.`${_nameController.text}` (";
    for (var i = 0; i < db_tables.length; i++) {
      sql_string += "`${db_tables[i].column}` ${db_tables[i].dataType} NULL,";
    }
    sql_string = sql_string.substring(0, sql_string.length - 1);
    sql_string += ");";
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

  void addRow() {
    db_tables.add(db_table('new_column', 'VARCHAR(655)'));
    _db_tableDataSource.buildDataGridRows(db_tables);
    _db_tableDataSource.updateDataGridSource();
  }
}

List<db_table> db_tables = <db_table>[];
List<db_table> getdb_tableData() {
  return [
    db_table(
      'new_column',
      'VARCHAR(655)',
    ),
    db_table('time_stamp', 'DOUBLE'),
  ];
}

class db_tableDataSource extends DataGridSource {
  dynamic newCellValue;

  /// Helps to control the editable text in the [TextField] widget.
  TextEditingController editingController = TextEditingController();

  /// Creates the db_table data source class with required details.
  db_tableDataSource({required List<db_table> db_tableData}) {
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

    final bool isNumericType =
        column.columnName == 'id' || column.columnName == 'salary';

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
              newCellValue = int.parse(value);
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

    if (column.columnName == 'column') {
      _db_tableData[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'column', value: newCellValue);
      db_tables[dataRowIndex].column = newCellValue.toString();
    } else if (column.columnName == 'dataType') {
      _db_tableData[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'dataType', value: newCellValue);
      db_tables[dataRowIndex].dataType = newCellValue.toString();
    }
  }

  void updateDataGridSource() {
    notifyListeners();
  }

  void buildDataGridRows(List<db_table> db_tableData) {
    _db_tableData = db_tableData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'column', value: e.column),
              DataGridCell<String>(columnName: 'dataType', value: e.dataType),
            ]))
        .toList();
  }
}
