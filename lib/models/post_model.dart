class Post {
  String? userId;
  String title;
  String content;
  String imgUrl;

  Post({
    required this.content,
    required this.title,
    required this.userId,
    required this.imgUrl,
  });

  Post.fromJson(Map<String, dynamic> json)
  : userId = json['userId'],
  title = json['title'],
  content = json['content'],
  imgUrl = json['imgUrl'];

  Map<String, dynamic> toJson() => {
    'userId' : userId,
    'title' : title,
    'content' : content,
    'imgUrl' : imgUrl,
  };
}
