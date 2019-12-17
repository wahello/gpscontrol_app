class Post {
  final String eid;
  final String giSid;
  final String au;
  final int tm;
  final String username;
  final int userId;
  final String token;
  Post({this.eid, this.giSid, this.au, this.tm, this.username, this.userId, this.token });

  factory Post.fromJson(Map<String, dynamic> json,Map<String, dynamic> ujson,String token) {
    return Post(
      eid: json['eid'],
      giSid: json['gis_sid'],
      au: json['au'],
      tm: json['tm'],
      username: ujson['nm'],
      userId: ujson['id'],
      token: token,
    );
  }
}