import 'package:flutter/material.dart';
import '../board/board_widget.dart';
import '../cchess/cc_base.dart';
import '../common/color_consts.dart';
import '../game/battle.dart';
import '../main.dart';
import '../engine/clound_engine.dart';

/* 
要在 vscode 中，如果需要将一个 StatelessWidget 修改为 StatefulWidget，
可以先将光标移动到 BattlePage 类声明语句上，
然后按「Cmd+.」，在弹出的菜单中点 「Convert to StatefulWidget」 菜单项。
 */
class BattlePage extends StatefulWidget {
  //棋盘的纵横方向的边距
  static double boardMargin = 10.0, screenPaddingH = 10.0;

  const BattlePage({Key? key}) : super(key: key);

  @override
  State<BattlePage> createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  String _status = '';
  changeStatus(String status) => setState(() => _status = status);

  engineToGo() async {
    changeStatus('对方思考中……');

    final response = await CloudEngine().search(Battle.shared.phase);

    if (response.type == 'move') {
      final step = response.value;
      Battle.shared.phase.move(step.from, step.to);

      final result = Battle.shared.scanBattleResult();

      switch (result) {
        case BattleResult.Pending:
          changeStatus('请走棋……');
          break;
        case BattleResult.Win:
          changeStatus('你输了');
          gotWin();
          break;
        case BattleResult.Lose:
          gotLose();
          break;
        case BattleResult.Draw:
          gotDraw();
          // todo:
          break;
      }
    } else {
      changeStatus('出鑤：${response.type}');
    }
  }

  void calcScreenPaddingH() {
    final windowSize = MediaQuery.of(context).size;
    double height = windowSize.height, width = windowSize.width; //屏幕的高和宽

    if (height / width < 16.0 / 9.0) {
      width = height / 16 * 9;
      BattlePage.screenPaddingH =
          (windowSize.width - width) / 2 - BattlePage.boardMargin;
    }
  }

