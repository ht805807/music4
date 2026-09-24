import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/network/api_exception.dart';
import '../models/more_game.dart';
import '../services/games_service.dart';

class MoreGamesPage extends StatefulWidget {
  const MoreGamesPage({super.key});
  @override
  State<MoreGamesPage> createState() => _MoreGamesPageState();
}

class _MoreGamesPageState extends State<MoreGamesPage> {
  final _service = GamesService();
  late Future<List<MoreGame>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.list();
  }

  Future<void> _reload() async {
    setState(() => _future = _service.list());
    await _future;
  }

  Future<void> _open(MoreGame game) async {
    final market = Uri.parse(
        'market://details?id=${Uri.encodeComponent(game.packageName)}');
    final web = Uri.parse(
        'https://play.google.com/store/apps/details?id=${Uri.encodeComponent(game.packageName)}');
    if (!await launchUrl(market, mode: LaunchMode.externalApplication) &&
        mounted) {
      await launchUrl(web, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('更多遊戲')),
        body: FutureBuilder<List<MoreGame>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return const Center(child: CircularProgressIndicator());
            if (snapshot.hasError) {
              return _GamesFailure(
                message: snapshot.error is ApiException
                    ? (snapshot.error as ApiException).userMessage
                    : '目前無法取得更多遊戲，請確認網路連線後重試。',
                retry: _reload,
              );
            }
            final games = snapshot.data ?? [];
            if (games.isEmpty) {
              return RefreshIndicator(
                onRefresh: _reload,
                child: ListView(children: const [
                  SizedBox(height: 180),
                  Center(child: Text('目前沒有更多遊戲'))
                ]),
              );
            }
            return RefreshIndicator(
              onRefresh: _reload,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: games.length,
                itemBuilder: (_, index) => _GameCard(
                    game: games[index], onOpen: () => _open(games[index])),
              ),
            );
          },
        ),
      );
}

class _GameCard extends StatelessWidget {
  const _GameCard({required this.game, required this.onOpen});
  final MoreGame game;
  final VoidCallback onOpen;
  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _GameIcon(url: game.iconUrl),
            const SizedBox(width: 14),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(game.appName,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(game.description),
                  const SizedBox(height: 12),
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                          onPressed: onOpen,
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('前往 Google Play'))),
                ])),
          ]),
        ),
      );
}

class _GameIcon extends StatelessWidget {
  const _GameIcon({required this.url});
  final String url;
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 56,
          height: 56,
          child: url.isEmpty
              ? const ColoredBox(
                  color: Color(0xffdddddd), child: Icon(Icons.apps))
              : Image.network(url,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) => progress == null
                      ? child
                      : const Center(
                          child: SizedBox(
                              width: 22,
                              height: 22,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2))),
                  errorBuilder: (_, __, ___) => const ColoredBox(
                      color: Color(0xffdddddd), child: Icon(Icons.apps))),
        ),
      );
}

class _GamesFailure extends StatelessWidget {
  const _GamesFailure({required this.message, required this.retry});
  final String message;
  final Future<void> Function() retry;
  @override
  Widget build(BuildContext context) => Center(
      child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => retry(), child: const Text('重新整理'))
          ])));
}
