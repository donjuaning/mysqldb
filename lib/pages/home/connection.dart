import 'package:flutter/material.dart';
import 'package:mysqldb/perfence.dart';
import 'package:mysqldb/tool/sizeFit.dart';
import 'package:mysqldb/pages/add_connection.dart';

class connection extends StatefulWidget {
  const connection({Key? key}) : super(key: key);

  @override
  State<connection> createState() => _connectionState();
}

class _connectionState extends State<connection> {
  List<Widget> itemList = [];
  @override
  void initState() {
    refresh();
    // TODO: implement initState
    super.initState();
  }

  void refresh() {
    setState(() {
      _getConnection();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: itemList,
      physics: new NeverScrollableScrollPhysics(),
    );
  }

  void _add_push() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => addConnection(title: '新建连接')),
    ).then((value) => refresh());
  }

  Widget _setListItem(BuildContext context, int index) {
    var connectiondata = LocalStorage.get("connect_$index");
    return Container(
        width: 80.rpx,
        height: 80.rpx,
        child: TextButton(
          child: Text(
            connectiondata,
          ),
          onPressed: () {},
        ));
  }

  Widget _setAddItem(BuildContext context) {
    return Container(
        width: 80.rpx,
        height: 80.rpx,
        child: FloatingActionButton.extended(
          onPressed: _add_push,
          backgroundColor: Colors.teal,
          icon: const Icon(Icons.add),
          label: const Text("新建"),
        ));
  }

  Future<void> _getConnection() async {
    await LocalStorage.initSP();
    itemList.clear();
    var myCount = int.parse(LocalStorage.get("my_connect"));
    print(myCount);
    for (int i = 1; i <= myCount; i++) {
      itemList.add(_setListItem(context, i));
    }
    itemList.add(_setAddItem(context));
  }
}
