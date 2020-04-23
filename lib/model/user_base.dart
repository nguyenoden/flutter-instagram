class UserBase {
  final String id;
  final String userName;
  final String imageUrl;

  UserBase({this.id, this.userName, this.imageUrl});

  @override
  String toString() {
    return 'UserBase{id: $id, userName: $userName, imageUrl: $imageUrl}';
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['id'] = id;
    map['userName'] = userName;
    map['imageUrl'] = imageUrl;

    return map;
  }
}
