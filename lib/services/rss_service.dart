import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/rss_feed.dart';
import '../models/rss_item.dart';
import '../repositories/rss_repository.dart';
import 'package:rss_dart/dart_rss.dart' as rss;
import 'package:intl/intl.dart';

class RssService {
  final RssRepository _rssRepository = RssRepository();

  Future<void> fetchRssFeed(String url) async {
    final response = await http.get(Uri.parse(url.trim()));
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }
      final feedData = rss.RssFeed.parse(response.body);

      final feed = RssFeed(
        title: feedData.title!,
        url: url,
        lastUpdated: DateTime.now().millisecondsSinceEpoch,
      );

      final feedId = await _rssRepository.insertFeed(feed);

      final DateFormat format = DateFormat('EEE, dd MMM yyyy HH:mm:ss Z', 'en_US');

      final items = feedData.items.map((element) {
        return RssItem(
          feedId: feedId,
          title: element.title!,
          description: element.description!,
          link: element.link!,
          pubDate: format.parse(element.pubDate!).millisecondsSinceEpoch,
        );
      }).toList();

      await _rssRepository.insertItems(items);
    } else {
      throw Exception('Failed to load RSS feed');
    }
  }

  Future<void> updateRssFeed(int id) async {
    final feed = await _rssRepository.getFeedById(id);
    if (feed != null) {
      fetchRssFeed(feed.url);
    } else {
      throw Exception('Feed not found');
    }
  }
}
