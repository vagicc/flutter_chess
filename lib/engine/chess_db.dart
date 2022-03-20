import 'dart:convert';
import 'dart:io';

class ChessDB {
  static const Host = 'www.chessdb.cn'; //云库服务器
  static const Path = '/chessdb.php'; //API路径

  // 向云库查询最佳着法
  static Future<String?> query(String board) async {
    Uri url = Uri(
      scheme: 'http',
      host: Host,
      path: Path,
      queryParameters: {
        'action': 'queryall',
        'learn': '1',
        'showall': '1',
        'board': board,
      },
    );

    final httpClient = HttpClient();

    try {
      final request = await httpClient.getUrl(url);
      final response = await request.close();
      return await response.transform(utf8.decoder).join();
    } catch (e) {
      print('向云库查询最佳着法接口出错Error: $e');
    } finally {
      httpClient.close();
    }

    return null;
  }

  //请求云库在后台计算指定局面的最佳着法
  static Future<String?> requestComputeBackground(String board) async {
    Uri url = Uri(
      scheme: 'http',
      host: Host,
      path: Path,
      queryParameters: {
        'action': 'queue',
        'board': board,
      },
    );

    final httpClient = HttpClient();

    try {
      final request = await httpClient.getUrl(url);
      final response = await request.close();
      return await response.transform(utf8.decoder).join();
    } catch (e) {
      print("云库在后台计算指定局面的最佳着法时出错Errror: $e");
    }finally {
      httpClient.close();
    }
    return null;
  }
}
