class Post {
  final String host;
  final String eid;
  final String giSid;
  final String au;
  final String tm;
  final String username;
  final String userId;
  final String token;
  Post({this.host, this.eid, this.giSid, this.au, this.tm, this.username, this.userId, this.token });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      host: json['host'],
      eid: json['eid'],
      giSid: json['gis_sid'],
      au: json['au'],
      tm: json['tm'],
      username: json['user'],
      userId: json['userId'],
      token: json['userId'],
    );
  }
}