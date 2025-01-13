import 'package:flutter/material.dart';
import '../models/rss_feed.dart';
import '../utils/styles.dart';

class FeedListWidget extends StatelessWidget {
  final List<RssFeed> feeds;
  final Function(RssFeed) onFeedTap;
  final Function(RssFeed) onFeedDelete;

  const FeedListWidget({required this.feeds, required this.onFeedTap, super.key, required this.onFeedDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: feeds.length,
      itemBuilder: (context, index) {
        final feed = feeds[index];
        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: () => onFeedTap(feed),
            onLongPress: () => onFeedDelete(feed),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feed.title,
                    style: AppStyles.titleStyle,
                  ),
                  SizedBox(height: 8),
                  Text(
                    feed.url,
                    style: AppStyles.subtitleStyle,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
