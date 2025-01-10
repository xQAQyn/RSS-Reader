class RssFeed {
  int? id;
  String title;
  String url;
  int lastUpdated;

  RssFeed({this.id, required this.title, required this.url, required this.lastUpdated});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'last_updated': lastUpdated,
    };
  }
}
