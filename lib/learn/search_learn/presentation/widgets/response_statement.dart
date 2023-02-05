class Statement {
  final int id;
  final String content;
  final List<String> tags;
  bool bookmarked;

  Statement(
      {required this.id,
        required this.content,
        required this.tags,
        required this.bookmarked});

  factory Statement.fromJSON(Map<String, dynamic> json) {
    return Statement(
        id: json['id'],
        content: json['content'],
        tags: json['tags'],
        bookmarked: json['bookmarked'],
    );
  }
}