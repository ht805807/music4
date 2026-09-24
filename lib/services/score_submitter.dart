import 'package:flutter/material.dart';
import '../core/network/api_exception.dart';
import '../core/storage/player_store.dart';
import '../main.dart';
import 'leaderboard_service.dart';

class ScoreSubmitter {
  ScoreSubmitter._();
  static final instance = ScoreSubmitter._();
  final _service = LeaderboardService();
  bool _submitting = false;
  Future<void> submitCompletedLevel(BuildContext context, int score) async {
    if (_submitting) return;
    _submitting = true;
    try {
      var name = await PlayerStore.instance.name();
      if ((name ?? '').trim().isEmpty && context.mounted)
        name = await _askName(context);
      if ((name ?? '').trim().isEmpty) return;
      final result = await _service.submit({
        'player_id': await PlayerStore.instance.ensurePlayerId(),
        'player_name': name!.trim(),
        'score': score,
        'game_key': 'main_game',
        'app_version': appVersion
      });
      if (context.mounted && result['is_new_record'] == true)
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('已更新排行榜最佳成績！')));
    } on ApiException {
      // Online ranking is optional: the completed game remains completed.
    } finally {
      _submitting = false;
    }
  }

  Future<String?> _askName(BuildContext context) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final value = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
              title: const Text('設定排行榜名稱'),
              content: Form(
                  key: formKey,
                  child: TextFormField(
                      controller: controller,
                      autofocus: true,
                      maxLength: 20,
                      decoration: const InputDecoration(hintText: '2～20 字'),
                      validator: (v) {
                        final s = v?.trim() ?? '';
                        if (s.runes.length < 2 || s.runes.length > 20)
                          return '名稱需為 2～20 字';
                        if (RegExp(r'[<>]').hasMatch(s))
                          return '名稱不可包含 HTML 字元';
                        return null;
                      })),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('稍後再說')),
                ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate())
                        Navigator.pop(dialogContext, controller.text.trim());
                    },
                    child: const Text('送出'))
              ],
            ));
    controller.dispose();
    if (value != null) await PlayerStore.instance.saveName(value);
    return value;
  }
}
