import 'package:flutter/material.dart';
import '../board/board_widget.dart';
import '../cchess/cc_base.dart';
import '../game/battle.dart';

/* 
要在 vscode 中，如果需要将一个 StatelessWidget 修改为 StatefulWidget，
可以先将光标移动到 BattlePage 类声明语句上，
然后按「Cmd+.」，在弹出的菜单中点 「Convert to StatefulWidget」 菜单项。
 */
class BattlePage extends StatefulWidget {
  //棋盘的纵横方向的边距
  static const BoardMarginV = 10.0, BoardMarginH = 10.0;

  const BattlePage({Key? key}) : super(key: key);

  @override
  State<BattlePage> createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  // 处理棋盘的点击事件
  onBoardTap(BuildContext context, int pos) {
    print('board cross index: $pos');

    final phase = Battle.shared.phase;

    // 仅 Phase 中的 side 指示一方能动棋
    if (phase.side != Side.Red) return;

    final tapedPiece = phase.pieceAt(pos);

    // 之前已经有棋子被选中了
    if (Battle.shared.focusIndex != -1 &&
        Side.of(phase.pieceAt(Battle.shared.focusIndex)) == Side.Red) {
      //
      // 当前点击的棋子和之前已经选择的是同一个位置
      if (Battle.shared.focusIndex == pos) return;

      // 之前已经选择的棋子和现在点击的棋子是同一边的，说明是选择另外一个棋子
      final focusPiece = phase.pieceAt(Battle.shared.focusIndex);

      if (Side.sameSide(focusPiece, tapedPiece)) {
        //
        Battle.shared.select(pos);
        //
      } else if (Battle.shared.move(Battle.shared.focusIndex, pos)) {
        // 现在点击的棋子和上一次选择棋子不同边，要么是吃子，要么是移动棋子到空白处
        // todo: scan game result
      }
      //
    } else {
      // 之前未选择棋子，现在点击就是选择棋子
      if (tapedPiece != Piece.Empty) Battle.shared.select(pos);
    }

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //使用默认开局棋子分布
    Battle.shared.init();
  }

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.of(context).size;
    final boardHeight = windowSize.width - BattlePage.BoardMarginH * 2;

    return Scaffold(
      appBar: AppBar(title: Text('將帥象棋')),
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: BattlePage.BoardMarginH,
          vertical: BattlePage.BoardMarginV,
        ),
        child: BoardWidget(width: boardHeight, onBoardTap: onBoardTap),
      ),
    );
  }
}
