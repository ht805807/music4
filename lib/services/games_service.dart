import '../core/network/api_service.dart';
import '../models/more_game.dart';

class GamesService {
  GamesService({ApiService? api}) : _api = api ?? ApiService();
  final ApiService _api;
  Future<List<MoreGame>> list() async {
    final d = await _api.get('games/list.php');
    if (d is! List) throw const FormatException();
    return d
        .whereType<Map>()
        .map((e) => MoreGame.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
