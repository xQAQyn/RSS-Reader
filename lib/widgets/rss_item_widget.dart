import 'package:flutter/material.dart';
import '../models/rss_item.dart';
import '../utils/styles.dart';

class RssItemWidget extends StatelessWidget {
  final RssItem item;
  final VoidCallback onTap;

  const RssItemWidget({required this.item, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: AppStyles.titleStyle,
              ),
              SizedBox(height: 8),
              Text(
                item.description,
                style: AppStyles.subtitleStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Text(
                'Published: ${DateTime.fromMillisecondsSinceEpoch(item.pubDate).toString()}',
                style: AppStyles.subtitleStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