  Widget CreatePageHeader() {
    final titleStyle =
        TextStyle(fontSize: 28, color: ColorConsts.DarkTextPrimary);
    final subTitleStyle =
        TextStyle(fontSize: 16, color: ColorConsts.DarkTextSecondary);

    return Container(
      margin: const EdgeInsets.only(top: MyApp.StatusBarHeight),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon:
                    Icon(Icons.arrow_back, color: ColorConsts.DarkTextPrimary),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Expanded(child: SizedBox()),
              Text('单机对战', style: titleStyle),
              Expanded(child: SizedBox()),
              IconButton(
                icon: Icon(Icons.settings, color: ColorConsts.DarkTextPrimary),
                onPressed: () {},
              ),
            ],
          ),
          Container(
            height: 4,
            width: 180,
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: ColorConsts.BoardBackground,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _status,
              maxLines: 1,
              style: subTitleStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget CreateBoard() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: BattlePage.screenPaddingH,
        vertical: BattlePage.boardMargin,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: ColorConsts.BoardBackground,
      ),
      child: BoardWidget(
        // 棋盘的宽度已经扣除了部分边界
        width:
            MediaQuery.of(context).size.width - BattlePage.screenPaddingH * 2,
        onBoardTap: onBoardTap,
      ),
    );
  }

  Widget CreateOperatorBar() {
    //
    final buttonStyle = TextStyle(color: ColorConsts.Primary, fontSize: 20);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: ColorConsts.BoardBackground,
      ),
      margin: EdgeInsets.symmetric(horizontal: BattlePage.screenPaddingH),
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(children: <Widget>[
        Expanded(child: SizedBox()),
        TextButton(child: Text('新对局', style: buttonStyle), onPressed: newGame),
        Expanded(child: SizedBox()),
        TextButton(child: Text('悔棋', style: buttonStyle), onPressed: () {}),
        Expanded(child: SizedBox()),
        TextButton(child: Text('分析局面', style: buttonStyle), onPressed: () {}),
        Expanded(child: SizedBox()),
      ]),
    );
  }

  /* 底部的空间 */
  Widget BuildFooter() {
    final size = MediaQuery.of(context).size;
    String manualText = '<暂无棋谱>';

    if (size.height / size.width > 16 / 9) {
      //长屏幕布显示处理:直接显示着法列表
      print("长屏幕布显示处理:直接显示着法列表");
      return buildManualPanel(manualText);
    } else {
      //短屏幕显示处理：只显示一个按纽，点击它后弹出着法列表
      print("短屏幕显示处理：只显示一个按纽，点击它后弹出着法列表");
      return buildExpandableManaulPanel(manualText);
    }
  }

  /* 长屏幕：着法显示 */
  Widget buildManualPanel(String text) {
    final manualStyle = TextStyle(
      fontSize: 18,
      color: ColorConsts.DarkTextSecondary,
      height: 1.5,
    );

    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16),
        child: SingleChildScrollView(child: Text(text, style: manualStyle)),
      ),
    );
  }

  /* 短屏幕：着法显示 */
  Widget buildExpandableManaulPanel(String text) {
    final manualStyle = TextStyle(fontSize: 18, height: 1.5);
    return Expanded(
      child: IconButton(
        icon: Icon(Icons.expand_less, color: ColorConsts.DarkTextPrimary),
        onPressed: () => showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('棋谱', style: TextStyle(color: ColorConsts.Primary)),
                content: SingleChildScrollView(
                  child: Text(text, style: manualStyle),
                ),
                actions: [
                  TextButton(
                    child: Text("好的"),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              );
            }),
      ),
    );
  }

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
        final result = Battle.shared.scanBattleResult();

        switch (result) {
          case BattleResult.Pending:
            // 玩家走一步棋后，如果游戏还没有结束，则启动引擎走棋
            engineToGo();
            break;
          case BattleResult.Win:
            gotWin();
            break;
          case BattleResult.Lose:
            gotLose();
            break;
          case BattleResult.Draw:
            gotDraw();
            break;
        }
      }
      //
    } else {
      // 之前未选择棋子，现在点击就是选择棋子
      if (tapedPiece != Piece.Empty) Battle.shared.select(pos);
    }

    setState(() {});
  }

  //重新开始
  newGame() {
    //确认重新开始
    confirm() {
      Navigator.of(context).pop();
      Battle.shared.newGame();
      setState(() {});
    }

    //取消重新开始
    cancel() => Navigator.of(context).pop();

    //点击重新开始，需要用户确认
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('放弃对局？', style: TextStyle(color: ColorConsts.Primary)),
            content: SingleChildScrollView(child: Text('你确定放弃')),
            actions: <Widget>[
              TextButton(child: Text('确定'), onPressed: confirm),
              TextButton(child: Text('取消'), onPressed: cancel),
            ],
          );
        });
  }

  //显示胜利框
  void gotWin() {
    Battle.shared.phase.result = BattleResult.Win;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('羸了', style: TextStyle(color: ColorConsts.Primary)),
          content: Text('恭喜您，胜利了!!'),
          actions: <Widget>[
            TextButton(child: Text("再来一盘"), onPressed: newGame),
            TextButton(
              child: Text('关闭'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  //显示失败框
  void gotLose() {
    Battle.shared.phase.result = BattleResult.Lose;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('输了', style: TextStyle(color: ColorConsts.Primary)),
          content: Text('你输了，虽败犹荣，可敬的对手'),
          actions: <Widget>[
            TextButton(child: Text('再来一盘'), onPressed: newGame),
            TextButton(
                child: Text('关闭'),
                onPressed: () => Navigator.of(context).pop()),
          ],
        );
      },
    );
  }

  //显示和棋
  void gotDraw() {
    Battle.shared.phase.result = BattleResult.Draw;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('和棋', style: TextStyle(color: ColorConsts.Primary)),
          content: Text('势当力敌，和棋了'),
          actions: <Widget>[
            TextButton(child: Text('再来一盘'), onPressed: newGame),
            TextButton(
                child: Text('关闭'),
                onPressed: () => Navigator.of(context).pop()),
          ],
        );
      },
    );
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
    calcScreenPaddingH(); //调用方法来计算边宽度留白
    return Scaffold(
      // appBar: AppBar(title: Text('將帥象棋')),
      backgroundColor: ColorConsts.DarkBackground,
      body: Column(
        children: <Widget>[
          CreatePageHeader(),
          CreateBoard(),
          CreateOperatorBar(),
          BuildFooter(),
        ],
      ),
    );
  }
}
