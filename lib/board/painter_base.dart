import 'package:flutter/material.dart';
import 'board_widget.dart';

//这个类是基于棋盘绘制和棋子绘制类的交集提升出来的基类
abstract class PainterBase extends CustomPainter {
  // 棋盘的宽度， 横盘上线格的总宽度，每一个格子的边长
  final double width; //棋盘的宽度
  final double gridWidth; //横盘上线格的总宽度
  final double squareSide; //每一个格子的边长
  final thePaint = Paint();

  PainterBase({required this.width})
      : gridWidth = (width - BoardWidget.Padding * 2) * 8 / 9,
        squareSide = (width - BoardWidget.Padding * 2) / 9;
}
