import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:meal_app/main.dart';
import 'package:meal_app/providers/meal_provider.dart';

void main() {
  testWidgets('Test Meal App Widget', (WidgetTester tester) async {
    // Membangun aplikasi dan memicu frame
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => MealProvider(),
        child: MyApp(),
      ),
    );

    // Memverifikasi apakah AppBar mengandung judul
    expect(find.text('Meal App'), findsOneWidget);

    // Memverifikasi apakah field pencarian ada
    expect(find.byType(TextField), findsOneWidget);

    // Memasukkan teks pencarian dan menekan tombol pencarian
    await tester.enterText(find.byType(TextField), 'chicken');
    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();

    // Menunggu data diambil dan UI diperbarui
    await tester.pump(Duration(seconds: 2));

    // Memverifikasi apakah daftar makanan ditampilkan
    expect(find.byType(ListView), findsOneWidget);

    // Memverifikasi apakah setidaknya satu item makanan ditampilkan
    expect(find.byType(ListTile), findsWidgets);
  });

  testWidgets('Test Meal Detail Navigation', (WidgetTester tester) async {
    // Membangun aplikasi dan memicu frame
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => MealProvider(),
        child: MyApp(),
      ),
    );

    // Menunggu data diambil dan UI diperbarui
    await tester.pump(Duration(seconds: 2));

    // Menekan item makanan pertama
    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();

    // Memverifikasi apakah layar detail makanan ditampilkan
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Category:'), findsOneWidget);
    expect(find.text('Area:'), findsOneWidget);
  });
}
