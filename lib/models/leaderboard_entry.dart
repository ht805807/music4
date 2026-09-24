class LeaderboardEntry {
  const LeaderboardEntry(
      {required this.rank,
      required this.playerName,
      required this.score,
      required this.updatedAt});
  final int rank, score;
  final String playerName, updatedAt;
  factory LeaderboardEntry.fromJson(Map<String, dynamic> j) => LeaderboardEntry(
      rank: j['rank'] is int ? j['rank'] : int.tryParse('${j['rank']}') ?? 0,
      playerName: j['player_name'] as String? ?? '玩家',
      score:
          j['score'] is int ? j['score'] : int.tryParse('${j['score']}') ?? 0,
      updatedAt: j['updated_at'] as String? ?? '');
}
