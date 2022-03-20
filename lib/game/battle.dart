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
  move(int from, int to) {
    if (!_phase.move(from, to)) return false;

    _blurIndex = from;
    _focusIndex = to;

    return true;
  }

  // 清除棋子的选中和移动前的位置指示
  clear() {
    _blurIndex = _focusIndex = -1;
  }

  BattleResult scanBattleResult() {
  // TODO:
  return BattleResult.Pending;
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
