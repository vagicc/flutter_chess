import '../cchess/cc_rules.dart';
import '../cchess/phase.dart';
import '../cchess/cc_base.dart';

// Battle类:集中管理棋盘上的棋子、对战结果、引擎调用等事务
class Battle {
  Battle._privateCoonstructor();
  static final Battle _instance = Battle._privateCoonstructor();

  static Battle get instance => _instance;

  static Battle get shared {
    // _instance ??= Battle();
    return _instance;
  }

  Phase _phase = Phase.defaultPhase(); //
  int _focusIndex = -1, _blurIndex = -1;

  init() {
    _phase = Phase.defaultPhase();
    _focusIndex = _blurIndex = -1;
  }

  get phase => _phase;
  get focusIndex => _focusIndex;
  get blurIndex => _blurIndex;

  // 点击选中一个棋子，使用 _focusIndex 来标记此位置
  // 棋子绘制时，将在这个位置绘制棋子的选中效果
  select(int pos) {
    _focusIndex = pos;
    _blurIndex = -1;
  }

  // 从 from 到 to 位置移动棋子，使用 _focusIndex 和 _blurIndex 来标记 from 和 to 位置
  // 棋子绘制时，将在这两个位置分别绘制棋子的移动前的位置和当前位置
  bool move(int from, int to) {
    //
    final captured = _phase.move(from, to);

    if (captured == null) {
      // Audios.playTone('invalid.mp3');
      return false;
    }

    _blurIndex = from;
    _focusIndex = to;

    if (ChessRules.checked(_phase)) {
      // Audios.playTone('check.mp3');
    } else {
      // Audios.playTone(captured != Piece.Empty ? 'capture.mp3' : 'move.mp3');
    }

    return true;
  }

  bool regret({steps = 2}) {
    //
    // 轮到自己走棋的时候，才能悔棋
    if (_phase.side != Side.Red) {
      // Audios.playTone('invalid.mp3');
      return false;
    }

    var regreted = false;

    /// 悔棋一回合（两步），才能撤回自己上一次的动棋

    for (var i = 0; i < steps; i++) {
      //
      if (!_phase.regret()) break;

      final lastMove = _phase.lastMove;

      if (lastMove != null) {
        //
        _blurIndex = lastMove.from;
        _focusIndex = lastMove.to;
        //
      } else {
        //
        _blurIndex = _focusIndex = Move.InvalidIndex;
      }

      regreted = true;
    }

    if (regreted) {
      // Audios.playTone('regret.mp3');
      return true;
    }

    // Audios.playTone('invalid.mp3');
    return false;
  }

  // 清除棋子的选中和移动前的位置指示
  clear() {
    _blurIndex = _focusIndex = -1;
  }

  newGame() {
    Battle.shared.phase.initDefaultPhase();
    _focusIndex = _blurIndex = Move.InvalidIndex;
  }

  BattleResult scanBattleResult() {
    final forPerson = (_phase.side == Side.Red);

    if (scanLongCatch()) {
      return forPerson ? BattleResult.Win : BattleResult.Lose;
    }

    if (ChessRules.beKilled(_phase)) {
      return forPerson ? BattleResult.Lose : BattleResult.Win;
    }

    return (_phase.halfMove > 120) ? BattleResult.Draw : BattleResult.Pending;
  }

  //是否存在长将长捉
  bool scanLongCatch() {
    return false;
  }
}

/* 单例工厂示例 */
class Singleton {
  Singleton._privateCoonstructor();

  static final Singleton _instance = Singleton._privateCoonstructor();

  static Singleton get instance {
    return _instance;
  }

  factory Singleton() {
    return _instance;
  }
}

// Singleton s = Singleton(); 
