import 'package:flutter/material.dart';

import '../core/network/api_exception.dart';
import '../models/leaderboard_entry.dart';
import '../services/leaderboard_service.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final _service = LeaderboardService();
  late Future<List<LeaderboardEntry>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.list('main_game');
  }

  Future<void> _reload() async {
    setState(() => _future = _service.list('main_game'));
    await _future;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('排行榜')),
        body: FutureBuilder<List<LeaderboardEntry>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _Failure(
                message: snapshot.error is ApiException
                    ? (snapshot.error as ApiException).userMessage
                    : '目前無法取得排行榜，請確認網路連線後重試。',
                retry: _reload,
              );
            }
            final entries = snapshot.data ?? [];
            if (entries.isEmpty) {
              return RefreshIndicator(
                onRefresh: _reload,
                child: ListView(children: const [
                  SizedBox(height: 180),
                  Center(child: Text('目前尚無排行榜資料'))
                ]),
              );
            }
            return RefreshIndicator(
              onRefresh: _reload,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: entries.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, index) {
                  final entry = entries[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${entry.rank}')),
                    title: Text(entry.playerName,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(entry.updatedAt),
                    trailing: Text('${entry.score}',
                        style: Theme.of(context).textTheme.titleMedium),
                  );
                },
              ),
            );
          },
        ),
      );
}

class _Failure extends StatelessWidget {
  const _Failure({required this.message, required this.retry});
  final String message;
  final Future<void> Function() retry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => retry(), child: const Text('重新整理')),
          ]),
        ),
      );
}
