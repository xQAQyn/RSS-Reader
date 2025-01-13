import 'package:flutter/material.dart';
import 'package:rss_reader/models/rss_item.dart';
import '../models/rss_feed.dart';
import '../widgets/feed_list_widget.dart';
import '../services/rss_service.dart';
import '../utils/styles.dart';
import '../repositories/rss_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RssService _rssService = RssService();
  final RssRepository _rssRepository = RssRepository();
  List<RssFeed> feeds = [];

  @override
  void initState() {
    super.initState();
    _loadFeeds();
  }

  Future<void> _loadFeeds() async {
    List<RssFeed> feedsData = await _rssRepository.getFeeds();
    setState(() {
      feeds = feedsData;
    });
  }

  Future<void> _addFeed() async {
    final url = await showDialog<String>(
      context: context,
      builder: (context) {
        String url = '';
        return AlertDialog(
          title: Text('Add RSS Feed'),
          content: TextField(
            decoration: InputDecoration(hintText: 'Enter RSS Feed URL'),
            onChanged: (value) => url = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, url),
              child: Text('Add'),
            ),
          ],
        );
      },
    );

    if (url != null && url.isNotEmpty) {
      await _rssService.fetchRssFeed(url);
      _loadFeeds();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RSS Reader'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addFeed,
          ),
        ],
      ),
      body: Container(
        decoration: AppStyles.pageBackground,
        child: feeds.isEmpty
            ? Center(
                child: Text(
                  'No feeds added',
                  style: AppStyles.titleStyle,
                ),
              )
            : FeedListWidget(
                feeds: feeds,
                onFeedTap: (feed) async {
                  int nonNullFeedId = feed.id!;
                  List<RssItem> items = await _rssRepository.getItemsByFeedId(nonNullFeedId);
                  Navigator.pushNamed(
                    context, 
                    '/detail',
                    arguments: {
                      'items': items,
                      'feed': feed,
                    },
                  );
                },
                onFeedDelete: (feed) async {
                  bool? confirmDelete = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Delete Feed'),
                        content: Text('Are you sure you want to delete this feed?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                  if (confirmDelete != null && confirmDelete) {
                    await _rssRepository.deleteFeed(feed.id!);
                    _loadFeeds();
                  }
                },
              ),

      ),
    );
  }
}
