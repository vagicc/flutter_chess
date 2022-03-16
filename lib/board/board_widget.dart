import 'package:flutter/material.dart';
import '../common/color_consts.dart';
import 'board_painter.dart';
import 'words_on_board.dart';
import 'pieces_painter.dart';
import '../cchess/phase.dart';
import '../game/battle.dart';

class BoardWidget extends StatelessWidget {
  //棋盘内边界，  棋盘上的路数指定文字的高度
  static const Padding = 5.0, DigitsHeight = 36.0;

  //棋盘 宽，高
  final double width, height;

  //棋盘点击事件回调,由board widget的创建者传入
  final Function(BuildContext, int) onBoardTap;

  const BoardWidget({required this.width, required this.onBoardTap})
      : height = (width - Padding * 2) / 9 * 10 + (Padding + DigitsHeight) * 2;

  @override
  Widget build(BuildContext context) {
    // 棋盘
    final boardContainer = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: ColorConsts.BoardBackground,
      ),
      child: CustomPaint(
        painter: BoardPainter(width: width),
        foregroundPainter: PiecesPainter(
          width: width,
          // phase: Phase.defaultPhase(),
          phase: Battle.shared.phase, //棋子分布的 Phase 对象，从 Battle 单例中获取
          focusIndex: Battle.shared.focusIndex,  //棋子选择位置
          blurIndex: Battle.shared.blurIndex,   //棋子移动位置
        ),
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: Padding,
            // 因为棋子是放在交叉线上的，不是放置在格子内，所以棋子左右各有一半在格线之外
            // 这里先依据横盘的宽度计算出一个格子的边长，再依此决定垂直方向的边距
            horizontal: (width - Padding * 2) / 9 / 2 +
                Padding -
                WordsOnBoard.DigitsFontSize / 2,
          ),
          child: const WordsOnBoard(),
        ),
      ),
    );

    // 用 GestureDetector 组件包裹我们的 board 组件，用于检测 board 上的点击事件
    return GestureDetector(
      child: boardContainer,
      onTapUp: (d) {
        print(d.localPosition); //点击的坐标

        //每个格式的边长
        final squareSide = (width - Padding * 2) / 9;
        //网格的总宽度
        final gridWidth = squareSide * 8;

        final dx = d.localPosition.dx, dy = d.localPosition.dy;

        //把点击转换成棋盘上的行、列
        final row = (dy - Padding - DigitsHeight) ~/ squareSide;
        final column = (dx - Padding) ~/ squareSide;

        if (row < 0 || row > 9) {
          print("点击行超出棋盘行棋范围");
          return;
        }
        if (column < 0 || column > 8) {
          print("点击列走出行棋");
          return;
        }

        print('点击了：row:$row, column:$column');
        //回调
        onBoardTap(context, row * 9 + column);
      },
    );
  }
}
