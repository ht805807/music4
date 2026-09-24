import 'package:flutter_test/flutter_test.dart';
import 'package:music4/main.dart';

void main() {
  testWidgets('home exposes the three primary actions', (tester) async {
    await tester.pumpWidget(const MusicGameApp());

    expect(find.text('開始遊戲'), findsOneWidget);
    expect(find.text('排行榜'), findsOneWidget);
    expect(find.text('更多遊戲'), findsOneWidget);
  });
}
