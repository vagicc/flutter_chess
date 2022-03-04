import 'package:flutter/material.dart';
import '../board/board-widget.dart';

class BattlePage extends StatelessWidget {
  //棋盘的纵横方向的边距
  static const BoardMarginV = 10.0, BoardMarginH = 10.0;

  const BattlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.of(context).size;
    final boardHeight = windowSize.width - BoardMarginH * 2;

    return Scaffold(
      appBar: AppBar(title: Text('將帥象棋')),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: BoardMarginH,
          vertical: BoardMarginV,
        ),
        child: BoardWidget(width: boardHeight),
      ),
    );
  }
}
