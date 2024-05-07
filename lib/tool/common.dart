/*
 * @Descripttion: 系统常量配置
 * @version: 
 * @Author: DonJuaning
 * @Date: 2020-09-05 21:32:22
 * @LastEditors: DonJuaning
 * @LastEditTime: 2024-05-07 17:02:04
 */
import 'package:flutter/material.dart';

class KanKanFutureBuilder {
  static KanKanFutureBuilder instance = KanKanFutureBuilder();
  FutureBuilder fb(Future f, Function b) {
    return FutureBuilder(
      future: f,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            print('还没有开始网络请求');
            return Container();
          case ConnectionState.active:
            print('active');
            return Container();
          case ConnectionState.waiting:
            print('waiting');
            return Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.done:
            print('done');
            if (snapshot.hasError) return Container();
            return b(context);
          default:
            return Container();
        }
      },
    );
  }
}
