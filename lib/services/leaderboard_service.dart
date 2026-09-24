import '../core/network/api_service.dart';
import '../models/leaderboard_entry.dart';

class LeaderboardService {
  LeaderboardService({ApiService? api}) : _api = api ?? ApiService();
  final ApiService _api;
  Future<List<LeaderboardEntry>> list(String key) async {
    final d = await _api
        .get('leaderboard/list.php', query: {'game_key': key, 'limit': '100'});
    if (d is! List) throw const FormatException();
    return d
        .whereType<Map>()
        .map((e) => LeaderboardEntry.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<Map<String, dynamic>> submit(Map<String, dynamic> payload) async {
    final d = await _api.post('scores/submit.php', payload);
    return d is Map ? Map<String, dynamic>.from(d) : {};
  }
}
