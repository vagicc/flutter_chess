import 'cc_base.dart';
import 'step_name.dart';
import 'steps_validate.dart';
import 'cc_recorder.dart';

class Phase {
  String _side = Side.Red; //当前行棋方
  List<String> _pieces = List.generate(90, (index) => Piece.Empty); //
  // var _pieces = List<String>(90);

  BattleResult result = BattleResult.Pending; //

  //无吃子频数、总回合数
  // int halfMove = 0, fullMove = 0;
  // String lastCapturedPhase = '';
  // final _history = <Move>[];
  CCRecorder _recorder = CCRecorder(
      lastCapturedPhase: ''); //CCRecorder(lastCapturedPhase: toFen())

  get halfMove => _recorder.halfMove;
  get fullMove => _recorder.fullMove;
  get lastMove => _recorder.last;
  get lastCapturedPhase => _recorder.lastCapturedPhase;

  get side => _side;

  trunSide() => _side = Side.oppo(_side); //切换行棋方

  String pieceAt(int index) => _pieces[index];

  Phase.defaultPhase() {
    initDefaultPhase();
  }

  void initDefaultPhase() {
    //
    _side = Side.Red;

    _pieces = List.generate(90, (index) => Piece.Empty);
    // 从上到下，棋盘第一行
    _pieces[0 * 9 + 0] = Piece.BlackRook;
    _pieces[0 * 9 + 1] = Piece.BlackKnight;
    _pieces[0 * 9 + 2] = Piece.BlackBishop;
    _pieces[0 * 9 + 3] = Piece.BlackAdvisor;
    _pieces[0 * 9 + 4] = Piece.BlackKing;
    _pieces[0 * 9 + 5] = Piece.BlackAdvisor;
    _pieces[0 * 9 + 6] = Piece.BlackBishop;
    _pieces[0 * 9 + 7] = Piece.BlackKnight;
    _pieces[0 * 9 + 8] = Piece.BlackRook;

    // 从上到下，棋盘第三行
    _pieces[2 * 9 + 1] = Piece.BlackCanon;
    _pieces[2 * 9 + 7] = Piece.BlackCanon;

    // 从上到下，棋盘第四行
    _pieces[3 * 9 + 0] = Piece.BlackPawn;
    _pieces[3 * 9 + 2] = Piece.BlackPawn;
    _pieces[3 * 9 + 4] = Piece.BlackPawn;
    _pieces[3 * 9 + 6] = Piece.BlackPawn;
    _pieces[3 * 9 + 8] = Piece.BlackPawn;

    // 从上到下，棋盘第十行
    _pieces[9 * 9 + 0] = Piece.RedRook;
    _pieces[9 * 9 + 1] = Piece.RedKnight;
    _pieces[9 * 9 + 2] = Piece.RedBishop;
    _pieces[9 * 9 + 3] = Piece.RedAdvisor;
    _pieces[9 * 9 + 4] = Piece.RedKing;
    _pieces[9 * 9 + 5] = Piece.RedAdvisor;
    _pieces[9 * 9 + 6] = Piece.RedBishop;
    _pieces[9 * 9 + 7] = Piece.RedKnight;
    _pieces[9 * 9 + 8] = Piece.RedRook;

    // 从上到下，棋盘第八行
    _pieces[7 * 9 + 1] = Piece.RedCanon;
    _pieces[7 * 9 + 7] = Piece.RedCanon;

    // 从上到下，棋盘第七行
    _pieces[6 * 9 + 0] = Piece.RedPawn;
    _pieces[6 * 9 + 2] = Piece.RedPawn;
    _pieces[6 * 9 + 4] = Piece.RedPawn;
    _pieces[6 * 9 + 6] = Piece.RedPawn;
    _pieces[6 * 9 + 8] = Piece.RedPawn;

    // 其它位置全部填空
    // for (var i = 0; i < 90; i++) {
    //   // _pieces[i] ??Piece.Empty;
    // }

    // lastCapturedPhase = toFen();
    _recorder = CCRecorder(lastCapturedPhase: toFen());
  }

