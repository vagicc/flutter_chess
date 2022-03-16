import 'package:flutter/material.dart';
import 'board_widget.dart';
import '../common/color_consts.dart';
import 'dart:math';
import 'painter_base.dart';

/* 画棋盘线 */
class BoardPainter extends PainterBase {
  // 棋盘的宽度， 横盘上线格的总宽度，每一个格子的边长
  // final double width;
  // final thePaint = Paint();

  BoardPainter({required double width}) : super(width: width);

  @override
  void paint(Canvas canvas, Size size) {
    doPaint(
      canvas,
      thePaint,
      gridWidth,
      squareSide,
      offsetX: BoardWidget.Padding + squareSide / 2,
      offsetY: BoardWidget.Padding + BoardWidget.DigitsHeight + squareSide / 2,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  static doPaint(
    Canvas canvas,
    Paint paint,
    double gridWidth,
    double squareSide, {
    required double offsetX,
    required double offsetY,
  }) {
    //
    paint.color = ColorConsts.BoardLine;
    paint.style = PaintingStyle.stroke;

    var left = offsetX, top = offsetY;

    //外框
    paint.strokeWidth = 2;
    canvas.drawRect(Rect.fromLTWH(left, top, gridWidth, squareSide * 9), paint);

    // //中轴线
    // paint.strokeWidth = 1;
    // canvas.drawLine(
    //   Offset(left + gridWidth / 2, top),
    //   Offset(left + gridWidth / 2, top + squareSide * 9),
    //   paint,
    // );

    //8根中间横线
    for (var i = 1; i <= 8; i++) {
      canvas.drawLine(
        Offset(left, top + squareSide * i),
        Offset(left + gridWidth, top + squareSide * i),
        paint,
      );
    }

    //上下各6根短竖线
    for (var i = 0; i < 8; i++) {
      // if (i == 4) continue;

      canvas.drawLine(
        Offset(left + squareSide * i, top),
        Offset(left + squareSide * i, top + squareSide * 4),
        paint,
      );

      canvas.drawLine(
        Offset(left + squareSide * i, top + squareSide * 5),
        Offset(left + squareSide * i, top + squareSide * 9),
        paint,
      );
    }

    //將与帥走法的九宫斜线
    canvas.drawLine(
      Offset(left + squareSide * 3, top),
      Offset(left + squareSide * 5, top + squareSide * 2),
      paint,
    );
    canvas.drawLine(
      Offset(left + squareSide * 3, top + squareSide * 2),
      Offset(left + squareSide * 5, top),
      paint,
    );
    canvas.drawLine(
      Offset(left + squareSide * 3, top + squareSide * 9),
      Offset(left + squareSide * 5, top + squareSide * 7),
      paint,
    );
    canvas.drawLine(
      Offset(left + squareSide * 3, top + squareSide * 7),
      Offset(left + squareSide * 5, top + squareSide * 9),
      paint,
    );

    //炮,兵卒起始位置的标识
    //炮
    final positions = [
      Offset(left + squareSide, top + squareSide * 2),
      Offset(left + squareSide * 7, top + squareSide * 2),
      Offset(left + squareSide, top + squareSide * 7),
      Offset(left + squareSide * 7, top + squareSide * 7),
    ];
    for (var pos in positions) {
      canvas.drawCircle(pos, 5, paint);
    }

    final soldiers = [
      //兵
      Offset(left + squareSide * 2, top + squareSide * 3),
      Offset(left + squareSide * 4, top + squareSide * 3),
      Offset(left + squareSide * 6, top + squareSide * 3),

      //卒
      Offset(left + squareSide * 2, top + squareSide * 6),
      Offset(left + squareSide * 4, top + squareSide * 6),
      Offset(left + squareSide * 6, top + squareSide * 6),
    ];
    soldiers.forEach((pos) => canvas.drawCircle(pos, 5, paint));

    //兵靠边位置指示
    final leftPositions = [
      Offset(left, top + squareSide * 3),
      Offset(left, top + squareSide * 6),
    ];
    leftPositions.forEach((pos) {
      var rect = Rect.fromCenter(center: pos, width: 10, height: 10);
      canvas.drawArc(rect, -pi / 2, pi, true, paint);
    });
    final rightPositions = [
      Offset(left + squareSide * 8, top + squareSide * 3),
      Offset(left + squareSide * 8, top + squareSide * 6),
    ];
    rightPositions.forEach((pos) {
      var rect = Rect.fromCenter(center: pos, width: 10, height: 10);
      canvas.drawArc(rect, pi / 2, pi, true, paint);
    });
  }
}
