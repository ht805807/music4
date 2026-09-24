import 'package:flutter/material.dart';
import 'leaderboard/leaderboard_page.dart';
import 'more_games/more_games_page.dart';
import 'word_select.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
          body: SafeArea(
              child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/image/bg5.jpg'), fit: BoxFit.cover)),
        child: Center(
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Image.asset('assets/image/ab58e6a002a7e.png',
                        height: 72, fit: BoxFit.contain),
                    const SizedBox(height: 32),
                    _HomeButton(
                        icon: Icons.play_arrow_rounded,
                        label: '開始遊戲',
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const GamePage()))),
                    _HomeButton(
                        icon: Icons.emoji_events_outlined,
                        label: '排行榜',
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const LeaderboardPage()))),
                    _HomeButton(
                        icon: Icons.apps_rounded,
                        label: '更多遊戲',
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const MoreGamesPage()))),
                  ]),
                ))),
      )));
}

class GamePage extends StatelessWidget {
  const GamePage({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: SafeArea(child: WordSelect()));
}

class _HomeButton extends StatelessWidget {
  const _HomeButton(
      {required this.icon, required this.label, required this.onPressed});
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
              icon: Icon(icon), label: Text(label), onPressed: onPressed)));
}