  String? move(int from, int to) {
    //
    if (!validateMove(from, to)) return null;

    final captured = _pieces[to];

    final move = Move(from, to, captured: captured);
    // 翻译着法为中文，后续实现
    StepName.translate(this, move);
    _recorder.stepIn(move, this);

    // 修改棋盘
    _pieces[to] = _pieces[from];
    _pieces[from] = Piece.Empty;

    _recorder.stepIn(Move(from, to, captured: captured), this);

    // 交换走棋方
    _side = Side.oppo(_side);

    return captured;
  }

  // 根据引擎要求，我们将上次咋子以后的所有无咋子着法列出来
  String movesSinceLastCaptured() {
    //
    var steps = '', posAfterLastCaptured = 0;

    for (var i = _recorder.stepsCount - 1; i >= 0; i--) {
      if (_recorder.stepAt(i).captured != Piece.Empty) break;
      posAfterLastCaptured = i;
    }

    for (var i = posAfterLastCaptured; i < _recorder.stepsCount; i++) {
      steps += ' ${_recorder.stepAt(i).step}';
    }

    return steps.length > 0 ? steps.substring(1) : '';
  }

  get manualText => _recorder.buildManualText();

  bool validateMove(int from, int to) {
    // 移动的棋子的选手，应该是当前方
    if (Side.of(_pieces[from]) != _side) return false;

    return (StepValidate.validate(this, Move(from, to)));
    return true;
  }

  //根据局面数据生成局面表示字符串（FEN）
  String toFen() {
    var fen = '';

    for (var row = 0; row < 10; row++) {
      var emptyCounter = 0;
      for (var column = 0; column < 9; column++) {
        final piece = pieceAt(row * 9 + column);
        if (piece == Piece.Empty) {
          emptyCounter++;
        } else {
          if (emptyCounter > 0) {
            fen += emptyCounter.toString();
            emptyCounter = 0;
          }
          fen += piece;
        }
      }
      if (emptyCounter > 0) {
        fen += emptyCounter.toString();
      }
      if (row < 9) fen += '/';
    }

    fen += ' $side';

    fen += ' - - ';

    // fen += '$halfMove $fullMove';
    fen += '${_recorder?.halfMove ?? 0} ${_recorder?.fullMove ?? 0}';

    return fen;
  }

  //复制相同的类
  Phase.clone(Phase other) {
    // _pieces=List<String>();
    _pieces = List.generate(90, (index) => Piece.Empty);

    other._pieces.forEach((piece) => _pieces.add(piece));

    _side = other._side;
    // halfMove = other.halfMove;
    // fullMove = other.fullMove;
    _recorder = other._recorder;
  }

  void moveTest(Move move, {trunSide = false}) {
    _pieces[move.to] = _pieces[move.from];
    _pieces[move.from] = Piece.Empty;

    if (trunSide) _side = Side.oppo(_side);
  }

  /* 悔棋 */
  bool regret() {
    // 首先撤销最后一条行棋记录
    final lastMove = _recorder.removeLast();
    if (lastMove == null) return false;

    // 还原到最后一步行棋之前的局面
    _pieces[lastMove.from] = _pieces[lastMove.to];
    _pieces[lastMove.to] = lastMove.captured;

    // 回调行棋方
    _side = Side.oppo(_side);

    // 还原着法计数器
    final counterMarks = CCRecorder.fromCounterMarks(lastMove.counterMarks);
    _recorder.halfMove = counterMarks.halfMove;
    _recorder.fullMove = counterMarks.fullMove;

    /// 更新最近一个咋子着法
    /// 这儿有点逻辑，因为引擎理解局面需要传递上一次的吃子局面，以及此后的无咋子着法列表
    /// 所以如果刚撤销的着法是吃子着法，我们就需要再向前找上一个吃子着法
    if (lastMove.captured != Piece.Empty) {
      //
      // 查找上一个吃子局面（或开局），NativeEngine 需要
      final tempPhase = Phase.clone(this);

      final moves = _recorder.reverseMovesToPrevCapture();
      moves.forEach((move) {
        //
        tempPhase._pieces[move.from] = tempPhase._pieces[move.to];
        tempPhase._pieces[move.to] = move.captured;

        tempPhase._side = Side.oppo(tempPhase._side);
      });

      _recorder.lastCapturedPhase = tempPhase.toFen();
    }

    // 将游戏结果重新设置为未决
    // 例如引擎已经将你杀败，你点击悔棋后，需要将游戏结果从失败变回未决
    result = BattleResult.Pending;

    return true;
  }
}
