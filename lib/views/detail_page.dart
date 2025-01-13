import 'package:flutter/material.dart';
import 'package:rss_reader/repositories/rss_repository.dart';
import 'package:rss_reader/services/rss_service.dart';
import '../models/rss_item.dart';
import '../models/rss_feed.dart';
import '../widgets/rss_item_widget.dart';
import '../utils/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final RssFeed feed;
  final List<RssItem> items;

  DetailPage({required this.feed, required this.items});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late List<RssItem> items;
  final RssService _rssService = RssService();
  final RssRepository _rssRepository = RssRepository();

  @override
  void initState() {
    super.initState();
    items = widget.items;
  }

  Future<void> _launchUrl(String url) async {
    Uri? uri = Uri.tryParse(url);
    if (uri == null) {
      throw Exception('Invalid URL format');
    }

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _refreshItems() async {
    try {
      await _rssService.updateRssFeed(widget.feed.id!);
      final newItems = await _rssRepository.getItemsByFeedId(widget.feed.id!);
      setState(() {
        items = newItems;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to refresh items: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.feed.title),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshItems,
        child: Container(
          decoration: AppStyles.pageBackground,
          child: ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return RssItemWidget(
                item: item,
                onTap: () {
                  try {
                    _launchUrl(item.link);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}