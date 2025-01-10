import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import '../models/rss_feed.dart';
import '../models/rss_item.dart';
import '../repositories/rss_repository.dart';

class RssService {
  final RssRepository _rssRepository = RssRepository();

  Future<void> fetchRssFeed(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(response.body);
      final channel = document.findElements('channel').first;

      final feedTitle = channel.findElements('title').first.text;
      final feed = RssFeed(
        title: feedTitle,
        url: url,
        lastUpdated: DateTime.now().millisecondsSinceEpoch,
      );

      final feedId = await _rssRepository.insertFeed(feed);

      final items = channel.findElements('item').map((element) {
        return RssItem(
          feedId: feedId,
          title: element.findElements('title').first.text,
          description: element.findElements('description').first.text,
          link: element.findElements('link').first.text,
          pubDate: DateTime.parse(element.findElements('pubDate').first.text).millisecondsSinceEpoch,
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
