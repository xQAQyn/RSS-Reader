import '../models/rss_feed.dart';
import '../models/rss_item.dart';
import '../services/database_helper.dart';

class RssRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertFeed(RssFeed feed) async {
    final existingFeed = await _databaseHelper.getFeedByUrl(feed.url);
    if (existingFeed == null) {
      return await _databaseHelper.insertFeed(feed.toMap());
    }
    return existingFeed['id'];
  }

  Future<void> insertItems(List<RssItem> items) async {
    for (var item in items) {
      final existingItem = await _databaseHelper.getItemByLink(item.link);
      if (existingItem == null) {
        await _databaseHelper.insertItem(item.toMap());
      }
    }
  }

  Future<List<RssFeed>> getFeeds() async {
    final feeds = await _databaseHelper.getFeeds();
    return feeds.map((map) => RssFeed.fromMap(map)).toList();
  }

  Future<List<RssItem>> getItemsByFeedId(int feedId) async {
    final items = await _databaseHelper.getItemsByFeedId(feedId);
    return items.map((map) => RssItem.fromMap(map)).toList();
  }

  Future<void> updateFeedLastUpdated(int feedId, int lastUpdated) async {
    await _databaseHelper.updateFeedLastUpdated(feedId, lastUpdated);
  }

  Future<void> deleteFeed(int feedId) async {
    await _databaseHelper.deleteFeed(feedId);
  }

  Future<RssFeed?> getFeedById(int id) async {
    final feed = await _databaseHelper.getFeedById(id);
    return feed != null ? RssFeed.fromMap(feed) : null;
  }
}
