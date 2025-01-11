import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rss_reader/views/home_page.dart';
import 'package:rss_reader/views/detail_page.dart';
import 'package:rss_reader/models/rss_item.dart';
import 'package:rss_reader/models/rss_feed.dart';
import 'package:rss_reader/services/database_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    final dbHelper = DatabaseHelper();
    dbHelper.clearDatabase();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RSS Reader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue.shade50,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          elevation: 2,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: const HomePage(),
      routes: {
        '/detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final items = args['items'] as List<RssItem>;
          final feed = args['feed'] as RssFeed;
          return DetailPage(items: items, feed: feed);
        },
      },
    );
  }
}
