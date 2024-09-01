class CommentEntity {
  final int id;
  final String content;
  final String title;
  final String date;
  final String email;

  CommentEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        content = json['content'],
        date = json['date'],
        title = json['title'],
        email = json['author']['email'];
}
