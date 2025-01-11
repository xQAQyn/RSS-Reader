import 'package:flutter/material.dart';
import '../models/rss_item.dart';
import '../widgets/rss_item_widget.dart';
import '../utils/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatelessWidget {
  final List<RssItem> items;

  const DetailPage({required this.items, super.key});

  Future<void> _launchUrl(String url) async {
    Uri? uri = Uri.tryParse(url);
    if (uri == null) {
      throw Exception('Invalid URL format');
    }

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RSS Items'),
      ),
      body: Container(
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
    );
  }
}
