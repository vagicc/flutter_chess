import '../cchess/cc_base.dart';
import '../cchess/phase.dart';
import 'chess_db.dart';

/// 引擎查询结果包裹
/// type 为 move 时表示正常结果反馈，value 用于携带结果值
/// type 其它可能值至少包含：timeout / nobestmove / network-error / data-error
class EngineResponse {
  final String type;
  final dynamic value;
  EngineResponse(this.type, {this.value});
}

class CloudEngine {
  /// 向云库查询某一个局面的最结着法
  /// 如果一个局面云库没有遇到过，则请求云库后台计算，并等待云库的计算结果
  Future<EngineResponse> search(Phase phase, {bool byUser = true}) async {
    //
    final fen = phase.toFen();
    var response = await ChessDB.query(fen);

    // 发生网络错误，直接返回
    if (response == null) return EngineResponse('network-error');

    if (!response.startsWith('move:')) {
      //
      print('ChessDB.query: $response\n');
      //
    } else {
      // 有着法列表返回
      // move:b2a2,score:-236,rank:0,note:? (00-00),winrate:32.85
      final firstStep = response.split('|')[0];
      print('ChessDB.query: $firstStep');

      final segments = firstStep.split(',');
      if (segments.length < 2) return EngineResponse('data-error');

      final move = segments[0], score = segments[1];

      final scoreSegments = score.split(':');
      if (scoreSegments.length < 2) return EngineResponse('data-error');

      final moveWithScore = int.tryParse(scoreSegments[1]) != null;

      // 存在有效着法
      if (moveWithScore) {
        //
        final step = move.substring(5);

        if (Move.validateEngineStep(step)) {
          return EngineResponse(
            'move',
            value: Move.fromEngineStep(step),
          );
        }
      } else {
        // 云库没有遇到过这个局面，请求它执行后台计算
        if (byUser) {
          response = await ChessDB.requestComputeBackground(fen);
          print('ChessDB.requestComputeBackground: $response\n');
        }

        // 这里每过2秒就查看它的计算结果
        return Future<EngineResponse>.delayed(
          Duration(seconds: 2),
          () => search(phase, byUser: false),
        );
      }
    }

    return EngineResponse('unknown-error');
  }
}
