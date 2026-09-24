import 'package:flutter/material.dart';
import 'core/config/api_config.dart';
import 'core/storage/player_store.dart';
import 'home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PlayerStore.instance.ensurePlayerId();
  runApp(const MusicGameApp());
}

class MusicGameApp extends StatelessWidget {
  const MusicGameApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: '猜歌遊戲',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xff314d93)),
            useMaterial3: true),
        home: const HomePage(),
      );
}

class MyApp extends MusicGameApp {
  const MyApp({super.key});
}

const String appVersion =
    String.fromEnvironment('APP_VERSION', defaultValue: '1.0.5');
const String apiBaseUrl = ApiConfig.baseUrl;
