import 'cc_base.dart';
import 'phase.dart';

class CCRecorder {
  // 无吃子步数、总回合数
  int halfMove = 0, fullMove = 0;
  late String lastCapturedPhase;
  final _history = <Move>[];

  CCRecorder({required this.lastCapturedPhase});

  // stepAt(int index) => _history[index];
  Move stepAt(int index) => _history[index];

  get stepsCount => _history.length;

  void stepIn(Move move, Phase phase) {
    //
    if (move.captured != Piece.Empty) {
      halfMove = 0;
    } else {
      halfMove++;
    }

    if (fullMove == 0) {
      fullMove++;
    } else if (phase.side != Side.Black) {
      fullMove++;
    }

    _history.add(move);

    if (move.captured != Piece.Empty) {
      lastCapturedPhase = phase.toFen();
    }
  }

  Move? removeLast() {
    if (_history.isEmpty) return null;
    return _history.removeLast();
  }

  get last => _history.isEmpty ? null : _history.last;

  // 自上一个咋子局面后的着法列表，反向存放在返回列表中
  List<Move> reverseMovesToPrevCapture() {
    //
    List<Move> moves = [];

    for (var i = _history.length - 1; i >= 0; i--) {
      if (_history[i].captured != Piece.Empty) break;
      moves.add(_history[i]);
    }

    return moves;
  }

  // 从 FEN 尾部两个字段解析无吃子步数和总回合数
  CCRecorder.fromCounterMarks(String marks) {
    //
    var segments = marks.split(' ');
    if (segments.length != 2) {
      throw 'Error: Invalid Counter Marks: $marks';
    }

    halfMove = int.parse(segments[0]);
    fullMove = int.parse(segments[1]);

    if (halfMove == null || fullMove == null) {
      throw 'Error: Invalid Counter Marks: $marks';
    }
  }

  @override
  String toString() {
    return '$halfMove $fullMove';
  }

  // 从着法列表生成双列文字，供对战局面显示
  String buildManualText({cols = 2}) {
    //
    var manualText = '';

    for (var i = 0; i < _history.length; i++) {
      manualText += '${i < 9 ? ' ' : ''}${i + 1}. ${_history[i].stepName}　';
      if ((i + 1) % cols == 0) manualText += '\n';
    }

    if (manualText.isEmpty) {
      manualText = '<暂无招法>';
    }

    return manualText;
  }

}
