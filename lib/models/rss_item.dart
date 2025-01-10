class RssItem {
  int? id;
  int feedId;
  String title;
  String description;
  String link;
  int pubDate;
  bool isRead;

  RssItem({this.id, required this.feedId, required this.title, required this.description, required this.link, required this.pubDate, this.isRead = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'feed_id': feedId,
      'title': title,
      'description': description,
      'link': link,
      'pub_date': pubDate,
      'is_read': isRead ? 1 : 0,
    };
  }

  factory RssItem.fromMap(Map<String, dynamic> map) {
    return RssItem(
      id: map['id'],
      feedId: map['feed_id'],
      title: map['title'],
      description: map['description'],
      link: map['link'],
      pubDate: map['pub_date'],
      isRead: map['is_read'] == 1,
    );
  }
}
