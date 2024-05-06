/*
 * @Descripttion: 用于计算分辨率的工具类
 * @version: 
 * @Author: DonJuaning
 * @Date: 2020-09-02 15:43:09
 * @LastEditors: DonJuaning
 * @LastEditTime: 2024-05-06 19:41:59
 */
import 'dart:ui';

import 'package:flutter/material.dart';

class JKSizeFit {
  // 分辨率的宽度
  static late double physicalWith;
  // 分辨率的宽度
  static late double physicalHeight;

  // 获取 dpr 倍率 @1x @2x @3x
  static late double dpr;

  // 屏幕的宽度和高度
  static late double screenWidth;
  static late double screenHeight;

  // 状态栏的高度
  // 顶部状态栏的高度，有刘海的44，没有刘海的20
  static late double topStatusHeight;
  // 导航栏的高度
  static late double navigationBarHeight;
  // 底部的高度，有刘海的34，没有刘海的0
  static late double bottomHeight;
  // 底部tabbar的高度
  static late double bottomTabBarHeight;

  // rpx 和 px
  static late double rpx;
  static late double px;

  // 判断是手机是不是 iphoneX
  static late bool isIphoneX;

  // 模仿小程序以 6s 宽度的 750 分辨率为适配基点，分成750份
  static void initialze({double standarSize = 750}) {
    // 1.手机物理分辨率
    physicalWith = window.physicalSize.width;
    physicalHeight = window.physicalSize.height;

    // 2.获取 dpr 倍率 @1x @2x @3x
    dpr = window.devicePixelRatio;

    // 3.屏幕的宽度和高度
    screenWidth = physicalWith / dpr;
    screenHeight = physicalHeight / dpr;

    // 4.状态栏的高度
    topStatusHeight = window.padding.top / dpr;
    navigationBarHeight = topStatusHeight + 44;
    bottomHeight = window.padding.bottom / dpr;
    bottomTabBarHeight = bottomHeight + 49;

    // 5.rpx 和 px
    rpx = screenWidth / standarSize;
    px = screenWidth / standarSize * 2;

    // 6.判断是不是iphoneX
    isIphoneX = topStatusHeight > 20 ? true : false;
  }

  static double setRpx(double size) {
    return rpx * size;
  }

  static double setPx(double size) {
    return px * size;
  }
}

extension DoubleFit on double {
  double get px {
    return JKSizeFit.setPx(this);
  }

  double get rpx {
    return JKSizeFit.setRpx(this);
  }
}

extension IntFit on int {
  double get px {
    return JKSizeFit.setPx(this.toDouble());
  }

  double get rpx {
    return JKSizeFit.setRpx(this.toDouble());
  }
}
