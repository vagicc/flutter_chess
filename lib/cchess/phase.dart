import 'cc_base.dart';
import 'steps_validate.dart';

class Phase {
  String _side = Side.Red; //当前行棋方
  List<String> _pieces = List.generate(90, (index) => Piece.Empty); //
  // var _pieces = List<String>(90);

  //无吃子频数、总回合数
  int halfMove = 0, fullMove = 0;

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
  }

  bool move(int from, int to) {
    if (!validateMove(from, to)) return false;

    //记录无吃子步数
    if (_pieces[to] != Piece.Empty) {
      halfMove = 0;
    } else {
      halfMove++;
    }

    //记录总回合数
    if (fullMove == 0) {
      fullMove++;
    } else if (side == Side.Black) {
      fullMove++;
    }

    //修改棋盘
    _pieces[to] = _pieces[from];
    _pieces[from] = Piece.Empty;

    //交换行棋方
    _side = Side.oppo(_side);

    return true;
  }

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

    fen += '$halfMove $fullMove';

    return fen;
  }

  //复制相同的类
  Phase.clone(Phase other) {
    // _pieces=List<String>();
    _pieces = List.generate(90, (index) => Piece.Empty);

    other._pieces.forEach((piece) => _pieces.add(piece));

    _side = other._side;
    halfMove = other.halfMove;
    fullMove = other.fullMove;
  }

  void moveTest(Move move, {trunSide = false}) {
    _pieces[move.to] = _pieces[move.from];
    _pieces[move.from] = Piece.Empty;

    if (trunSide) _side = Side.oppo(_side);
  }
}
