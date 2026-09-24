import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class PlayerStore {
  PlayerStore._();
  static final instance = PlayerStore._();
  static const _idKey = 'anonymous_player_id', _nameKey = 'player_name';
  Future<Object> ensurePlayerId() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_idKey) ?? _createId(p);
  }

  Future<String> _createId(SharedPreferences p) async {
    final id = const Uuid().v4();
    await p.setString(_idKey, id);
    return id;
  }

  Future<String?> name() async =>
      (await SharedPreferences.getInstance()).getString(_nameKey);
  Future<void> saveName(String v) async =>
      (await SharedPreferences.getInstance()).setString(_nameKey, v.trim());
}
